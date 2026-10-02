function inventory_add(_item_key, _quantity)
{
    // Make sure this item actually exists in the database
    if (!variable_struct_exists(global.items, _item_key))
    {
        show_debug_message(
            "ERROR: Tried to add unknown item: "
            + _item_key
        );

        return false;
    }

    if (_quantity <= 0)
    {
        return false;
    }

    var current_quantity =
        inventory_get_quantity(_item_key);

    variable_struct_set(
        inventory,
        _item_key,
        current_quantity + _quantity
    );

    return true;
}