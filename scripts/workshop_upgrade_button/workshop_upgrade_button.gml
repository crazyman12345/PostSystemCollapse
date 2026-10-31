function workshop_upgrade_button(_key, _x1, _top, _x2, _draw)
{
    var bench = variable_struct_get(workshop_db, _key);
    var level = variable_struct_get(workshop_progress, _key);
    var maxed = level >= bench.max_level;
    var req_count = 0;
    if (!maxed) req_count = array_length(bench.upgrade_requirements[level]);

    // Share the button bounds between drawing and mouse input.
    var left = _x1 + 200;
    var top = _top + 280 + req_count * 35;
    var right = _x2 - 200;
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

        draw_set_color(enabled ? global.ui_interactive_color : c_gray);
        draw_rectangle(left, top, right, bottom, true);
        if (enabled && hovered) label = "> " + label + " <";
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text((left + right) * 0.5, (top + bottom) * 0.5, label);
        if (!maxed && !enabled)
        {
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_text(left, bottom + 15, "INSUFFICIENT MATERIALS");
        }
        draw_set_color(previous_color);
        draw_set_halign(previous_halign);
        draw_set_valign(previous_valign);
    }

    return enabled && hovered && mouse_check_button_pressed(mb_left);
}
