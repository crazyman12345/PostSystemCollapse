function raid_ring_create(_x, _y, _max_radius, _expansion_speed, _thickness, _damage)
{
    return ring_attack_create(
        _x,
        _y,
        0,
        _max_radius,
        _expansion_speed,
        _thickness,
        _damage,
        make_color_rgb(255, 90, 90),
        make_color_rgb(120, 0, 0)
    );
}
