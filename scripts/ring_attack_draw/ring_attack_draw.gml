function ring_attack_draw(_attack)
{
    if (!_attack.active)
        return;


    // ==============================
    // LIGHT RED WARNING AREA
    // ==============================

    var _warning_alpha =
        0.20
        + (0.08 * (0.5 + 0.5 * sin(current_time * 0.01)));

    // Filled transparent warning area
    draw_set_color(_attack.warning_color);
    draw_set_alpha(_warning_alpha);

    draw_circle(
        _attack.x,
        _attack.y,
        _attack.max_radius,
        false
    );


    // Brighter warning outline
    draw_set_alpha(0.6);

    draw_circle(
        _attack.x,
        _attack.y,
        _attack.max_radius,
        true
    );


    // ==============================
    // WARNING MARKERS
    // ==============================

    draw_set_color(make_color_rgb(255, 120, 120));
    draw_set_alpha(0.8);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_explosion);

    for (var _marker = 0; _marker < 8; _marker++)
    {
        var _marker_direction = _marker * 45;
        var _marker_distance = _attack.max_radius - 20;

        draw_text(
            _attack.x
                + lengthdir_x(_marker_distance, _marker_direction),

            _attack.y
                + lengthdir_y(_marker_distance, _marker_direction),

            "!"
        );
    }


    // ==============================
    // ACTIVE DAMAGE RING
    // ==============================

    if (_attack.state == "ACTIVE")
    {
        draw_set_color(_attack.ring_color);
        draw_set_alpha(1);

        var _half =
            _attack.thickness * 0.5;

        for (
            var _offset = -_half;
            _offset <= _half;
            _offset += 0.25
        )
        {
            draw_circle(
                _attack.x,
                _attack.y,
                max(
                    0,
                    _attack.current_radius + _offset
                ),
                true
            );
        }
    }


    // ==============================
    // RESET DRAW STATE
    // ==============================

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}