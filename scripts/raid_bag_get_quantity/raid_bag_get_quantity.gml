function raid_bag_get_quantity(_item_key)
{
    if (!variable_struct_exists(raid.bag, _item_key))
    {
        return 0;
    }

    return variable_struct_get(
        raid.bag,
        _item_key
    );
}