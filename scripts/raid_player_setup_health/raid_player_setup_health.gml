function raid_player_setup_health()
{
    raid_player_max_hp = 30;
    var _thick_skin = skill_node_find(skill_node_get_nodes("vitality"), "thick_skin");
    if (!is_undefined(_thick_skin) && skill_node_is_unlocked("vitality", _thick_skin)) raid_player_max_hp += 10;
    raid_player_hp = raid_player_max_hp;

    raid_player_armor = 0;
    raid_player_max_armor = 0;

    raid_player_invincible = false;
    raid_player_invincible_timer = 0;

    raid_player_stamina = raid_player_max_stamina;

    var member = crew[0];

    if (member.armor_chest != "")
    {
        var _armor =
            item_get(
                member.armor_chest
            );

        if (
            is_struct(_armor)
            && variable_struct_exists(
                _armor,
                "armor"
            )
        )
        {
            raid_player_armor =
                _armor.armor;

            raid_player_max_armor =
                _armor.armor;
        }
    }
}
