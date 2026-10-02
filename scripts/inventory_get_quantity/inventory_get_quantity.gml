function inventory_get_quantity(_item_key)
{
    if (!variable_struct_exists(inventory, _item_key))
    {
        return 0;
    }

    return variable_struct_get(
        inventory,
        _item_key
    );
}