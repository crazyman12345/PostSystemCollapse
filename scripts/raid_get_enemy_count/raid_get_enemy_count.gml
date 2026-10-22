function raid_get_enemy_count()
{
    var _room = raid.rooms_cleared + 1;

    if (variable_struct_exists(raid, "selected_area")
        && variable_struct_exists(raid.selected_area, "beginning_enemy_count")
        && variable_struct_exists(raid.selected_area, "ending_enemy_count"))
    {
        return raid_get_scaled_enemy_count(
            raid.selected_area.beginning_enemy_count,
            raid.selected_area.ending_enemy_count,
            _room
        );
    }

    if (_room <= 5)
        return 3;

    if (_room <= 10)
        return irandom_range(3, 4);

    if (_room <= 15)
        return 4;

    return irandom_range(4, 5);
}

function raid_get_scaled_enemy_count(_beginning_count, _ending_count, _room)
{
    if (abs(_ending_count - _beginning_count) == 1)
    {
        if (_room <= 5) return _beginning_count;
        if (_room <= 10) return irandom_range(
            min(_beginning_count, _ending_count),
            max(_beginning_count, _ending_count)
        );

        return _ending_count;
    }

    var _first_room = 1;
    var _final_normal_room = raid.room_count;
    var _progress = clamp(
        (_room - _first_room) / (_final_normal_room - _first_room),
        0,
        1
    );

    return round(lerp(_beginning_count, _ending_count, _progress));
}
