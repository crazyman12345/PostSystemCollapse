function draw_ascii_sidebar_shape(_x, _y, _tab_key)
{
    var _old_font = draw_get_font();
    var _old_color = draw_get_color();
    var _old_alpha = draw_get_alpha();
    var _old_halign = draw_get_halign();
    var _old_valign = draw_get_valign();
    var _columns = 32;
    var _rows = 32;
    var _character_width = 8;
    var _line_height = 9;
    var _phase = (current_time mod 12000) / 12000;
    var _angle = _phase * pi * 2;
    var _rotation_cos = cos(_angle);
    var _rotation_sin = sin(_angle);
    var _wobble = sin(_angle * 2) * 0.08;
    var _density_ramp = ".:-=+*#%@";
    var _ramp_length = string_length(_density_ramp);
    var _beam_width = 0.085;
    var _segments;

    switch (_tab_key)
    {
        case "traders":
            _segments = [
                [-0.78, -0.20, -0.20, -0.78], [-0.20, -0.78, 0.78, 0.20], [0.78, 0.20, 0.20, 0.78],
                [0.20, 0.78, -0.78, -0.20], [-0.78, 0.20, -0.20, 0.78], [-0.20, 0.78, 0.78, -0.20],
                [0.78, -0.20, 0.20, -0.78], [0.20, -0.78, -0.78, 0.20]
            ];
        break;

        case "messages":
            _segments = [
                [0, -0.82, 0.78, 0], [0.78, 0, 0, 0.82], [0, 0.82, -0.78, 0], [-0.78, 0, 0, -0.82],
                [-0.38, -0.38, 0.46, -0.38], [0.46, -0.38, 0.46, 0.46], [0.46, 0.46, -0.38, 0.46],
                [-0.38, 0.46, -0.38, -0.38], [0, -0.82, -0.38, -0.38], [0.78, 0, 0.46, 0.46]
            ];
        break;

        case "stash":
            _segments = [
                [0, -0.82, -0.68, -0.38], [-0.68, -0.38, -0.68, 0.40], [-0.68, 0.40, 0, 0.82],
                [0, 0.82, 0.68, 0.40], [0.68, 0.40, 0.68, -0.38], [0.68, -0.38, 0, -0.82],
                [0, -0.82, 0, 0], [-0.68, 0.40, 0, 0], [0.68, 0.40, 0, 0]
            ];
        break;

        case "skills":
            _segments = [
                [0, -0.82, 0.78, -0.25], [0.78, -0.25, 0.48, 0.72], [0.48, 0.72, -0.48, 0.72],
                [-0.48, 0.72, -0.78, -0.25], [-0.78, -0.25, 0, -0.82],
                [0, -0.50, 0.46, -0.14], [0.46, -0.14, 0.29, 0.43], [0.29, 0.43, -0.29, 0.43],
                [-0.29, 0.43, -0.46, -0.14], [-0.46, -0.14, 0, -0.50],
                [0, -0.82, 0, -0.50], [0.48, 0.72, 0.29, 0.43]
            ];
        break;

        case "salvaging":
            _segments = [
                [-0.30, -0.78, 0.30, -0.78], [0.30, -0.78, 0.78, -0.30], [0.78, -0.30, 0.78, 0.30],
                [0.78, 0.30, 0.30, 0.78], [0.30, 0.78, -0.30, 0.78], [-0.30, 0.78, -0.78, 0.30],
                [-0.78, 0.30, -0.78, -0.30], [-0.78, -0.30, -0.30, -0.78],
                [-0.30, -0.78, 0.30, 0.78], [0.78, -0.30, -0.78, 0.30]
            ];
        break;

        case "gunmaking":
            _segments = [
                [-0.78, -0.62, 0.12, -0.62], [0.12, -0.62, 0.62, -0.12], [0.62, -0.12, -0.18, 0.68],
                [-0.18, 0.68, -0.68, 0.18], [-0.68, 0.18, 0.18, -0.68],
                [-0.42, -0.30, 0.18, -0.30], [0.18, -0.30, 0.36, -0.12], [0.36, -0.12, -0.18, 0.42]
            ];
        break;

        case "armorcrafting":
            _segments = [
                [0, -0.84, 0.70, -0.48], [0.70, -0.48, 0.56, 0.42], [0.56, 0.42, 0, 0.82],
                [0, 0.82, -0.56, 0.42], [-0.56, 0.42, -0.70, -0.48], [-0.70, -0.48, 0, -0.84],
                [0, -0.52, 0.38, -0.30], [0.38, -0.30, 0.30, 0.24], [0.30, 0.24, 0, 0.50],
                [0, 0.50, -0.30, 0.24], [-0.30, 0.24, -0.38, -0.30], [-0.38, -0.30, 0, -0.52]
            ];
        break;

        case "medical_crafting":
            _segments = [
                [-0.24, -0.82, 0.24, -0.82], [0.24, -0.82, 0.24, -0.24], [0.24, -0.24, 0.82, -0.24],
                [0.82, -0.24, 0.82, 0.24], [0.82, 0.24, 0.24, 0.24], [0.24, 0.24, 0.24, 0.82],
                [0.24, 0.82, -0.24, 0.82], [-0.24, 0.82, -0.24, 0.24], [-0.24, 0.24, -0.82, 0.24],
                [-0.82, 0.24, -0.82, -0.24], [-0.82, -0.24, -0.24, -0.24], [-0.24, -0.24, -0.24, -0.82],
                [-0.24, -0.82, 0.24, -0.24], [0.82, 0.24, 0.24, 0.82]
            ];
        break;

        case "drugmaking":
            _segments = [
                [-0.70, -0.72, 0.70, -0.72], [0.70, -0.72, -0.48, 0], [-0.48, 0, 0.70, 0.72],
                [0.70, 0.72, -0.70, 0.72], [-0.70, 0.72, 0.48, 0], [0.48, 0, -0.70, -0.72],
                [-0.38, -0.46, 0.38, -0.46], [0.38, -0.46, -0.22, 0], [-0.22, 0, 0.38, 0.46]
            ];
        break;

        case "workshop":
            _segments = [
                [0, -0.82, -0.74, 0.55], [-0.74, 0.55, 0.74, 0.55], [0.74, 0.55, 0, -0.82],
                [0, -0.55, -0.48, 0.36], [-0.48, 0.36, 0.48, 0.36], [0.48, 0.36, 0, -0.55]
            ];
        break;

        case "raids":
            _segments = [
                [-0.68, -0.68, 0.45, -0.68], [0.45, -0.68, 0.68, -0.45], [0.68, -0.45, 0.68, 0.68],
                [0.68, 0.68, -0.45, 0.68], [-0.45, 0.68, -0.68, 0.45], [-0.68, 0.45, -0.68, -0.68],
                [-0.40, -0.40, 0.40, -0.40], [0.40, -0.40, 0.40, 0.40], [0.40, 0.40, -0.40, 0.40],
                [-0.40, 0.40, -0.40, -0.40], [-0.68, -0.68, -0.40, -0.40], [0.68, 0.68, 0.40, 0.40]
            ];
        break;

        default:
            _segments = [
                [-0.72, -0.72, 0.72, -0.72], [0.72, -0.72, 0.72, 0.72],
                [0.72, 0.72, -0.72, 0.72], [-0.72, 0.72, -0.72, -0.72]
            ];
        break;
    }

    draw_set_font(fnt_ascii);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    for (var _row = 0; _row < _rows; _row++)
    {
        var _line = "";
        var _screen_y = (_row - ((_rows - 1) * 0.5)) / (_rows * 0.5);

        for (var _column = 0; _column < _columns; _column++)
        {
            var _screen_x = (_column - ((_columns - 1) * 0.5)) / (_columns * 0.5);
            var _local_x = (_screen_x * _rotation_cos) + (_screen_y * _rotation_sin);
            var _local_y = ((-_screen_x * _rotation_sin) + (_screen_y * _rotation_cos)) * (0.94 + (cos(_angle * 2) * 0.05));
            _local_x -= _local_y * _wobble;

            var _nearest_distance_squared = 100;
            var _nearest_segment = 0;
            var _nearest_t = 0;

            for (var _segment_index = 0; _segment_index < array_length(_segments); _segment_index++)
            {
                var _segment = _segments[_segment_index];
                var _edge_x = _segment[2] - _segment[0];
                var _edge_y = _segment[3] - _segment[1];
                var _edge_length_squared = sqr(_edge_x) + sqr(_edge_y);
                var _edge_t = clamp(
                    (((_local_x - _segment[0]) * _edge_x) + ((_local_y - _segment[1]) * _edge_y)) / _edge_length_squared,
                    0,
                    1
                );
                var _offset_x = _local_x - (_segment[0] + (_edge_x * _edge_t));
                var _offset_y = _local_y - (_segment[1] + (_edge_y * _edge_t));
                var _distance_squared = sqr(_offset_x) + sqr(_offset_y);

                if (_distance_squared < _nearest_distance_squared)
                {
                    _nearest_distance_squared = _distance_squared;
                    _nearest_segment = _segment_index;
                    _nearest_t = _edge_t;
                }
            }

            var _joint_cut = _nearest_t < 0.10 && (_nearest_segment mod 2) == 0;
            if (_nearest_distance_squared > sqr(_beam_width) || _joint_cut)
            {
                _line += " ";
                continue;
            }

            var _edge_light = 1 - clamp(sqrt(_nearest_distance_squared) / _beam_width, 0, 1);
            var _traveling_light = 0.5 + (sin((_nearest_t * pi * 2) - (_angle * 4) + _nearest_segment) * 0.5);
            var _brightness = 0.30 + (_edge_light * 0.46) + (_traveling_light * 0.23);
            var _ramp_index = 1 + floor(clamp(_brightness, 0, 0.999) * _ramp_length);
            _line += string_char_at(_density_ramp, _ramp_index);
        }

        draw_set_color(global.hideout_interactive_color);
        draw_set_alpha(0.12);
        draw_text(_x + 2, _y + (_row * _line_height), _line);
        draw_set_color(global.hideout_secondary_color);
        draw_set_alpha(0.9);
        draw_text(_x, _y + (_row * _line_height), _line);
    }

    draw_set_font(_old_font);
    draw_set_color(_old_color);
    draw_set_alpha(_old_alpha);
    draw_set_halign(_old_halign);
    draw_set_valign(_old_valign);
}
