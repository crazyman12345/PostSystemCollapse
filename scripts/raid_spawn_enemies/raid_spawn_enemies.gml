function raid_spawn_enemies()
{
    var _count = raid_get_enemy_count();
    var _player_spawn_area = 200;

    for (var i = 0; i < _count; i++)
    {
        var _type = raid_get_random_enemy_type();

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
