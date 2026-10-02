function raid_bag_get_visible_items()
{
    var all_keys =
        variable_struct_get_names(raid.bag);

    var visible_items = [];

    for (var i = 0; i < array_length(all_keys); i++)
    {
        var item_key = all_keys[i];

        if (raid_bag_get_quantity(item_key) > 0)
        {
            array_push(
                visible_items,
                item_key
            );
        }
    }

    return visible_items;
}