function draw_workshop()
{
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var margin = 0;
    var top = 80;
    var bottom = gui_h - 70;

    var left_x1 = 320;
    var left_x2 = 920;
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
    var list_y = top + 70;

    for (var i = 0; i < array_length(workshop_keys); i++)
    {
        var key = workshop_keys[i];
        var data = variable_struct_get(workshop_db, key);
        var level = variable_struct_get(workshop_progress, key);

        var cursor = "  ";
        if (i == workshop_station_index) cursor = "> ";

        var available = workshop_bench_is_available(key);
        var status = available ? "[LOCKED]" : "";
        if (level > 0) status = "[LV." + string(level) + "]";

        draw_set_color(available ? global.ui_interactive_color : c_gray);
        draw_text(left_x1 + 25, list_y + i * 32, cursor + (available ? data.name : "???"));
        draw_set_color(global.ui_text_color);
        draw_text(left_x2 - 135, list_y + i * 32, status);
    }

    // SPRITE BOX
    var sprite_x1 = (left_x1 + left_x2 - 256) * 0.5;
    var sprite_y1 = top + 270;
    var sprite_x2 = sprite_x1 + 256;
    var sprite_y2 = sprite_y1 + 256;

    terminal_box(sprite_x1, sprite_y1, sprite_x2 - sprite_x1, sprite_y2 - sprite_y1);

    if (bench.sprite != -1)
    {
        var spr_w = sprite_get_width(bench.sprite);
        var spr_h = sprite_get_height(bench.sprite);

        var box_w = sprite_x2 - sprite_x1 - 30;
        var box_h = sprite_y2 - sprite_y1 - 30;

        var scale = min(box_w / spr_w, box_h / spr_h);

        var draw_x = (sprite_x1 + sprite_x2) * 0.5;
        var draw_y = (sprite_y1 + sprite_y2) * 0.5;

        draw_sprite_ext(bench.sprite, icon_spin_frame(bench.sprite), draw_x, draw_y, scale, scale, 0, merge_color(c_white, global.hideout_secondary_color, 0.35), 1);
    }

    // BENCH DESCRIPTION
    draw_text(left_x1 + 25, sprite_y2 + 25, bench_name);

    draw_text_ext(
        left_x1 + 25,
        sprite_y2 + 65,
        bench.description,
        24,
        left_x2 - left_x1 - 50
    );

    // RIGHT HEADER
    draw_text(right_x1 + 20, top + 20, bench_name);

    var status_text = bench_available ? "LOCKED" : "";
    if (bench_level > 0) status_text = "LEVEL " + string(bench_level);

    draw_set_halign(fa_right);
    draw_text(right_x2 - 20, top + 20, status_text);
    draw_set_halign(fa_left);

    var tab_y = top + 70;
    draw_text(right_x1 + 30, tab_y, "[ UPGRADES ]");

    draw_line(right_x1 + 20, tab_y + 35, right_x2 - 20, tab_y + 35);

    draw_workshop_upgrades(bench, selected_key, right_x1, top, right_x2, bottom);

}
