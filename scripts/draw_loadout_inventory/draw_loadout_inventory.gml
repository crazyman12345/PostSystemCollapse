function draw_loadout_inventory(_x, _y)
{
    var inventory_items =
        inventory_get_visible_items();

    if (array_length(inventory_items) == 0)
    {
        draw_text(
            _x,
            _y,
            "INVENTORY EMPTY"
        );

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


        var display_text =
            item.name
            + " x"
            + string(quantity);


        if (variable_struct_exists(item, "weight"))
        {
            display_text +=
                "    "
                + string_format(
                    item.weight,
                    1,
                    2
                )
                + " KG";
        }


        terminal_menu_item(
            _x,
            _y + (i * 42),
            display_text,
            loadout_focus == LoadoutFocus.INVENTORY
                && loadout_inventory_index == i
        );
    }
}