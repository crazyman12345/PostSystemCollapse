function weapon_combat_power_hit_chance(_half_target_angle, _accuracy_spread, _pellet_spread)
{
    var _wide_spread = max(_accuracy_spread, _pellet_spread);
    var _narrow_spread = min(_accuracy_spread, _pellet_spread);

    if (_wide_spread <= 0) return 1;
    if (_half_target_angle >= _wide_spread + _narrow_spread) return 1;

    if (_narrow_spread <= 0)
        return clamp(_half_target_angle / _wide_spread, 0, 1);

    if (_half_target_angle <= _wide_spread - _narrow_spread)
        return clamp(_half_target_angle / _wide_spread, 0, 1);

    var _miss_width = _wide_spread + _narrow_spread - _half_target_angle;
    return clamp(1 - sqr(_miss_width) / (4 * _wide_spread * _narrow_spread), 0, 1);
}

function weapon_combat_power_damage_distribution(_weapon, _hit_chance, _pellet_count, _damage_multiplier)
{
    var _damage_min = round(_weapon.damage_min);
    var _damage_max = round(_weapon.damage_max);
    var _damage_values = _damage_max - _damage_min + 1;
    var _pellet_damage = array_create(_damage_max + 1, 0);
    _pellet_damage[0] = 1 - _hit_chance;

    for (var _damage = _damage_min; _damage <= _damage_max; _damage++)
    {
        var _adjusted_damage = round(_damage * _damage_multiplier);
        _pellet_damage[_adjusted_damage] += _hit_chance / _damage_values;
    }

    var _attack_damage = [1];

    for (var _pellet = 0; _pellet < _pellet_count; _pellet++)
    {
        var _combined_damage = array_create(array_length(_attack_damage) + _damage_max, 0);

        for (var _current_damage = 0; _current_damage < array_length(_attack_damage); _current_damage++)
        {
            if (_attack_damage[_current_damage] <= 0) continue;

            for (var _added_damage = 0; _added_damage <= _damage_max; _added_damage++)
            {
                if (_pellet_damage[_added_damage] <= 0) continue;
                _combined_damage[_current_damage + _added_damage]
                    += _attack_damage[_current_damage] * _pellet_damage[_added_damage];
            }
        }

        _attack_damage = _combined_damage;
    }

    return _attack_damage;
}

function weapon_combat_power_target_width()
{
    // These are the five Level-1 enemies represented by the 20, 24, 28, 30 and 32 HP breakpoints.
    var _sprites = [spr_burst_shooter_run, spr_spinner_run, spr_wallrusher_idle_4, spr_knife_stalker_run, spr_dasher_idle];
    var _size_multipliers = [1, 1, 1.2, 1, 1];
    var _projected_width_total = 0;

    for (var i = 0; i < array_length(_sprites); i++)
    {
        var _sprite = _sprites[i];
        var _bbox_width = sprite_get_bbox_right(_sprite) - sprite_get_bbox_left(_sprite);
        var _bbox_height = sprite_get_bbox_bottom(_sprite) - sprite_get_bbox_top(_sprite);
        var _scale = 0.75 * (40 / (_bbox_height + 1)) * _size_multipliers[i];
        var _collision_width = _bbox_width * _scale + 8;
        var _collision_height = _bbox_height * _scale + 8;

        // Mean projected width of an axis-aligned rectangle over all attack directions.
        _projected_width_total += 2 * (_collision_width + _collision_height) / pi;
    }

    return _projected_width_total / array_length(_sprites);
}

function weapon_combat_power_scenario(_weapon, _distance, _target_width, _turn_time, _shot_interval, _reload_time, _pellet_count, _pellet_spread)
{
    var _half_target_angle = arctan((_target_width * 0.5) / _distance);
    var _accuracy_spread = (100 - clamp(_weapon.accuracy, 0, 100)) * 0.1;
    var _hit_chance = weapon_combat_power_hit_chance(_half_target_angle, _accuracy_spread, _pellet_spread);
    var _damage_multiplier = 1;

    if (variable_struct_exists(_weapon, "damage_falloff_start")
        && variable_struct_exists(_weapon, "damage_falloff_end")
        && variable_struct_exists(_weapon, "damage_falloff_minimum")
        && _weapon.damage_falloff_end > _weapon.damage_falloff_start)
    {
        var _falloff_amount = clamp(
            (_distance - _weapon.damage_falloff_start)
            / (_weapon.damage_falloff_end - _weapon.damage_falloff_start),
            0,
            1
        );
        _damage_multiplier = lerp(1, _weapon.damage_falloff_minimum, _falloff_amount);
    }

    var _damage_distribution = weapon_combat_power_damage_distribution(_weapon, _hit_chance, _pellet_count, _damage_multiplier);
    var _enemy_hp = [20, 24, 28, 30, 32];
    var _max_hp = 32;
    var _mag_size = round(_weapon.mag_size);
    var _time_to_kill = array_create(_max_hp + 1);
    var _reload_delay = max(_reload_time, _shot_interval);

    _time_to_kill[0] = array_create(_mag_size + 1, 0);

    for (var _hp = 1; _hp <= _max_hp; _hp++)
    {
        var _constant = array_create(_mag_size + 1, 0);
        var _full_mag_factor = array_create(_mag_size + 1, 0);
        _time_to_kill[_hp] = array_create(_mag_size + 1, 0);

        for (var _rounds = 1; _rounds <= _mag_size; _rounds++)
        {
            var _delay = _rounds == 1 ? _reload_delay : _shot_interval;

            for (var _damage = 0; _damage < min(_hp, array_length(_damage_distribution)); _damage++)
            {
                var _probability = _damage_distribution[_damage];
                if (_probability <= 0) continue;

                _constant[_rounds] += _probability * _delay;

                if (_damage == 0)
                {
                    if (_rounds == 1)
                    {
                        _full_mag_factor[_rounds] += _probability;
                    }
                    else
                    {
                        _constant[_rounds] += _probability * _constant[_rounds - 1];
                        _full_mag_factor[_rounds] += _probability * _full_mag_factor[_rounds - 1];
                    }
                }
                else
                {
                    var _next_rounds = _rounds == 1 ? _mag_size : _rounds - 1;
                    _constant[_rounds] += _probability * _time_to_kill[_hp - _damage][_next_rounds];
                }
            }
        }

        var _denominator = max(0.000001, 1 - _full_mag_factor[_mag_size]);
        var _full_mag_time = _constant[_mag_size] / _denominator;

        for (var _rounds = 1; _rounds <= _mag_size; _rounds++)
            _time_to_kill[_hp][_rounds] = _constant[_rounds] + _full_mag_factor[_rounds] * _full_mag_time;
    }

    var _travel_time = _distance / (_weapon.bullet_speed * 60);
    var _effectiveness = 0;

    for (var i = 0; i < array_length(_enemy_hp); i++)
    {
        var _hp = _enemy_hp[i];
        var _engagement_time = _turn_time + _travel_time + _time_to_kill[_hp][_mag_size];
        _effectiveness += _hp / max(0.000001, _engagement_time);
    }

    return {
        effectiveness: _effectiveness / array_length(_enemy_hp),
        hit_chance: _hit_chance,
        expected_pellet_hits: _hit_chance * _pellet_count
    };
}

function weapon_calculate_gear_score(_weapon)
{
    if (!is_struct(_weapon)) return 0;

    var _required_stats = ["damage_min", "damage_max", "fire_rate", "mag_size", "reload_time", "bullet_speed", "accuracy", "handling"];

    for (var i = 0; i < array_length(_required_stats); i++)
    {
        var _stat_name = _required_stats[i];
        if (!variable_struct_exists(_weapon, _stat_name)) return 0;
        if (!is_real(variable_struct_get(_weapon, _stat_name))) return 0;
    }

    if (_weapon.damage_min < 0 || _weapon.damage_max < _weapon.damage_min) return 0;
    if (_weapon.damage_min != round(_weapon.damage_min) || _weapon.damage_max != round(_weapon.damage_max)) return 0;
    if (_weapon.fire_rate <= 0 || _weapon.mag_size <= 0 || _weapon.mag_size != round(_weapon.mag_size)) return 0;
    if (_weapon.reload_time < 0 || _weapon.bullet_speed <= 0) return 0;

    var _pellet_count = variable_struct_exists(_weapon, "pellet_count") ? _weapon.pellet_count : 1;
    var _pellet_spread = variable_struct_exists(_weapon, "pellet_spread") ? max(0, _weapon.pellet_spread) : 0;
    var _damage_falloff_start = variable_struct_exists(_weapon, "damage_falloff_start") ? _weapon.damage_falloff_start : 0;
    var _damage_falloff_end = variable_struct_exists(_weapon, "damage_falloff_end") ? _weapon.damage_falloff_end : 0;
    var _damage_falloff_minimum = variable_struct_exists(_weapon, "damage_falloff_minimum") ? _weapon.damage_falloff_minimum : 1;

    if (!is_real(_pellet_count) || _pellet_count <= 0 || _pellet_count != round(_pellet_count)) return 0;
    if (!is_real(_pellet_spread)) return 0;
    if (!is_real(_damage_falloff_start) || !is_real(_damage_falloff_end) || !is_real(_damage_falloff_minimum)) return 0;

    if (variable_struct_exists(_weapon, "combat_power_cache"))
    {
        var _cache = _weapon.combat_power_cache;
        if (is_struct(_cache)
            && _cache.damage_min == _weapon.damage_min
            && _cache.damage_max == _weapon.damage_max
            && _cache.fire_rate == _weapon.fire_rate
            && _cache.mag_size == _weapon.mag_size
            && _cache.reload_time == _weapon.reload_time
            && _cache.bullet_speed == _weapon.bullet_speed
            && _cache.accuracy == _weapon.accuracy
            && _cache.handling == _weapon.handling
            && _cache.pellet_count == _pellet_count
            && _cache.pellet_spread == _pellet_spread
            && _cache.damage_falloff_start == _damage_falloff_start
            && _cache.damage_falloff_end == _damage_falloff_end
            && _cache.damage_falloff_minimum == _damage_falloff_minimum)
        {
            return _cache.combat_power;
        }
    }

    // The arena is 400x400. Close uses the 60px melee reach, medium is the midpoint
    // of the 120-200px shotgun dash, and long is 75% of the arena width.
    var _distances = [60, 160, 300];
    var _weights = [0.30, 0.50, 0.20];
    var _target_width = weapon_combat_power_target_width();
    var _handling_amount = (clamp(_weapon.handling, 0, 100) - 20) / 80;
    var _turn_speed = max(1, lerp(270, 990, _handling_amount));
    var _turn_time = 90 / _turn_speed;
    var _shot_interval = max(1, round(60 / _weapon.fire_rate)) / 60;
    var _reload_time = _weapon.reload_time / 60;
    var _scenarios = array_create(3);
    var _combat_power = 0;

    for (var i = 0; i < array_length(_distances); i++)
    {
        _scenarios[i] = weapon_combat_power_scenario(
            _weapon, _distances[i], _target_width, _turn_time, _shot_interval,
            _reload_time, _pellet_count, _pellet_spread
        );
        _combat_power += _scenarios[i].effectiveness * _weights[i];
    }

    _combat_power = round(_combat_power * 10) / 10;
    _weapon.combat_power_cache = {
        damage_min: _weapon.damage_min,
        damage_max: _weapon.damage_max,
        fire_rate: _weapon.fire_rate,
        mag_size: _weapon.mag_size,
        reload_time: _weapon.reload_time,
        bullet_speed: _weapon.bullet_speed,
        accuracy: _weapon.accuracy,
        handling: _weapon.handling,
        pellet_count: _pellet_count,
        pellet_spread: _pellet_spread,
        damage_falloff_start: _damage_falloff_start,
        damage_falloff_end: _damage_falloff_end,
        damage_falloff_minimum: _damage_falloff_minimum,
        combat_power: _combat_power,
        close_effectiveness: _scenarios[0].effectiveness,
        medium_effectiveness: _scenarios[1].effectiveness,
        long_effectiveness: _scenarios[2].effectiveness,
        close_hit_chance: _scenarios[0].hit_chance,
        medium_hit_chance: _scenarios[1].hit_chance,
        long_hit_chance: _scenarios[2].hit_chance,
        close_expected_pellet_hits: _scenarios[0].expected_pellet_hits,
        medium_expected_pellet_hits: _scenarios[1].expected_pellet_hits,
        long_expected_pellet_hits: _scenarios[2].expected_pellet_hits
    };

    return _combat_power;
}
