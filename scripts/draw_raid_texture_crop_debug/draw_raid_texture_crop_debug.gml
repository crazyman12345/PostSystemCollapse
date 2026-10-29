function draw_raid_texture_crop_debug()
{
    if (state != GameState.RAID || !raid_texture_crop_debug_active) return;

    var _material = raid_texture_crop_debug_tab >= 2 ? undefined : raid_texture_crop_debug_material();
    var _names = raid_texture_crop_debug_tab == 5
        ? ["X Offset", "Floor Y Offset", "Width", "Height", "Projection X", "Projection Y", "Vertical Projection", "Perspective Strength X", "Perspective Strength Y", "Perspective Smoothing", "Source Scale X", "Source Scale Y", "Source Crop X", "Shadow Offset X", "Shadow Offset Y", "Contact Shadow Offset X", "Contact Shadow Offset Y"]
        : (raid_texture_crop_debug_tab == 4
        ? ["Vertical Projection", "Perspective Strength X", "Perspective Strength Y", "Perspective Smoothing"]
        : (raid_texture_crop_debug_tab == 3
            ? ["Projection Crop X", "Projection Crop Y", "Gun Offset Scale"]
            : (raid_texture_crop_debug_tab == 2
                ? ["Crop Left", "Crop Right", "Crop Top", "Crop Bottom", "Offset X", "Offset Y", "UV Offset U", "UV Offset V", "Scale X", "Scale Y", "Opening Left Offset", "Opening Right Offset", "Opening Top"]
                : ["Crop Left", "Crop Right", "Crop Top", "Crop Bottom", "Offset X", "Offset Y", "UV Offset U", "UV Offset V", "Scale X", "Scale Y"])));
    var _fields = ["crop_left", "crop_right", "crop_top", "crop_bottom", "offset_x", "offset_y", "uv_offset_u", "uv_offset_v", "scale_x", "scale_y"];
    var _green = c_lime;
    var _selected = make_color_rgb(180, 255, 180);

    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(0.92);
    draw_set_color(c_black);
    draw_rectangle(40, 70, 650, 710, false);
    draw_set_alpha(1);
    draw_set_color(_green);
    draw_rectangle(40, 70, 650, 710, true);
    draw_text(60, 82, "RAID VISUAL TUNING");

    raid_texture_crop_debug_draw_button(50, 110, 96, 30, "INNER FACE", raid_texture_crop_debug_tab == 0, false);
    raid_texture_crop_debug_draw_button(149, 110, 96, 30, "TOP CAP", raid_texture_crop_debug_tab == 1, false);
    raid_texture_crop_debug_draw_button(248, 110, 96, 30, "DOOR", raid_texture_crop_debug_tab == 2, false);
    raid_texture_crop_debug_draw_button(347, 110, 96, 30, "SHADOW", raid_texture_crop_debug_tab == 3, false);
    raid_texture_crop_debug_draw_button(446, 110, 96, 30, "ENVIRONMENT", raid_texture_crop_debug_tab == 4, false);
    raid_texture_crop_debug_draw_button(545, 110, 96, 30, "LADDER", raid_texture_crop_debug_tab == 5, false);

    var _visible_row_count = 10;
    var _first_row = clamp(raid_texture_crop_debug_scroll_row, 0, max(0, array_length(_names) - _visible_row_count));
    var _last_row = min(array_length(_names), _first_row + _visible_row_count);
    for (var _row = _first_row; _row < _last_row; _row++)
    {
        var _row_y = 165 + (_row - _first_row) * 40;
        var _value;
        if (raid_texture_crop_debug_tab == 5)
            _value = raid_texture_crop_debug_ladder_value(_row);
        else if (raid_texture_crop_debug_tab == 4)
            _value = _row == 0 ? raid_environment.vertical_projection
                : (_row == 1 ? raid_environment.perspective_strength_x
                : (_row == 2 ? raid_environment.perspective_strength_y : raid_environment.perspective_smoothing));
        else if (raid_texture_crop_debug_tab == 3)
            _value = _row == 0 ? raid_player_projected_shadow_offset_x
                : (_row == 1 ? raid_player_projected_shadow_offset_y : raid_shadow_gun_extra_offset_scale);
        else if (raid_texture_crop_debug_tab == 2)
            _value = raid_texture_crop_debug_door_value(_row);
        else _value = variable_struct_get(_material, _fields[_row]);
        draw_set_color(raid_texture_crop_debug_selection == _row ? _selected : _green);
        draw_text(60, _row_y + 3, _names[_row]);
        draw_line(210, _row_y + 12, 390, _row_y + 12);
        var _knob_x;
        if (raid_texture_crop_debug_tab == 5)
        {
            var _ladder_min = raid_texture_crop_debug_ladder_min(_row);
            var _ladder_max = raid_texture_crop_debug_ladder_max(_row);
            _knob_x = 210 + ((_value - _ladder_min) / (_ladder_max - _ladder_min)) * 180;
        }
        else if (raid_texture_crop_debug_tab == 4)
            _knob_x = 210 + (_value / (_row == 3 ? 1 : (_row == 0 ? 2 : 20))) * 180;
        else if (raid_texture_crop_debug_tab == 3 && _row == 2)
            _knob_x = 210 + (_value / 2) * 180;
        else if (raid_texture_crop_debug_tab == 3)
            _knob_x = 210 + ((_value + 100) / 200) * 180;
        else if (raid_texture_crop_debug_tab == 2 && _row < 6)
            _knob_x = 210 + ((_value + 45) / 90) * 180;
        else if (raid_texture_crop_debug_tab == 2 && _row < 8)
            _knob_x = 210 + ((_value + 100) / 200) * 180;
        else if (raid_texture_crop_debug_tab == 2 && _row < 10)
            _knob_x = 210 + ((_value - 10) / 190) * 180;
        else if (raid_texture_crop_debug_tab == 2 && _row < 12)
            _knob_x = 210 + ((_value + 100) / 200) * 180;
        else if (raid_texture_crop_debug_tab == 2)
            _knob_x = 210 + (_value / raid_environment.wall_height) * 180;
        else if (_row < 6)
            _knob_x = 210 + ((_value + 45) / 90) * 180;
        else if (_row < 8)
            _knob_x = 210 + ((_value + 100) / 200) * 180;
        else
            _knob_x = 210 + ((_value - 10) / 190) * 180;
        draw_rectangle(_knob_x - 3, _row_y + 7, _knob_x + 3, _row_y + 17, false);
        raid_texture_crop_debug_draw_button(410, _row_y, 32, 24, "-", false, false);
        draw_set_halign(fa_center);
        var _suffix = "";
        if (raid_texture_crop_debug_tab == 5 && _row >= 13) _suffix = " px";
        else if (raid_texture_crop_debug_tab == 3 && _row < 2) _suffix = " px";
        else if (raid_texture_crop_debug_tab == 2) _suffix = _row < 10 ? "%" : " px";
        else if (raid_texture_crop_debug_tab < 2) _suffix = "%";
        draw_text(476, _row_y + 3, (raid_texture_crop_debug_tab >= 4 ? string_format(_value, 0, 2) : string(_value)) + _suffix);
        draw_set_halign(fa_left);
        raid_texture_crop_debug_draw_button(510, _row_y, 32, 24, "+", false, false);
    }

    var _reset_label = "RESET CURRENT MATERIAL";
    if (raid_texture_crop_debug_tab == 2) _reset_label = "RESET DOOR VALUES";
    else if (raid_texture_crop_debug_tab == 3) _reset_label = "RESET PLAYER SHADOW";
    else if (raid_texture_crop_debug_tab == 4) _reset_label = "RESET ENVIRONMENT";
    else if (raid_texture_crop_debug_tab == 5) _reset_label = "RESET LADDER";
    raid_texture_crop_debug_draw_button(60, 585, 225, 28, _reset_label, false, raid_texture_crop_debug_selection == 20);
    raid_texture_crop_debug_draw_button(305, 585, 225, 28, "RESET ALL", false, raid_texture_crop_debug_selection == 21);
    raid_texture_crop_debug_draw_button(60, 625, 225, 28, "SAVE VALUES", false, raid_texture_crop_debug_selection == 22);
    raid_texture_crop_debug_draw_button(305, 625, 225, 28, "COPY SETTINGS", false, raid_texture_crop_debug_selection == 23);

    draw_set_color(_green);
    draw_text(60, 685, raid_texture_crop_debug_status);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);
}


function raid_texture_crop_debug_draw_button(_x, _y, _width, _height, _label, _filled, _selected)
{
    var _green = c_lime;
    var _selected_color = make_color_rgb(180, 255, 180);
    draw_set_color(_selected ? _selected_color : _green);
    if (_filled)
    {
        draw_rectangle(_x, _y, _x + _width, _y + _height, false);
        draw_set_color(c_black);
    }
    else draw_rectangle(_x, _y, _x + _width, _y + _height, true);
    draw_set_halign(fa_center);
    draw_text(_x + _width * 0.5, _y + 5, _label);
    draw_set_halign(fa_left);
}
