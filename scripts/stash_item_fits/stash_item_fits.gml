function stash_item_fits(_item_key, _x, _y, _rotation, _container = stash)
{
    var definition = item_get(_item_key);

    if (is_undefined(definition)) return false;

    var width = definition.grid_width;
    var height = definition.grid_height;

    if (_rotation == 90)
    {
        var size = width;
        width = height;
        height = size;
    }

    if (_x < 0 || _y < 0 || _x + width > _container.grid_width || _y + height > _container.grid_height)
        return false;

    var candidate = { item_key: _item_key, x: _x, y: _y, rotation: _rotation };

    for (var i = 0; i < array_length(_container.items); i++)
    {
        if (stash_items_overlap(candidate, _container.items[i])) return false;
    }

    return true;
}
