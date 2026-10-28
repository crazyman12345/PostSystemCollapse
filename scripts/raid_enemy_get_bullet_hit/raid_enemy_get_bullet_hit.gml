function raid_enemy_get_bullet_hit(_enemy, _bullet)
{
    var _bbox = raid_enemy_get_collision_bbox(_enemy);
    var _collision_left = _bbox.left - 4;
    var _collision_right = _bbox.right + 4;
    var _collision_top = _bbox.top - 4;
    var _collision_bottom = _bbox.bottom + 4;
    var _start_x = variable_struct_exists(_bullet, "bprevious_x") ? _bullet.bprevious_x : _bullet.bx;
    var _start_y = variable_struct_exists(_bullet, "bprevious_y") ? _bullet.bprevious_y : _bullet.by;
    var _move_x = _bullet.bx - _start_x;
    var _move_y = _bullet.by - _start_y;
    var _entry_time = 0;
    var _exit_time = 1;

    if (abs(_move_x) < 0.0001)
    {
        if (_start_x < _collision_left || _start_x > _collision_right)
            return { hit: false };
    }
    else
    {
        var _x_time_1 = (_collision_left - _start_x) / _move_x;
        var _x_time_2 = (_collision_right - _start_x) / _move_x;
        var _x_entry = min(_x_time_1, _x_time_2);
        var _x_exit = max(_x_time_1, _x_time_2);
        _entry_time = max(_entry_time, _x_entry);
        _exit_time = min(_exit_time, _x_exit);
    }

    if (abs(_move_y) < 0.0001)
    {
        if (_start_y < _collision_top || _start_y > _collision_bottom)
            return { hit: false };
    }
    else
    {
        var _y_time_1 = (_collision_top - _start_y) / _move_y;
        var _y_time_2 = (_collision_bottom - _start_y) / _move_y;
        var _y_entry = min(_y_time_1, _y_time_2);
        var _y_exit = max(_y_time_1, _y_time_2);
        _entry_time = max(_entry_time, _y_entry);
        _exit_time = min(_exit_time, _y_exit);
    }

    if (_entry_time > _exit_time || _exit_time < 0 || _entry_time > 1)
        return { hit: false };

    _entry_time = clamp(_entry_time, 0, 1);
    var _entry_x = clamp(_start_x + _move_x * _entry_time, _bbox.left, _bbox.right);
    var _entry_y = clamp(_start_y + _move_y * _entry_time, _bbox.top, _bbox.bottom);
    var _direction_x = lengthdir_x(1, _bullet.bdirection);
    var _direction_y = lengthdir_y(1, _bullet.bdirection);
    var _exit_distance = 1000000;

    if (_direction_x > 0.0001)
        _exit_distance = min(_exit_distance, max(0, (_bbox.right - _entry_x) / _direction_x));
    else if (_direction_x < -0.0001)
        _exit_distance = min(_exit_distance, max(0, (_bbox.left - _entry_x) / _direction_x));

    if (_direction_y > 0.0001)
        _exit_distance = min(_exit_distance, max(0, (_bbox.bottom - _entry_y) / _direction_y));
    else if (_direction_y < -0.0001)
        _exit_distance = min(_exit_distance, max(0, (_bbox.top - _entry_y) / _direction_y));

    return {
        hit: true,
        entry_x: _entry_x,
        entry_y: _entry_y,
        exit_x: _entry_x + _direction_x * _exit_distance,
        exit_y: _entry_y + _direction_y * _exit_distance
    };
}
