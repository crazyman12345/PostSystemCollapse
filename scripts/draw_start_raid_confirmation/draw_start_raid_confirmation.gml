function draw_start_raid_confirmation()
{
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var box_w = 600;
    var box_h = 300;

    var x1 = (gui_w - box_w) * 0.5;
    var y1 = (gui_h - box_h) * 0.5;
    var x2 = x1 + box_w;
    var y2 = y1 + box_h;

    // Background
    draw_set_color(c_black);
    draw_rectangle(
        x1,
        y1,
        x2,
        y2,
        false
    );

    // Border
    draw_set_color(c_lime);
    draw_rectangle(
        x1,
        y1,
        x2,
        y2,
        true
    );

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    draw_text(
        (x1 + x2) * 0.5,
        y1 + 40,
        "START RAID?"
    );

    // Optional selected location name
    if (variable_struct_exists(raid, "selected_area"))
    {
        draw_text(
            (x1 + x2) * 0.5,
            y1 + 85,
            raid.selected_area.name
        );
    }

    var yes_text = "YES";
    var no_text = "NO";

    if (loadout_confirm_index == 0)
    {
        yes_text = "> YES";
    }

    if (loadout_confirm_index == 1)
    {
        no_text = "> NO";
    }

    draw_text(
        (x1 + x2) * 0.5,
        y1 + 160,
        yes_text
    );

    draw_text(
        (x1 + x2) * 0.5,
        y1 + 200,
        no_text
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}