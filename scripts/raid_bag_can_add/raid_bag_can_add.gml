function raid_bag_can_add(_item_key, _quantity)
{
    if (_quantity <= 0)
    {
        return false;
    }

    var item =
        item_get(_item_key);

    if (is_undefined(item))
    {
        return false;
    }

    var added_weight =
        item.weight * _quantity;

    return
        raid_bag_get_weight()
        + added_weight
        <= raid_bag_get_max_weight();
}