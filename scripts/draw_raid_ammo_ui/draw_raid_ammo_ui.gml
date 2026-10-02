function draw_raid_ammo_ui()
{
    var member = crew[0];

    if (member.weapon == "")
        return;

    var _weapon = item_get(member.weapon);

    if (!is_struct(_weapon))
        return;

    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    var _x = _gui_w - 260;
    var _y = _gui_h - 120;

    draw_set_font(fnt_terminal_small);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);


    // CURRENT MAG
    draw_text(
        _x,
        _y,
        string(raid_weapon_mag)
        + " / "
        + string(_weapon.mag_size)
    );


    // RESERVE AMMO
    var _reserve =
        raid_bag_get_quantity(
            _weapon.ammo_key
        );

    draw_text(
        _x,
        _y + 32,
        "RESERVE: "
        + string(_reserve)
    );


    // RELOAD STATUS
    if (raid_reload_active)
    {
        draw_text(
            _x,
            _y + 64,
            "RELOADING..."
        );
    }
    else if (raid_weapon_mag < _weapon.mag_size)
    {
        draw_text(
            _x,
            _y + 64,
            "[R] RELOAD"
        );
    }
}