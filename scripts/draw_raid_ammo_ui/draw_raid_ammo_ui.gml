function draw_raid_ammo_ui()
{
    var _weapon = raid_update_active_weapon();

    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    var _x = _gui_w - 260;
    var _y = _gui_h - 120;

    draw_set_font(fnt_terminal_small);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // ======================================================
    // WEAPON SLOT STACK
    // ======================================================

    var _slot_x = _x - 200;
    var _slot_y = _y - 44;
    var _slot_width = 180;
    var _slot_height = 52;

    for (var _draw_index = 0; _draw_index < 2; _draw_index++)
    {
        var i = _draw_index;

        if (active_weapon_slot == EquipmentSlot.WEAPON)
        {
            i = 1 - _draw_index;
        }

        var _item_key = equipment_get_slot_item(raid.crew_index, i);
        var _item_name = "EMPTY";

        if (_item_key != "")
        {
            var _item = item_get(_item_key);

            if (is_struct(_item))
            {
                _item_name = _item.name;
            }
        }

        var _card_y = _slot_y + ((i - raid_weapon_slot_display) * 36);
        var _active = active_weapon_slot == i;

        draw_set_color(c_black);
        draw_rectangle(
            _slot_x,
            _card_y,
            _slot_x + _slot_width,
            _card_y + _slot_height,
            false
        );

        if (_active)
        {
            draw_set_color(c_lime);
        }
        else
        {
            draw_set_color(c_gray);
        }

        draw_rectangle(
            _slot_x,
            _card_y,
            _slot_x + _slot_width,
            _card_y + _slot_height,
            true
        );

        draw_text(
            _slot_x + 10,
            _card_y + 9,
            "SLOT " + string(i + 1)
        );
        draw_text(
            _slot_x + 10,
            _card_y + 28,
            _item_name
        );
    }

    if (!is_struct(_weapon))
    {
        draw_set_color(c_white);
        return;
    }


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
}
