function player_health_get_max_hp()
{
    var _level = skill_get_level("vitality");
    var _bonus_chunks = min(
        health_config.vitality_bonus_chunks_max,
        floor(_level / health_config.vitality_levels_per_chunk)
    );
    return health_config.global_base_max + (_bonus_chunks * health_config.hp_chunk);
}

function player_health_get_limb_max_hp(_limb)
{
    var _global_max = player_health_get_max_hp();
    return max(1, round(health_config.limb_base_hp[_limb] * _global_max / health_config.global_base_max));
}

function player_health_refresh_maximums(_preserve_missing = true)
{
    var _old_global_max = max(1, raid_player_max_hp);
    var _global_missing = _old_global_max - raid_player_hp;
    raid_player_max_hp = player_health_get_max_hp();
    raid_player_hp = _preserve_missing
        ? clamp(round(raid_player_max_hp - _global_missing), 0, raid_player_max_hp)
        : raid_player_max_hp;
    health_global_recovery_accumulator = 0;

    for (var i = 0; i < array_length(health_limbs); i++)
    {
        var _limb = health_limbs[i];
        var _missing = _limb.max_hp - _limb.hp;
        _limb.max_hp = player_health_get_limb_max_hp(i);
        _limb.hp = _preserve_missing ? clamp(round(_limb.max_hp - _missing), 0, _limb.max_hp) : _limb.max_hp;
        health_limb_recovery_accumulators[i] = 0;
        player_health_update_limb_state(_limb);
    }

    player_health_sync_crew();
}

function player_health_sync_crew()
{
    if (!variable_instance_exists(id, "crew") || array_length(crew) <= 0) return;
    var _member = crew[0];
    _member.hp = raid_player_hp;
    _member.max_hp = raid_player_max_hp;
    crew[0] = _member;
}

function player_health_update_limb_state(_limb)
{
    if (_limb.hp <= 0) _limb.injury = LimbInjuryState.BLACKED_OUT;
    else if (_limb.hp < _limb.max_hp) _limb.injury = LimbInjuryState.WOUNDED;
    else _limb.injury = LimbInjuryState.HEALTHY;
}
