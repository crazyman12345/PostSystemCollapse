function stash_items_overlap(_first, _second)
{
    var first_definition = item_get(_first.item_key);
    var second_definition = item_get(_second.item_key);
    var first_width = first_definition.grid_width;
    var first_height = first_definition.grid_height;
    var second_width = second_definition.grid_width;
    var second_height = second_definition.grid_height;

    if (_first.rotation == 90)
    {
        var first_size = first_width;
        first_width = first_height;
        first_height = first_size;
    }

    if (_second.rotation == 90)
    {
        var second_size = second_width;
        second_width = second_height;
        second_height = second_size;
    }

    return _first.x < _second.x + second_width
        && _first.x + first_width > _second.x
        && _first.y < _second.y + second_height
        && _first.y + first_height > _second.y;
}
