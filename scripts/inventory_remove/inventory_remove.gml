function inventory_remove(_item_key, _quantity)
{
    if (_quantity <= 0)
    {
        return false;
    }

    var current_quantity =
        inventory_get_quantity(_item_key);

    // Not enough owned
    if (current_quantity < _quantity)
    {
        return false;
    }

    var new_quantity =
        current_quantity - _quantity;

    variable_struct_set(
        inventory,
        _item_key,
        new_quantity
    );

    return true;
}