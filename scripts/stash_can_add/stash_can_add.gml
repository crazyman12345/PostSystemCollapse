function stash_can_add(_item_key, _quantity, _storage = stash)
{
    var _definition = item_get(_item_key);
    if (_quantity <= 0 || is_undefined(_definition)) return false;

    var _max_stack = item_get_max_stack(_definition);
    var _remaining = _quantity;
    if (_definition.stackable)
    {
        var _existing = stash_find_items(_item_key, _storage);
        for (var _i = 0; _i < array_length(_existing); _i++)
            _remaining -= min(_remaining, max(0, _max_stack - _existing[_i].quantity));
    }

    var _test_storage = {
        grid_width: _storage.grid_width,
        grid_height: _storage.grid_height,
        items: array_concat(_storage.items, [])
    };

    while (_remaining > 0)
    {
        var _placed = stash_place_item(_item_key, -1, -1, 0, _test_storage);
        if (is_undefined(_placed)) _placed = stash_place_item(_item_key, -1, -1, 90, _test_storage);
        if (is_undefined(_placed)) return false;
        _placed.quantity = min(_remaining, _max_stack);
        _remaining -= _placed.quantity;
    }
    return true;
}
