function draw_pre_raid_bag_panel()
{
    var focus = false;

    if (loadout_focus == LoadoutFocus.RAID_BAG)
    {
        focus = true;
    }


    terminal_panel(
        60,
        590,
        760,
        360,
        "RAID BAG",
        focus
    );


    var bag_items =
        raid_bag_get_visible_items();


    draw_set_font(
        fnt_terminal_small
    );


    if (array_length(bag_items) == 0)
    {
        draw_text(
            110,
            670,
            "BAG EMPTY"
        );
    }
    else
    {
        for (
            var i = 0;
            i < array_length(bag_items);
            i++
        )
        {
            var item_key =
                bag_items[i];

            var item =
                item_get(
                    item_key
                );

            var quantity =
                raid_bag_get_quantity(
                    item_key
                );


            var _selected =
                loadout_focus == LoadoutFocus.RAID_BAG
                && raid_bag_index == i;


            // ==============================
            // FOCUSED ITEM FOR INFO PANEL
            // ==============================

            if (_selected)
            {
                loadout_focused_item_key =
                    item_key;
            }


            // ==============================
            // DISPLAY TEXT
            // ==============================

            var display_text =
                item.name
                + " x"
                + string(quantity);


            if (
                variable_struct_exists(
                    item,
                    "weight"
                )
            )
            {
                display_text +=
                    "    "
                    + string_format(
                        item.weight * quantity,
                        1,
                        2
                    )
                    + " KG";
            }


            terminal_menu_item(
                110,
                660 + (i * 38),
                display_text,
                _selected
            );
        }
    }


    // ==============================
    // BAG CAPACITY
    // ==============================

    draw_text(
        110,
        890,

        "WEIGHT: "
        + string_format(
            raid_bag_get_weight(),
            1,
            1
        )
        + " / "
        + string_format(
            raid_get_max_weight(),
            1,
            1
        )
        + " KG"
    );


    draw_set_font(
        fnt_terminal
    );
}