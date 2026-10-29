function draw_raid_progress()
{
    if (raid.room_number < 1 || raid.current_room_type == RaidRoomType.BOSS) return;

    var _room_count = raid.room_count + 1;
    var _current_room = clamp(raid.room_number, 1, _room_count);
    var _gui_h = display_get_gui_height();
    var _panel_left = 20;
    var _panel_right = 400;
    var _panel_bottom = _gui_h - 20;
    var _panel_top = _panel_bottom - 112;
    var _marker_y = _panel_top + 58;
    var _line_x1 = _panel_left + 18;
    var _line_x2 = _panel_right - 18;
    var _room_spacing = (_line_x2 - _line_x1) / max(1, _room_count - 1);
    var _node_size = 14;
    var _completed_color = make_color_rgb(36, 112, 62);
    var _future_color = make_color_rgb(45, 50, 48);

    draw_terminal_rectangle(_panel_left, _panel_top, _panel_right, _panel_bottom);

    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_lime);
    draw_text(_panel_left + 14, _panel_top + 11, "RAID PROGRESS");

    for (var i = 1; i < _room_count; i++)
    {
        var _segment_x1 = _line_x1 + ((i - 1) * _room_spacing) + (_node_size * 0.5);
        var _segment_x2 = _line_x1 + (i * _room_spacing) - (_node_size * 0.5);
        draw_set_color(i < _current_room ? _completed_color : _future_color);
        draw_rectangle(_segment_x1, _marker_y - 2, _segment_x2, _marker_y + 2, false);
    }

    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    for (var _room = 1; _room <= _room_count; _room++)
    {
        var _room_x = _line_x1 + ((_room - 1) * _room_spacing);
        var _half_size = _room == _room_count ? 9 : _node_size * 0.5;
        var _node_color = _room < _current_room
            ? _completed_color
            : (_room == _current_room ? c_lime : _future_color);

        if (_room == _room_count)
        {
            draw_set_color(make_color_rgb(42, 12, 14));
            draw_rectangle(_room_x - _half_size, _marker_y - _half_size, _room_x + _half_size, _marker_y + _half_size, false);
            draw_set_color(c_red);
            draw_rectangle(_room_x - _half_size, _marker_y - _half_size, _room_x + _half_size, _marker_y + _half_size, true);
            draw_circle(_room_x, _marker_y - 1, 4, false);
            draw_set_color(c_black);
            draw_circle(_room_x - 2, _marker_y - 2, 1, false);
            draw_circle(_room_x + 2, _marker_y - 2, 1, false);
        }
        else
        {
            draw_set_color(_room < _current_room ? _completed_color : make_color_rgb(10, 16, 15));
            draw_rectangle(_room_x - _half_size, _marker_y - _half_size, _room_x + _half_size, _marker_y + _half_size, false);
            draw_set_color(_node_color);
            draw_rectangle(_room_x - _half_size, _marker_y - _half_size, _room_x + _half_size, _marker_y + _half_size, true);

            if (_room == 5 || _room == 10)
            {
                draw_set_color(c_lime);
                draw_text(_room_x, _marker_y, "*");
            }
        }
    }

    var _area_name = "UNKNOWN AREA";
    if (variable_struct_exists(raid, "selected_area") && is_struct(raid.selected_area))
        _area_name = raid.selected_area.name;

    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_gray);
    draw_text(_panel_left + 14, _panel_top + 82, "ROOM " + string(raid.room_number) + " - " + _area_name);
    draw_set_color(c_white);
}
