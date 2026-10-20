function player_health_update()
{
    var _seconds = frame_scale / 60;
    var _bleed_removed = false;
    for (var i = 0; i < array_length(health_limbs); i++)
    {
        var _limb = health_limbs[i];
        var _remaining_bleeds = [];
        for (var j = 0; j < array_length(_limb.bleeds); j++)
        {
            var _bleed = _limb.bleeds[j];
            var _elapsed = _seconds;
            if (_bleed.type == LimbBleedState.LIGHT)
                _elapsed = min(_elapsed, max(0, _bleed.recovery_remaining));

            _bleed.tick_remaining -= _elapsed;
            while (_bleed.tick_remaining <= 0 && raid_player_hp > 0)
            {
                if (_limb.hp > 0) player_health_damage_limb(i, health_config.bleed_damage, false);
                else player_health_apply_global_damage(health_config.bleed_damage);
                _bleed.tick_remaining += _bleed.type == LimbBleedState.LIGHT
                    ? health_config.light_bleed_interval_seconds
                    : health_config.heavy_bleed_interval_seconds;
            }

            if (_bleed.type == LimbBleedState.LIGHT)
            {
                _bleed.recovery_remaining = max(0, _bleed.recovery_remaining - _seconds);
                if (_bleed.recovery_remaining <= 0)
                {
                    _bleed_removed = true;
                    continue;
                }
            }
            array_push(_remaining_bleeds, _bleed);
        }

        _limb.bleeds = _remaining_bleeds;
        player_health_sync_limb_bleed_state(_limb);
        health_limbs[i] = _limb;
    }

    if (_bleed_removed) save_mark_dirty();
    health_painkiller_remaining = max(0, health_painkiller_remaining - _seconds);
}

function player_health_update_post_raid_recovery()
{
    var _seconds = frame_scale / 60;
    var _duration = max(1, health_config.post_raid_recovery_seconds);
    var _changed = false;

    if (raid_player_hp < raid_player_max_hp)
    {
        raid_player_hp = min(raid_player_max_hp, raid_player_hp + ((raid_player_max_hp / _duration) * _seconds));
        _changed = true;
    }

    for (var i = 0; i < array_length(health_limbs); i++)
    {
        var _limb = health_limbs[i];
        if (_limb.hp < _limb.max_hp)
        {
            var _full_recovery = max(1, _limb.max_hp - health_config.blacked_repair_hp);
            _limb.hp = min(_limb.max_hp, _limb.hp + ((_full_recovery / _duration) * _seconds));
            player_health_update_limb_state(_limb);
            _changed = true;
        }

        if (_limb.hp >= _limb.max_hp)
        {
            if (_limb.fractured)
            {
                _limb.fractured = false;
                _changed = true;
            }
            if (array_length(_limb.bleeds) > 0)
            {
                _limb.bleeds = [];
                _limb.bleed = LimbBleedState.NONE;
                _changed = true;
            }
        }
        health_limbs[i] = _limb;
    }

    if (!_changed) return;
    player_health_sync_crew();
    if (!save_dirty) save_mark_dirty();
}

function player_health_limb_has_bleed(_limb, _bleed_type)
{
    if (!variable_struct_exists(_limb, "bleeds") || !is_array(_limb.bleeds))
        return _limb.bleed == _bleed_type;
    return player_health_limb_bleed_count(_limb, _bleed_type) > 0;
}

function player_health_limb_bleed_count(_limb, _bleed_type)
{
    if (!variable_struct_exists(_limb, "bleeds") || !is_array(_limb.bleeds))
        return _limb.bleed == _bleed_type ? 1 : 0;
    var _count = 0;
    for (var i = 0; i < array_length(_limb.bleeds); i++)
    {
        if (_limb.bleeds[i].type == _bleed_type) _count++;
    }
    return _count;
}

function player_health_sync_limb_bleed_state(_limb)
{
    _limb.bleed = LimbBleedState.NONE;
    if (!variable_struct_exists(_limb, "bleeds") || !is_array(_limb.bleeds)) return;
    for (var i = 0; i < array_length(_limb.bleeds); i++)
        _limb.bleed = max(_limb.bleed, _limb.bleeds[i].type);
}

function player_health_get_penalties()
{
    var _severity = array_create(6, 0);
    for (var i = 0; i < array_length(health_limbs); i++)
    {
        var _limb = health_limbs[i];
        var _value = 0;
        if (_limb.injury == LimbInjuryState.BLACKED_OUT) _value = health_config.blacked_penalty_strength;
        else if (_limb.injury == LimbInjuryState.WOUNDED)
            _value = (1 - (_limb.hp / max(1, _limb.max_hp))) * health_config.wounded_penalty_strength;
        if (_limb.fractured) _value = max(_value, health_config.fracture_penalty_strength);
        _severity[i] = _value;
    }

    if (health_painkiller_remaining > 0)
    {
        var _remaining_penalty = 1 - health_config.painkiller_penalty_suppression;
        for (var i = 0; i < array_length(_severity); i++) _severity[i] *= _remaining_penalty;
    }

    var _arm = (_severity[PlayerLimb.LEFT_ARM] + _severity[PlayerLimb.RIGHT_ARM]) * 0.5;
    var _leg = (_severity[PlayerLimb.LEFT_LEG] + _severity[PlayerLimb.RIGHT_LEG]) * 0.5;
    var _core = max(_severity[PlayerLimb.HEAD], _severity[PlayerLimb.CHEST]);
    return {
        movement: max(health_config.minimum_move_multiplier, 1 - (_leg * health_config.leg_move_penalty)),
        dash: max(health_config.minimum_dash_multiplier, 1 - (_leg * health_config.leg_dash_penalty)),
        reload: max(health_config.minimum_reload_multiplier, 1 - (_arm * health_config.arm_reload_penalty)),
        recoil: 1 + (_arm * health_config.arm_recoil_penalty),
        stamina: max(health_config.minimum_stamina_multiplier, 1 - (_core * health_config.core_stamina_penalty))
    };
}
