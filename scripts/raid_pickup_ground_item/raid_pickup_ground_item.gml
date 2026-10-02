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


    raid_bag_add(
        g.item_key,
        g.quantity
    );


    array_delete(
        raid_ground_items,
        _index,
        1
    );
}