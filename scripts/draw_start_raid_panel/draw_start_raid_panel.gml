function draw_start_raid_panel()
{
    var x1 = 1420;
    var y1 = 920;
    var x2 = 1890;
    var y2 = 1015;

    // ==============================
    // SOLID BACKGROUND
    // ==============================

    draw_set_color(c_black);
    draw_rectangle(
        x1,
        y1,
        x2,
        y2,
        false
    );

    // ==============================
    // BORDER
    // ==============================

    draw_set_color(c_lime);
    draw_rectangle(
        x1,
        y1,
        x2,
        y2,
        true
    );

    // ==============================
    // SELECTED INNER BORDER
    // ==============================

    if (loadout_focus == LoadoutFocus.START_RAID)
    {
        draw_rectangle(
            x1 + 5,
            y1 + 5,
            x2 - 5,
            y2 - 5,
            true
        );
    }

    // ==============================
    // TEXT
    // ==============================

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_lime);

    var text = "START RAID";

    if (loadout_focus == LoadoutFocus.START_RAID)
    {
        text = "> START RAID";
    }

    draw_text(
        (x1 + x2) * 0.5,
        (y1 + y2) * 0.5,
        text
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}