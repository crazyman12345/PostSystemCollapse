function raid_player_take_damage(_damage)
{
    if (raid_godmode || raid_player_is_dash_invulnerable() || raid_player_invincible)
        return;

    var _hp_before = raid_player_hp;
    var _armor_before = raid_player_armor;
    var _remaining_damage = _damage;
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
        raid_player_hp -= _remaining_damage;
        raid_player_hp = max(0, raid_player_hp);
    }

    if (raid_player_hp < _hp_before || raid_player_armor < _armor_before)
        player_skill_add_xp("vitality", skill_xp_awards.vitality_damage);

    // DEATH
    if (raid_player_hp <= 0)
    {
        raid_combat_loss();
        return;
    }

    // INVINCIBILITY WINDOW
    raid_player_invincible = true;
    raid_player_invincible_timer =
        raid_player_invincible_time;
}
