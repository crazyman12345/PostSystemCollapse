function raid_bag_remove(_item_key, _quantity)
{
    var current_quantity =
        raid_bag_get_quantity(_item_key);

    if (_quantity <= 0 || current_quantity < _quantity)
    {
        return false;
    }

    variable_struct_set(
        raid.bag,
        _item_key,
        current_quantity - _quantity
    );

    return true;
}