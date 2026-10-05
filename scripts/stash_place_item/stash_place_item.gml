function stash_place_item(_item_key, _x, _y, _rotation, _container = stash)
{
    if (is_undefined(item_get(_item_key))) return undefined;

    if (_x < 0 || _y < 0)
    {
        var found_position = false;

        for (var grid_y = 0; grid_y < _container.grid_height && !found_position; grid_y++)
        {
            for (var grid_x = 0; grid_x < _container.grid_width; grid_x++)
            {
                if (stash_item_fits(_item_key, grid_x, grid_y, _rotation, _container))
                {
                    _x = grid_x;
                    _y = grid_y;
                    found_position = true;
                    break;
                }
            }
        }

        if (!found_position) return undefined;
    }

    if (!stash_item_fits(_item_key, _x, _y, _rotation, _container)) return undefined;

    var item = {
        item_key: _item_key,
        quantity: 1,
        x: _x,
        y: _y,
        rotation: _rotation
    };

    array_push(_container.items, item);
    return item;
}
