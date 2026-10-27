function raid_spawn_enemies()
{
	if (raid.rooms_cleared >= raid.room_count)
	{
	    raid.current_room_type = RaidRoomType.BOSS;
	    var _boss_type = raid.selected_area_index == 1
	        ? RaidEnemyType.ROB_GNARLEY
	        : RaidEnemyType.BONES;
	    raid_spawn_enemy(
	        _boss_type,
	        (raid_room_x1 + raid_room_x2) * 0.5,
	        (raid_room_y1 + raid_room_y2) * 0.5
	    );
	    return;
	}

    var _count = raid_get_enemy_count();
    var _player_spawn_area = 200;

    for (var i = 0; i < _count; i++)
    {
        var _type = raid_get_random_enemy_type();

        if (is_undefined(_type))
            continue;

        var _x = random_range(
            raid_room_x1 + 60,
            raid_room_x2 - 60
        );

        var _y = random_range(
            raid_room_y1 + 60,
            raid_room_y2 - _player_spawn_area
        );

        raid_spawn_enemy(
            _type,
            _x,
            _y
        );
    }
}
