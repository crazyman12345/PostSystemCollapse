function player_health_damage_limb(_limb_index, _damage, _allow_conditions = true)
{
    if (_limb_index < 0 || _limb_index >= array_length(health_limbs)) return;

    var _limb = health_limbs[_limb_index];
    _limb.hp = max(0, _limb.hp - max(0, _damage));
    player_health_update_limb_state(_limb);

    if (_allow_conditions && _limb.hp > 0)
    {
        if (player_health_limb_can_fracture(_limb_index)
        && !_limb.fractured
        && _limb.hp / _limb.max_hp <= health_config.fracture_hp_ratio
        && random(1) < health_config.fracture_chance)
            _limb.fractured = true;

        if (random(1) < health_config.heavy_bleed_chance)
            player_health_add_bleed(_limb_index, LimbBleedState.HEAVY);
        else if (random(1) < health_config.light_bleed_chance)
            player_health_add_bleed(_limb_index, LimbBleedState.LIGHT);
    }

    health_limbs[_limb_index] = _limb;
    save_mark_dirty();
}

function player_health_add_bleed(_limb_index, _bleed_type)
{
    if (_limb_index < 0 || _limb_index >= array_length(health_limbs)
    || (_bleed_type != LimbBleedState.LIGHT && _bleed_type != LimbBleedState.HEAVY)) return false;

    var _limb = health_limbs[_limb_index];
    if (!variable_struct_exists(_limb, "bleeds") || !is_array(_limb.bleeds)) _limb.bleeds = [];
    var _interval = _bleed_type == LimbBleedState.LIGHT
        ? health_config.light_bleed_interval_seconds
        : health_config.heavy_bleed_interval_seconds;
    array_push(_limb.bleeds, {
        type: _bleed_type,
        tick_remaining: _interval,
        recovery_remaining: _bleed_type == LimbBleedState.LIGHT
            ? health_config.light_bleed_recovery_seconds
            : -1
    });
    player_health_sync_limb_bleed_state(_limb);
    health_limbs[_limb_index] = _limb;
    save_mark_dirty();
    return true;
}

function player_health_limb_can_fracture(_limb_index)
{
    return _limb_index == PlayerLimb.LEFT_ARM
        || _limb_index == PlayerLimb.RIGHT_ARM
        || _limb_index == PlayerLimb.LEFT_LEG
        || _limb_index == PlayerLimb.RIGHT_LEG;
}

function player_health_get_impact_limb(_impact_x, _impact_y, _record_debug = false)
{
    if (is_undefined(_impact_x) || is_undefined(_impact_y)) return PlayerLimb.CHEST;

    var _bbox = raid_player_get_collision_bbox();
    var _height = max(1, _bbox.bottom - _bbox.top);
    var _ny = clamp((_impact_y - _bbox.top) / _height, 0, 1);
    var _hit_limb;
    var _region_name;

    if (_ny <= health_config.hit_region_head_end)
    {
        _region_name = "HEAD";
        _hit_limb = PlayerLimb.HEAD;
    }
    else if (_ny <= health_config.hit_region_torso_end)
    {
        _region_name = "TORSO";
        var _chest_weight = health_config.hit_region_torso_chest_weight;
        var _left_arm_weight = health_config.hit_region_torso_left_arm_weight;
        var _roll = random(_chest_weight + _left_arm_weight + health_config.hit_region_torso_right_arm_weight);

        if (_roll < _chest_weight) _hit_limb = PlayerLimb.CHEST;
        else if (_roll < _chest_weight + _left_arm_weight) _hit_limb = PlayerLimb.LEFT_ARM;
        else _hit_limb = PlayerLimb.RIGHT_ARM;
    }
    else
    {
        _region_name = "LEGS";
        var _left_leg_weight = health_config.hit_region_legs_left_leg_weight;
        var _roll = random(_left_leg_weight + health_config.hit_region_legs_right_leg_weight);
        _hit_limb = _roll < _left_leg_weight ? PlayerLimb.LEFT_LEG : PlayerLimb.RIGHT_LEG;
    }

    if (_record_debug && raid_hit_region_debug_enabled)
    {
        raid_hit_region_debug_region = _region_name;
        raid_hit_region_debug_limb = health_limbs[_hit_limb].name;
    }

    return _hit_limb;
}

function player_health_apply_global_damage(_damage)
{
    var _chunks = max(0, round(_damage / health_config.hp_chunk));
    if (_chunks <= 0) return 0;
    var _applied = min(raid_player_hp, _chunks * health_config.hp_chunk);
    raid_player_hp = max(0, raid_player_hp - _applied);
    if (_applied > 0) player_health_treatment_cancel();
    player_health_sync_crew();
    save_mark_dirty();
    if (raid_player_hp <= 0 && raid.state != RaidState.DEATH) raid_player_death_start();
    return _applied;
}
