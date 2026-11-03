function draw_workshop()
{
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var margin = 0;
    var top = 80;
    var bottom = gui_h - 70;

    var left_x1 = 320;
    var left_x2 = 740;
    var right_x1 = left_x2 + 20;
    var right_x2 = gui_w - margin;

    var selected_key = workshop_keys[workshop_station_index];
    var bench = variable_struct_get(workshop_db, selected_key);
    var bench_level = variable_struct_get(workshop_progress, selected_key);
    var bench_available = workshop_bench_is_available(selected_key);
    var bench_name = bench_available ? bench.name : "???";

    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // MAIN TITLE
   // draw_text(margin, 30, "WORKSHOP");

    // PANELS
    draw_set_color(global.hideout_border_color);
    draw_border_frame2(left_x1, top, left_x2 - left_x1, bottom - top, true);
    draw_border_frame2(right_x1, top, right_x2 - right_x1, bottom - top, true);

    // LEFT PANEL TITLE
    draw_set_color(global.ui_text_color);
    draw_text(left_x1 + 20, top + 20, "BENCHES");

    // BENCH LIST
    var list_y = top + 60;
    var list_row_height = 52;
    var button_left = left_x1 + 20;
    var button_right = left_x2 - 20;
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);

    for (var i = 0; i < array_length(workshop_keys); i++)
    {
        var key = workshop_keys[i];
        var data = variable_struct_get(workshop_db, key);

        var available = workshop_bench_is_available(key);
        var row_top = list_y + i * list_row_height;
        var hovered = point_in_rectangle(_mouse_x, _mouse_y, button_left, row_top, button_right, row_top + 44);

        terminal_button(button_left, row_top, button_right, row_top + 44, available ? data.name : "???", i == workshop_station_index || hovered, available);
    }

    // RIGHT HEADER
    draw_text(right_x1 + 20, top + 20, bench_name);

    var status_text = "";
    if (bench_level > 0) status_text = "LEVEL " + string(bench_level);

    draw_set_halign(fa_right);
    draw_text(right_x2 - 20, top + 20, status_text);
    draw_set_halign(fa_left);

    draw_workshop_upgrades(bench, selected_key, right_x1, top, right_x2, bottom);

}
