function draw_equipment_item_select()
{
    var valid_items =
        equipment_get_valid_items(
            equipment_slot_index
        );

    var panel_x = 1220;
    var panel_y = 180;

    var panel_width = 600;
    var panel_height = 720;


    // ==============================
    // BLACK PANEL BACKGROUND
    // ==============================

    draw_set_color(c_black);

    draw_rectangle(
        panel_x,
        panel_y,
        panel_x + panel_width,
        panel_y + panel_height,
        false
    );

    // Restore terminal drawing color
    draw_set_color(c_lime);


    // ==============================
    // PANEL BORDER
    // ==============================

    terminal_panel(
        panel_x,
        panel_y,
        panel_width,
        panel_height,
        "AVAILABLE EQUIPMENT"
    );


    // ==============================
    // NONE / UNEQUIP
    // ==============================

    terminal_menu_item(
        panel_x + 40,
        panel_y + 80,
        "NONE",
        equipment_item_index == 0
    );


    // ==============================
    // AVAILABLE ITEMS
    // ==============================

    for (
        var i = 0;
        i < array_length(valid_items);
        i++
    )
    {
        var item_key =
            valid_items[i];

        var item =
            item_get(item_key);

        var quantity;

        if (raid.active)
        {
            quantity =
                raid_bag_get_quantity(item_key);
        }
        else
        {
            quantity =
                stash_get_quantity(item_key);
        }


        var display_text =
            item.name
            + " x"
            + string(quantity);


        // Show capacity for bags
        if (item.category == ItemCategory.BAG)
        {
            display_text +=
                "    "
                + string(item.bag_capacity)
                + " KG";
        }


        terminal_menu_item(
            panel_x + 40,
            panel_y + 140 + (i * 50),
            display_text,
            equipment_item_index == i + 1
        );
    }


    terminal_prompt(
        "W/S: SELECT    ENTER: EQUIP    ESC: CANCEL"
    );
}
