function debug_start_combat(_args)
{
	var _enemy_key = string(_args[1]);
    raid_start("prototype_block");

    state = GameState.RAID;

    raid_bag_add(
        "bandage",
        5
    );

    raid_bag_add(
        "9mm_ammo",
        50
    );
	
	raid_bag_add(
        "9mm_pistol",
        1
    );

    raid_set_enemy(
        _enemy_key
    );

    log_add(
        "[DEBUG] Combat test started."
    );
}