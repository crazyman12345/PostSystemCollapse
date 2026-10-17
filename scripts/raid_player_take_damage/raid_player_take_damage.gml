function raid_player_take_damage(_damage, _hit_direction = undefined, _impact_x = undefined, _impact_y = undefined, _projectile_hit = false, _random_limb = false)
{
    if (raid.state == RaidState.DEATH || raid_godmode || raid_player_is_dash_invulnerable() || raid_player_invincible)
        return;

    var _hp_before = raid_player_hp;
    var _armor_before = raid_player_armor;
    var _remaining_damage = max(health_config.hp_chunk, round(_damage / health_config.hp_chunk) * health_config.hp_chunk);
	var _hit_limb = _random_limb
		? irandom(array_length(health_limbs) - 1)
		: player_health_get_impact_limb(_impact_x, _impact_y, _projectile_hit);
	play_impact_sound(hit3, "bullet");
    // ARMOR FIRST
    if (raid_player_armor > 0)
    {
        var _armor_damage = min(
            raid_player_armor,
            _remaining_damage
        );

        raid_player_armor -= _armor_damage;
        _remaining_damage -= _armor_damage;
    }

    // HEALTH
    if (_remaining_damage > 0)
    {
        _remaining_damage = ceil(_remaining_damage / health_config.hp_chunk) * health_config.hp_chunk;
        player_health_damage_limb(_hit_limb, _remaining_damage, true);
        player_health_apply_global_damage(_remaining_damage);
    }

    if (raid_player_hp < _hp_before || raid_player_armor < _armor_before)
    {
        player_health_treatment_cancel();
        player_skill_add_xp("vitality", skill_xp_awards.vitality_damage);
    }

    if (raid_player_hp < _hp_before)
    {
        var _blood_direction = is_undefined(_hit_direction) ? random(360) : _hit_direction;
        blood_hit_effect(raid_player_x, raid_player_y, _blood_direction);
    }

    // DEATH
    if (raid_player_hp <= 0)
    {
        return;
    }

    // INVINCIBILITY WINDOW
    raid_player_invincible = true;
    raid_player_invincible_timer =
        raid_player_invincible_time;
}
