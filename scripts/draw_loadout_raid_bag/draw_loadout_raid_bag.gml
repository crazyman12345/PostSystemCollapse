function draw_loadout_raid_bag(_x, _y)
{
    var bag_items =
        raid_bag_get_visible_items();


    if (array_length(bag_items) == 0)
    {
        draw_text(
            _x,
            _y,
            "EMPTY"
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
            // DRAW ITEM
            // ==============================

            terminal_menu_item(
                _x,
                _y + (i * 42),

                item.name
                + " x"
                + string(quantity),

                _selected
            );
        }
    }


    // ==============================
    // BAG WEIGHT
    // ==============================

    draw_text(
        _x,
        _y + 250,

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
}