function draw_raid_progress()
{
    if (raid.room_number < 1)
        return;

    var _room_count = raid.room_count + 1;
    var _current_room = clamp(raid.room_number, 1, _room_count);
    var _gui_w = display_get_gui_width();
    var _tracker_offset = quest_tracker_is_visible() ? 480 : 0;
    var _line_x1 = _gui_w - 284 - _tracker_offset;
    var _line_x2 = _gui_w - 32 - _tracker_offset;
    var _line_y = 58;
    var _room_spacing = (_line_x2 - _line_x1) / (_room_count - 1);
    var _completed_color = make_color_rgb(36, 112, 62);
    var _future_color = make_color_rgb(45, 50, 48);

    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_lime);
    draw_text(_line_x1, 24, "ROOM " + string(_current_room));

    for (var i = 1; i < _room_count; i++)
    {
        var _segment_x1 = _line_x1 + ((i - 1) * _room_spacing);
        var _segment_x2 = _line_x1 + (i * _room_spacing);
        draw_set_color(i < _current_room ? _completed_color : _future_color);
        draw_line(_segment_x1, _line_y, _segment_x2, _line_y);
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    for (var _room = 1; _room <= _room_count; _room++)
    {
        var _room_x = _line_x1 + ((_room - 1) * _room_spacing);
        var _marker_color = _room < _current_room
            ? _completed_color
            : (_room == _current_room ? c_lime : _future_color);
        draw_set_color(_marker_color);

        if (_room == 5 || _room == raid.room_count)
        {
            draw_text(_room_x, _line_y, "*");
        }
        else if (_room == _room_count)
        {
            draw_circle(_room_x, _line_y - 1, 4, false);
            draw_rectangle(_room_x - 3, _line_y + 2, _room_x + 3, _line_y + 5, false);
            draw_set_color(c_black);
            draw_circle(_room_x - 2, _line_y - 1, 1, false);
            draw_circle(_room_x + 2, _line_y - 1, 1, false);
        }
        else
        {
            draw_line(_room_x, _line_y - 4, _room_x, _line_y + 4);
        }

        if (_room == _current_room)
        {
            draw_set_color(c_lime);
            draw_triangle(
                _room_x,
                _line_y - 11,
                _room_x - 4,
                _line_y - 6,
                _room_x + 4,
                _line_y - 6,
                false
            );
        }
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
