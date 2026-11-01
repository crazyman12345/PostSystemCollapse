function draw_ascii_impossible_triangle(_x, _y, _columns = 82, _rows = 74)
{
    var _old_font = draw_get_font();
    var _old_color = draw_get_color();
    var _old_alpha = draw_get_alpha();
    var _old_halign = draw_get_halign();
    var _old_valign = draw_get_valign();
    var _character_width = 8;
    var _line_height = 9;
    var _phase = (current_time mod 10000) / 10000;
    var _angle = _phase * pi * 2;
    var _rotation_cos = cos(_angle);
    var _rotation_sin = sin(_angle);
    var _perspective_x = 0.88 + (sin(_angle) * 0.10);
    var _perspective_y = 0.92 + (cos(_angle * 2) * 0.06);
    var _shear = sin(_angle * 2) * 0.10;
    var _density_ramp = " .:-=+*#%@";
    var _ramp_length = string_length(_density_ramp);
    var _beam_width = 0.145;
    var _palette = [
        make_color_rgb(0, 244, 255),
        make_color_rgb(255, 0, 145),
        make_color_rgb(255, 198, 0)
    ];
    var _start_x = [0, -0.74, 0.74];
    var _start_y = [-0.76, 0.56, 0.56];
    var _end_x = [-0.74, 0.74, 0];
    var _end_y = [0.56, 0.56, -0.76];

    draw_set_font(fnt_ascii);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    for (var _row = 0; _row < _rows; _row++)
    {
        var _lines = ["", "", ""];
        var _screen_y = (_row - ((_rows - 1) * 0.5)) / (_rows * 0.5);

        for (var _column = 0; _column < _columns; _column++)
        {
            var _screen_x = (_column - ((_columns - 1) * 0.5)) / (_columns * 0.5);
            var _rotated_x = (_screen_x * _rotation_cos) + (_screen_y * _rotation_sin);
            var _rotated_y = (-_screen_x * _rotation_sin) + (_screen_y * _rotation_cos);
            var _local_y = _rotated_y / _perspective_y;
            var _local_x = (_rotated_x - (_local_y * _shear)) / _perspective_x;
            var _nearest_edge = -1;
            var _nearest_distance = 100;
            var _nearest_t = 0;
            var _nearest_side = 0;

            for (var _edge = 0; _edge < 3; _edge++)
            {
                var _edge_x = _end_x[_edge] - _start_x[_edge];
                var _edge_y = _end_y[_edge] - _start_y[_edge];
                var _edge_length_squared = sqr(_edge_x) + sqr(_edge_y);
                var _edge_t = clamp(
                    (((_local_x - _start_x[_edge]) * _edge_x) + ((_local_y - _start_y[_edge]) * _edge_y)) / _edge_length_squared,
                    0,
                    1
                );
                var _closest_x = _start_x[_edge] + (_edge_x * _edge_t);
                var _closest_y = _start_y[_edge] + (_edge_y * _edge_t);
                var _offset_x = _local_x - _closest_x;
                var _offset_y = _local_y - _closest_y;
                var _distance = sqrt(sqr(_offset_x) + sqr(_offset_y));

                if (_distance < _nearest_distance)
                {
                    _nearest_edge = _edge;
                    _nearest_distance = _distance;
                    _nearest_t = _edge_t;
                    _nearest_side = ((_edge_x * _offset_y) - (_edge_y * _offset_x)) / sqrt(_edge_length_squared);
                }
            }

            var _inside_beam = _nearest_distance <= _beam_width;
            var _joint_cut = _nearest_t < 0.115 && _nearest_side < 0.035;
            if (!_inside_beam || _joint_cut)
            {
                _lines[0] += " ";
                _lines[1] += " ";
                _lines[2] += " ";
                continue;
            }

            var _edge_depth = 1 - clamp((_nearest_side + _beam_width) / (_beam_width * 2), 0, 1);
            var _moving_light = 0.5 + (0.5 * sin((_nearest_t * pi * 2) - (_angle * 3) + (_nearest_edge * 2.1)));
            var _brightness = 0.26 + (_edge_depth * 0.48) + (_moving_light * 0.25);
            if (_nearest_t < 0.18) _brightness *= 0.52 + (_nearest_t * 2.5);

            var _noise = (((_row * 97 + _column * 43) mod 251) / 251) - 0.5;
            var _ramp_index = 1 + floor(clamp(_brightness + (_noise * 0.08), 0, 0.999) * _ramp_length);
            var _character = string_char_at(_density_ramp, _ramp_index);
            var _color_band = (_nearest_edge + floor(_nearest_t * 3)) mod 3;

            for (var _line_index = 0; _line_index < 3; _line_index++)
                _lines[_line_index] += _line_index == _color_band ? _character : " ";
        }

        for (var _color_index = 0; _color_index < 3; _color_index++)
        {
            draw_set_color(_palette[_color_index]);
            draw_set_alpha(0.16);
            draw_text(_x + 2, _y + (_row * _line_height), _lines[_color_index]);
            draw_set_alpha(1);
            draw_text(_x, _y + (_row * _line_height), _lines[_color_index]);
        }
    }

    draw_set_font(_old_font);
    draw_set_color(_old_color);
    draw_set_alpha(_old_alpha);
    draw_set_halign(_old_halign);
    draw_set_valign(_old_valign);
}
