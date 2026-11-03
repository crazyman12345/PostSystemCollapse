function workshop_upgrade_button(_key, _x1, _top, _x2, _draw, _materials_bounds = false)
{
    var bench = variable_struct_get(workshop_db, _key);
    var level = variable_struct_get(workshop_progress, _key);
    var maxed = level >= bench.max_level;
    var req_count = 0;
    if (!maxed) req_count = array_length(bench.upgrade_requirements[level]);

    // Share the button bounds between drawing and mouse input.
    var materials_left = _materials_bounds ? _x1 : (_x1 + _x2) * 0.5 + 8;
    var materials_right = _materials_bounds ? _x2 : _x2 - 20;
    var left = materials_left + 14;
    var top = _top + 184 + req_count * 72;
    var right = materials_right - 14;
    var bottom = top + 48;
    var enabled = !maxed && workshop_can_upgrade(_key);
    var hovered = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), left, top, right, bottom);

    if (_draw)
    {
        var previous_color = draw_get_color();
        var previous_halign = draw_get_halign();
        var previous_valign = draw_get_valign();
        var label = level == 0 ? "BUILD" : "UPGRADE";
        if (maxed) label = "MAX LEVEL";
        var button_color = enabled ? global.ui_interactive_color : c_gray;
        if (hovered)
        {
            label = "> " + label + " <";
            if (!enabled) button_color = global.ui_text_color;
        }

        draw_set_color(button_color);
        terminal_box(left, top, right - left, bottom - top);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text((left + right) * 0.5, (top + bottom) * 0.5, label);
        draw_set_color(previous_color);
        draw_set_halign(previous_halign);
        draw_set_valign(previous_valign);
    }

    return enabled && hovered && mouse_check_button_pressed(mb_left);
}
