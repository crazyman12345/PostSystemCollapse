function draw_raid_texture_crop_debug()
{
    if (state != GameState.RAID || !raid_texture_crop_debug_active) return;

    var _material = raid_texture_crop_debug_material();
    var _names = ["Crop Left", "Crop Right", "Crop Top", "Crop Bottom", "Offset X", "Offset Y", "UV Offset U", "UV Offset V", "Scale X", "Scale Y"];
    var _fields = ["crop_left", "crop_right", "crop_top", "crop_bottom", "offset_x", "offset_y", "uv_offset_u", "uv_offset_v", "scale_x", "scale_y"];
    var _green = c_lime;
    var _selected = make_color_rgb(180, 255, 180);

    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(0.92);
    draw_set_color(c_black);
    draw_rectangle(40, 70, 550, 710, false);
    draw_set_alpha(1);
    draw_set_color(_green);
    draw_rectangle(40, 70, 550, 710, true);
    draw_text(60, 82, "TEXTURE CROPPING  [F7 CLOSE]");

    raid_texture_crop_debug_draw_button(60, 110, 230, 30, "INNER FACE", raid_texture_crop_debug_tab == 0, false);
    raid_texture_crop_debug_draw_button(300, 110, 230, 30, "TOP CAP", raid_texture_crop_debug_tab == 1, false);

    for (var _row = 0; _row < 10; _row++)
    {
        var _row_y = 165 + _row * 40;
        var _value = variable_struct_get(_material, _fields[_row]);
        draw_set_color(raid_texture_crop_debug_selection == _row ? _selected : _green);
        draw_text(60, _row_y + 3, _names[_row]);
        draw_line(210, _row_y + 12, 390, _row_y + 12);
        var _knob_x;
        if (_row < 6)
            _knob_x = 210 + ((_value + 45) / 90) * 180;
        else if (_row < 8)
            _knob_x = 210 + ((_value + 100) / 200) * 180;
        else
            _knob_x = 210 + ((_value - 10) / 190) * 180;
        draw_rectangle(_knob_x - 3, _row_y + 7, _knob_x + 3, _row_y + 17, false);
        raid_texture_crop_debug_draw_button(410, _row_y, 32, 24, "-", false, false);
        draw_set_halign(fa_center);
        draw_text(476, _row_y + 3, string(_value) + "%");
        draw_set_halign(fa_left);
        raid_texture_crop_debug_draw_button(510, _row_y, 32, 24, "+", false, false);
    }

    raid_texture_crop_debug_draw_button(60, 585, 225, 28, "RESET CURRENT MATERIAL", false, raid_texture_crop_debug_selection == 10);
    raid_texture_crop_debug_draw_button(305, 585, 225, 28, "RESET ALL", false, raid_texture_crop_debug_selection == 11);
    raid_texture_crop_debug_draw_button(60, 625, 225, 28, "SAVE VALUES", false, raid_texture_crop_debug_selection == 12);
    raid_texture_crop_debug_draw_button(305, 625, 225, 28, "COPY SETTINGS", false, raid_texture_crop_debug_selection == 13);

    draw_set_color(_green);
    draw_text(60, 665, "TAB material  UP/DOWN select  LEFT/RIGHT adjust  ENTER activate");
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
