function raid_pickup_ground_item(_index)
{
    if (
        _index < 0
        || _index >= array_length(raid_ground_items)
    )
    {
        return;
    }


    var g =
        raid_ground_items[_index];


    if (!raid_bag_add(
        g.item_key,
        g.quantity
    )) return;


    array_delete(
        raid_ground_items,
        _index,
        1
    );
}
