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
    if (health_limbs[PlayerLimb.HEAD].injury == LimbInjuryState.BLACKED_OUT)
        raid_head_blur_phase = frac(raid_head_blur_phase + (_seconds / health_config.blacked_head_blur_cycle_seconds));
    else raid_head_blur_phase = 0;
    health_painkiller_remaining = max(0, health_painkiller_remaining - _seconds);
}

function player_survival_update()
{
    if (overlay_mode != OverlayMode.NONE) return;
    if (raid.state != RaidState.COMBAT
    && raid.state != RaidState.ENTERING
    && raid.state != RaidState.EXITING) return;

    var _seconds = frame_scale / 60;
    var _energy_before = player_energy;
    var _hydration_before = player_hydration;
    var _survival_drain_multiplier = raid_get_encumbrance_penalties().survival_drain;
    player_energy = clamp(player_energy - ((health_config.energy_drain_per_minute / 60) * _survival_drain_multiplier * _seconds), 0, health_config.survival_max);
    player_hydration = clamp(player_hydration - ((health_config.hydration_drain_per_minute / 60) * _survival_drain_multiplier * _seconds), 0, health_config.survival_max);

    if (player_energy > 0)
        energy_zero_damage_remaining = health_config.energy_zero_damage_interval_seconds;
    else
    {
        energy_zero_damage_remaining -= _seconds;
        while (energy_zero_damage_remaining <= 0 && raid_player_hp > 0)
        {
            player_health_apply_global_damage(health_config.energy_zero_damage);
            energy_zero_damage_remaining += health_config.energy_zero_damage_interval_seconds;
        }
    }

    if (player_hydration > 0)
        hydration_zero_damage_remaining = health_config.hydration_zero_damage_interval_seconds;
    else
    {
        hydration_zero_damage_remaining -= _seconds;
        while (hydration_zero_damage_remaining <= 0 && raid_player_hp > 0)
        {
            player_health_apply_global_damage(health_config.hydration_zero_damage);
            hydration_zero_damage_remaining += health_config.hydration_zero_damage_interval_seconds;
        }
    }

    if (player_energy != _energy_before || player_hydration != _hydration_before)
    {
        if (!save_dirty) save_mark_dirty();
    }
}

function player_health_update_post_raid_recovery()
{
    var _seconds = frame_scale / 60;
    var _duration = max(1, health_config.post_raid_recovery_seconds);
    var _survival_duration = max(1, health_config.survival_hideout_recovery_seconds);
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

    if (player_energy < health_config.survival_max)
    {
        player_energy = min(health_config.survival_max, player_energy + ((health_config.survival_max / _survival_duration) * _seconds));
        if (player_energy > 0) energy_zero_damage_remaining = health_config.energy_zero_damage_interval_seconds;
        _changed = true;
    }

    if (player_hydration < health_config.survival_max)
    {
        player_hydration = min(health_config.survival_max, player_hydration + ((health_config.survival_max / _survival_duration) * _seconds));
        if (player_hydration > 0) hydration_zero_damage_remaining = health_config.hydration_zero_damage_interval_seconds;
        _changed = true;
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
    var _fractured_leg_count = 0;
    var _blacked_leg_count = 0;
    for (var i = 0; i < array_length(health_limbs); i++)
    {
        var _limb = health_limbs[i];
        var _value = 0;
        if (_limb.injury == LimbInjuryState.BLACKED_OUT) _value = health_config.blacked_penalty_strength;
        else if (_limb.injury == LimbInjuryState.WOUNDED)
            _value = (1 - (_limb.hp / max(1, _limb.max_hp))) * health_config.wounded_penalty_strength;
        if (_limb.fractured) _value = max(_value, health_config.fracture_penalty_strength);
        if ((i == PlayerLimb.LEFT_LEG || i == PlayerLimb.RIGHT_LEG) && _limb.fractured) _fractured_leg_count++;
        if ((i == PlayerLimb.LEFT_LEG || i == PlayerLimb.RIGHT_LEG)
        && _limb.injury == LimbInjuryState.BLACKED_OUT) _blacked_leg_count++;
        _severity[i] = _value;
    }

    if (health_painkiller_remaining > 0)
    {
        var _remaining_penalty = 1 - health_config.painkiller_penalty_suppression;
        for (var i = 0; i < array_length(_severity); i++) _severity[i] *= _remaining_penalty;
        _fractured_leg_count *= _remaining_penalty;
        _blacked_leg_count *= _remaining_penalty;
    }

    var _arm = (_severity[PlayerLimb.LEFT_ARM] + _severity[PlayerLimb.RIGHT_ARM]) * 0.5;
    var _leg = (_severity[PlayerLimb.LEFT_LEG] + _severity[PlayerLimb.RIGHT_LEG]) * 0.5;
    var _movement_leg = (
        (health_limbs[PlayerLimb.LEFT_LEG].injury == LimbInjuryState.BLACKED_OUT || health_limbs[PlayerLimb.LEFT_LEG].fractured ? 0 : _severity[PlayerLimb.LEFT_LEG])
        + (health_limbs[PlayerLimb.RIGHT_LEG].injury == LimbInjuryState.BLACKED_OUT || health_limbs[PlayerLimb.RIGHT_LEG].fractured ? 0 : _severity[PlayerLimb.RIGHT_LEG])
    ) * 0.5;
    var _core = max(_severity[PlayerLimb.HEAD], _severity[PlayerLimb.CHEST]);
    return {
        movement: max(0.1, max(health_config.minimum_move_multiplier, 1 - (_movement_leg * health_config.leg_move_penalty))
            - (_fractured_leg_count * health_config.fractured_leg_move_penalty)
            - (_blacked_leg_count * health_config.blacked_leg_move_penalty)),
        dash: max(health_config.minimum_dash_multiplier, 1 - (_leg * health_config.leg_dash_penalty)),
        reload: max(health_config.minimum_reload_multiplier, 1 - (_arm * health_config.arm_reload_penalty)),
        recoil: 1 + (_arm * health_config.arm_recoil_penalty),
        stamina: max(health_config.minimum_stamina_multiplier, 1 - (_core * health_config.core_stamina_penalty))
    };
}
