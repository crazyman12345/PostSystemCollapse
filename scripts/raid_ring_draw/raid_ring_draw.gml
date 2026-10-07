function raid_ring_draw(_ring)
{
    if (!_ring.active)
        return;

    draw_set_color(make_color_rgb(120, 0, 0));

    var _half = _ring.thickness * 0.5;

    for (var _offset = -_half; _offset <= _half; _offset += 0.25)
    {
        draw_circle(
            _ring.x,
            _ring.y,
            max(0, _ring.current_radius + _offset),
            true
        );
    }
}