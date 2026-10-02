function draw_raid_loot_found_panel()
{
    var loot =
        raid.last_loot;


    draw_set_font(
        fnt_terminal_small
    );


    // ========================================================
    // NO LOOT
    // ========================================================

    if (array_length(loot) <= 0)
    {
        draw_text(
            120,
            270,
            "NOTHING LEFT TO TAKE"
        );

        draw_set_font(
            fnt_terminal
        );

        return;
    }


    // ========================================================
    // DRAW LOOT
    // ========================================================

    for (
        var i = 0;
        i < array_length(loot);
        i++
    )
    {
        var loot_entry =
            loot[i];

        var item =
            item_get(
                loot_entry.item_key
            );


        if (is_undefined(item))
        {
            continue;
        }


        var display_text =
            item.name
            + " x"
            + string(
                loot_entry.quantity
            );


        // ----------------------------------------------------
        // WEIGHT
        // ----------------------------------------------------

        if (
            variable_struct_exists(
                item,
                "weight"
            )
        )
        {
            var total_weight =
                item.weight
                * loot_entry.quantity;


            display_text +=
                "    "
                + string_format(
                    total_weight,
                    1,
                    2
                )
                + " KG";
        }


        // ----------------------------------------------------
        // DRAW ITEM
        // ----------------------------------------------------

        terminal_menu_item(
            120,
            270 + (i * 44),
            display_text,
            raid.loot_index == i
        );
    }


    draw_set_font(
        fnt_terminal
    );
}