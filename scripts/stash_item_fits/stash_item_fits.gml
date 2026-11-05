function stash_item_fits(_item_key, _x, _y, _rotation, _container = stash)
{
    var definition = item_get(_item_key);

    if (is_undefined(definition)) return false;

    if (variable_struct_exists(_container, "single_cell_slots")
    && _container.single_cell_slots
    && (definition.grid_width != 1 || definition.grid_height != 1)) return false;

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

    if (variable_struct_exists(_container, "cell_limit"))
    {
        for (var cell_y = _y; cell_y < _y + height; cell_y++)
        {
            for (var cell_x = _x; cell_x < _x + width; cell_x++)
            {
                if ((cell_y * _container.grid_width) + cell_x >= _container.cell_limit) return false;
            }
        }
    }

    var candidate = { item_key: _item_key, x: _x, y: _y, rotation: _rotation };

    for (var i = 0; i < array_length(_container.items); i++)
    {
        if (stash_items_overlap(candidate, _container.items[i])) return false;
    }

    return true;
}
