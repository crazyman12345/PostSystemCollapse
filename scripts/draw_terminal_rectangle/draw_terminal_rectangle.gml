function draw_terminal_rectangle(_left, _top, _right, _bottom, _border_color = c_green, _fill_alpha = 0.9)
{
    var _old_alpha = draw_get_alpha();
    var _old_color = draw_get_color();
    var _corner_length = min(12, min((_right - _left) * 0.25, (_bottom - _top) * 0.25));

    draw_set_alpha(_old_alpha * 0.7);
    draw_set_color(c_black);
    draw_rectangle(_left + 3, _top + 3, _right + 3, _bottom + 3, false);

    draw_set_alpha(_old_alpha * _fill_alpha);
    draw_set_color(make_color_rgb(3, 10, 12));
    draw_rectangle(_left, _top, _right, _bottom, false);

    draw_set_alpha(_old_alpha * 0.04);
    draw_set_color(_border_color);
    for (var _scan_y = _top + 5; _scan_y < _bottom - 4; _scan_y += 6)
        draw_line(_left + 4, _scan_y, _right - 4, _scan_y);

    draw_set_alpha(_old_alpha * 0.3);
    draw_rectangle(_left + 3, _top + 3, _right - 3, _bottom - 3, true);

    draw_set_alpha(_old_alpha);
    draw_rectangle(_left, _top, _right, _bottom, true);

    draw_line(_left, _top, _left + _corner_length, _top);
    draw_line(_left, _top, _left, _top + _corner_length);
    draw_line(_right - _corner_length, _top, _right, _top);
    draw_line(_right, _top, _right, _top + _corner_length);
    draw_line(_left, _bottom - _corner_length, _left, _bottom);
    draw_line(_left, _bottom, _left + _corner_length, _bottom);
    draw_line(_right, _bottom - _corner_length, _right, _bottom);
    draw_line(_right - _corner_length, _bottom, _right, _bottom);

    draw_set_alpha(_old_alpha);
    draw_set_color(_old_color);
}
