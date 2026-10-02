function inventory_get_visible_items()
{
    var all_keys =
        variable_struct_get_names(inventory);

    var owned_items = [];

    for (var i = 0; i < array_length(all_keys); i++)
    {
        var item_key = all_keys[i];

        if (inventory_get_quantity(item_key) > 0)
        {
            array_push(
                owned_items,
                item_key
            );
        }
    }

    return owned_items;
}