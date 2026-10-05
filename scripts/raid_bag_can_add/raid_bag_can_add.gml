function raid_bag_can_add(_item_key, _quantity)
{
    return !is_undefined(raid_bag_prepare_add(_item_key, _quantity));
}
