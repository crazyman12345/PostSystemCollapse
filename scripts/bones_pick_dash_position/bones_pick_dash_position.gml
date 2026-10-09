function bones_pick_dash_position(_enemy)
{
    var e = _enemy;
    var _found = false;
    var _bbox = raid_enemy_get_collision_bbox(e);
    var _left_padding = raid_room_x1 + (e.enemy_x - _bbox.left) + 30;
    var _top_padding = raid_room_y1 + (e.enemy_y - _bbox.top) + 30;

    for (var i = 0; i < 12; i++)
    {
        var _x = random_range(_left_padding, raid_room_x2 - (_bbox.right - e.enemy_x) - 30);
        var _y = random_range(_top_padding, raid_room_y2 - (_bbox.bottom - e.enemy_y) - 30);

        if (point_distance(_x, _y, raid_player_x, raid_player_y) >= 100)
        {
            e.target_x = _x;
            e.target_y = _y;
            _found = true;
            break;
        }
    }

    if (!_found)
    {
        e.target_x = raid_player_x < (raid_room_x1 + raid_room_x2) * 0.5
            ? raid_room_x2 - (_bbox.right - e.enemy_x) - 30
            : raid_room_x1 + (e.enemy_x - _bbox.left) + 30;
        e.target_y = raid_player_y < (raid_room_y1 + raid_room_y2) * 0.5
            ? raid_room_y2 - (_bbox.bottom - e.enemy_y) - 30
            : raid_room_y1 + (e.enemy_y - _bbox.top) + 30;
    }

    return e;
}
