function equipment_can_equip_bag(_item_key)
{
    if (_item_key == "")
    {
        return raid_bag_get_weight() <= 2.0;
    }

    var item =
        item_get(_item_key);

    if (is_undefined(item))
    {
        return false;
    }

    return
        raid_bag_get_weight()
        <= item.bag_capacity;
}