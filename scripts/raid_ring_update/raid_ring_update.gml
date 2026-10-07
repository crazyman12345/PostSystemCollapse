function raid_ring_update(_ring)
{
    if (!_ring.active)
        return _ring;

    _ring.current_radius += _ring.expansion_speed;

    var _dist = point_distance(
        _ring.x,
        _ring.y,
        raid_player_x,
        raid_player_y
    );

    if (
        !_ring.damaged_player
        && abs(_dist - _ring.current_radius) <= _ring.thickness
    )
    {
        raid_player_take_damage(_ring.damage);
        _ring.damaged_player = true;
    }

    if (_ring.current_radius >= _ring.max_radius)
        _ring.active = false;

    return _ring;
}
