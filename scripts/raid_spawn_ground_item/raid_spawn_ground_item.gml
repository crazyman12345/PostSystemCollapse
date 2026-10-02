function raid_spawn_ground_item(
    _item_key,
    _quantity,
    _x,
    _y
)
{
    var _ground_item = {
        item_key: _item_key,
        quantity: _quantity,

        ground_x: _x,
        ground_y: _y,

        width: 12,
        height: 8
    };


    array_push(
        raid_ground_items,
        _ground_item
    );
}