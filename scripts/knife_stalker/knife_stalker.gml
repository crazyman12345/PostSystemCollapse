function knife_stalker(_enemy)
{
    var e = _enemy;

    var _dir = point_direction(
        e.enemy_x,
        e.enemy_y,
        raid_player_x,
        raid_player_y
    );

    e.enemy_x += lengthdir_x(
        e.enemy_speed,
        _dir
    );

    e.enemy_y += lengthdir_y(
        e.enemy_speed,
        _dir
    );

    return e;
}