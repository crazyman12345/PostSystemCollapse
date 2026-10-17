function inventory_quick_transfer(_item, _source, _destinations)
{
    if (is_undefined(_item) || is_undefined(_source)) return false;

    var transferred = false;

    // Fill compatible stacks before occupying another grid slot.
    for (var destination_index = 0; destination_index < array_length(_destinations) && _item.quantity > 0; destination_index++)
    {
        var destination = _destinations[destination_index];
        if (is_undefined(destination) || destination == _source) continue;

        for (var item_index = 0; item_index < array_length(destination.items) && _item.quantity > 0; item_index++)
        {
            if (inventory_merge_stacks(_item, destination.items[item_index]) > 0) transferred = true;
        }
    }

    if (_item.quantity <= 0)
    {
        stash_remove_item(_item, _source);
        return true;
    }

    var definition = item_get(_item.item_key);
    if (is_undefined(definition)) return transferred;

    for (var destination_index = 0; destination_index < array_length(_destinations); destination_index++)
    {
        var destination = _destinations[destination_index];
        if (is_undefined(destination) || destination == _source) continue;

        var rotations = [_item.rotation];
        if (definition.grid_width != definition.grid_height) array_push(rotations, _item.rotation == 90 ? 0 : 90);

        for (var rotation_index = 0; rotation_index < array_length(rotations); rotation_index++)
        {
            var rotation = rotations[rotation_index];
            for (var grid_y = 0; grid_y < destination.grid_height; grid_y++)
            {
                for (var grid_x = 0; grid_x < destination.grid_width; grid_x++)
                {
                    if (!stash_item_fits(_item.item_key, grid_x, grid_y, rotation, destination)) continue;

                    stash_remove_item(_item, _source);
                    _item.x = grid_x;
                    _item.y = grid_y;
                    _item.rotation = rotation;
                    array_push(destination.items, _item);
                    return true;
                }
            }
        }
    }

    return transferred;
}
