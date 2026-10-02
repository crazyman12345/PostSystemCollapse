function raid_enemy_pick_random_position(_enemy)
{
    _enemy.target_x = random_range(
        raid_room_x1 + 50,
        raid_room_x2 - 50
    );

    _enemy.target_y = random_range(
        raid_room_y1 + 50,
        raid_room_y2 - 50
    );

    return _enemy;
}