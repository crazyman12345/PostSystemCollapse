function draw_hideout_inventory_panel()
{
    var focus = false;

    if (loadout_focus == LoadoutFocus.INVENTORY)
    {
        focus = true;
    }


    terminal_panel(
        860,
        150,
        1000,
        800,
        "HIDEOUT INVENTORY",
        focus
    );


    var inventory_items =
        inventory_get_visible_items();


    draw_set_font(fnt_terminal_small);


    if (array_length(inventory_items) == 0)
    {
        draw_text(
            920,
            230,
            "INVENTORY EMPTY"
        );

        draw_set_font(fnt_terminal);
        return;
    }


    for (
        var i = 0;
        i < array_length(inventory_items);
        i++
    )
    {
        var item_key =
            inventory_items[i];

        var item =
            item_get(item_key);

        var quantity =
            inventory_get_quantity(item_key);


        var _selected =
            loadout_focus == LoadoutFocus.INVENTORY
            && loadout_inventory_index == i;


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
                    item.weight,
                    1,
                    2
                )
                + " KG EACH";
        }


        terminal_menu_item(
            920,
            230 + (i * 40),
            display_text,
            _selected
        );
    }


    draw_set_font(fnt_terminal);
}