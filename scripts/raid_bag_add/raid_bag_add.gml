function raid_bag_add(_item_key, _quantity)
{
    if (_item_key == "")
        return false;

    if (_quantity <= 0)
        return false;

    var item =
        item_get(_item_key);

    if (is_undefined(item))
    {
        log_add(
            "Invalid raid bag item: "
            + string(_item_key)
        );

        return false;
    }


    var current = 0;

    if (variable_struct_exists(
        raid.bag,
        _item_key
    ))
    {
        current =
            variable_struct_get(
                raid.bag,
                _item_key
            );
    }


    variable_struct_set(
        raid.bag,
        _item_key,
        current + _quantity
    );

    return true;
}