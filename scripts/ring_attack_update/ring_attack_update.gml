function ring_attack_update(_attack)
{
    if (!_attack.active)
        return _attack;

    if (_attack.state == "WINDUP")
    {
        _attack.windup_timer--;
        if (_attack.windup_timer <= 0)
        {
            _attack.state = "ACTIVE";
            _attack.current_radius = 0;
        }
        return _attack;
    }

    _attack.current_radius += _attack.expansion_speed;

    var _dist = point_distance(
        _attack.x,
        _attack.y,
        raid_player_x,
        raid_player_y
    );

    if (
        !_attack.damaged_player
        && abs(_dist - _attack.current_radius) <= _attack.thickness
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
