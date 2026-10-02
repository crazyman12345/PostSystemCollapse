function draw_inraid_bag_panel()
{
    var focus = false;

    if (loadout_focus == LoadoutFocus.RAID_BAG)
    {
        focus = true;
    }


    terminal_panel(
        860,
        150,
        1000,
        800,
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
            920,
            230,
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
            // ITEM TEXT
            // ==============================

            var text =
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
                text +=
                    "    "
                    + string_format(
                        item.weight
                        * quantity,
                        1,
                        2
                    )
                    + " KG";
            }


            terminal_menu_item(
                920,
                230 + (i * 42),
                text,
                _selected
            );
        }
    }


    // ==============================
    // BAG WEIGHT
    // ==============================

    draw_text(
        920,
        870,

        "WEIGHT: "
        + string_format(
            raid_bag_get_weight(),
            1,
            1
        )
        + " / "
        + string_format(
            raid_bag_get_max_weight(),
            1,
            1
        )
        + " KG"
    );


    draw_set_font(
        fnt_terminal
    );
}