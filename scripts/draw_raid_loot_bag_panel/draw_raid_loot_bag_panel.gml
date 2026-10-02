function draw_raid_loot_bag_panel()
{
    var bag_items =
        raid_bag_get_visible_items();


    draw_set_font(
        fnt_terminal_small
    );


    // ========================================================
    // EMPTY BAG
    // ========================================================

    if (array_length(bag_items) <= 0)
    {
        draw_text(
            1000,
            270,
            "BAG EMPTY"
        );
    }
    else
    {
        // ====================================================
        // DRAW BAG CONTENTS
        // ====================================================

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


            if (is_undefined(item))
            {
                continue;
            }


            var quantity =
                raid_bag_get_quantity(
                    item_key
                );


            var display_text =
                item.name
                + " x"
                + string(quantity);


            // ------------------------------------------------
            // ITEM STACK WEIGHT
            // ------------------------------------------------

            if (
                variable_struct_exists(
                    item,
                    "weight"
                )
            )
            {
                var stack_weight =
                    item.weight
                    * quantity;


                display_text +=
                    "    "
                    + string_format(
                        stack_weight,
                        1,
                        2
                    )
                    + " KG";
            }


            draw_text(
                1000,
                270 + (i * 44),
                display_text
            );
        }
    }


    // ========================================================
    // BAG WEIGHT
    // ========================================================

    var current_weight =
        raid_bag_get_weight();

    var max_weight =
        raid_bag_get_max_weight();


    var weight_text =
        "WEIGHT: "
        + string_format(
            current_weight,
            1,
            1
        )
        + " / "
        + string_format(
            max_weight,
            1,
            1
        )
        + " KG";


    if (raid_is_overencumbered())
    {
        weight_text +=
            "  [OVERENCUMBERED]";
    }


    draw_text(
        1000,
        810,
        weight_text
    );


    // ========================================================
    // REMAINING CAPACITY
    // ========================================================

    var remaining =
        max(
            0,
            max_weight
            - current_weight
        );


    draw_text(
        1000,
        850,
        "AVAILABLE: "
        + string_format(
            remaining,
            1,
            1
        )
        + " KG"
    );


    draw_set_font(
        fnt_terminal
    );
}