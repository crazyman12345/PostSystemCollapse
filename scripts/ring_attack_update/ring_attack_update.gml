function ring_attack_update(_attack)
{
    if (!_attack.active)
        return _attack;

    if (_attack.state == "WINDUP")
    {
        _attack.windup_timer -= frame_scale;
        if (_attack.windup_timer <= 0)
        {
            _attack.state = "ACTIVE";
            _attack.current_radius = 0;
        }
        return _attack;
    }

    _attack.current_radius += _attack.expansion_speed * frame_scale;

    var _player_bbox = raid_player_get_collision_bbox();
    var _nearest_x = clamp(_attack.x, _player_bbox.left, _player_bbox.right);
    var _nearest_y = clamp(_attack.y, _player_bbox.top, _player_bbox.bottom);
    var _farthest_x = abs(_attack.x - _player_bbox.left) > abs(_attack.x - _player_bbox.right)
        ? _player_bbox.left
        : _player_bbox.right;
    var _farthest_y = abs(_attack.y - _player_bbox.top) > abs(_attack.y - _player_bbox.bottom)
        ? _player_bbox.top
        : _player_bbox.bottom;
    var _min_dist = point_distance(_attack.x, _attack.y, _nearest_x, _nearest_y);
    var _max_dist = point_distance(_attack.x, _attack.y, _farthest_x, _farthest_y);
    var _inner_radius = max(0, _attack.current_radius - _attack.thickness);
    var _outer_radius = _attack.current_radius + _attack.thickness;

    if (
        !_attack.damaged_player
        && _min_dist <= _outer_radius
        && _max_dist >= _inner_radius
        && !raid_player_is_dash_invulnerable()
    )
    {
        raid_player_take_damage(_attack.damage);
        _attack.damaged_player = true;
    }

    if (_attack.current_radius >= _attack.max_radius)
        _attack.active = false;

    return _attack;
}
