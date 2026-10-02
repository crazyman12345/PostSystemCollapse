function raid_loot_result_add(_item_key, _quantity)
{
    if (_quantity <= 0)
    {
        return;
    }

    var current_quantity = 0;

    if (variable_struct_exists(raid.loot, _item_key))
    {
        current_quantity =
            variable_struct_get(
                raid.loot,
                _item_key
            );
    }

    variable_struct_set(
        raid.loot,
        _item_key,
        current_quantity + _quantity
    );
}