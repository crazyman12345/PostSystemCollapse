function stash_find_items(_item_key, _storage = stash)
{
    var items = [];

    for (var i = 0; i < array_length(_storage.items); i++)
    {
        if (_storage.items[i].item_key == _item_key) array_push(items, _storage.items[i]);
    }

    return items;
}

function stash_get_quantity(_item_key)
{
    var quantity = 0;
    var items = stash_find_items(_item_key);

    for (var i = 0; i < array_length(items); i++) quantity += items[i].quantity;
    return quantity;
}

function stash_has(_item_key, _quantity)
{
    return stash_get_quantity(_item_key) >= _quantity;
}

function stash_add(_item_key, _quantity, _storage = stash)
{
    var definition = item_get(_item_key);
    if (_quantity <= 0 || is_undefined(definition)) return false;

    var max_stack = item_get_max_stack(definition);
    var remaining_quantity = _quantity;
    var existing_items = stash_find_items(_item_key, _storage);

    if (definition.stackable)
    {
        for (var i = 0; i < array_length(existing_items); i++)
        {
            remaining_quantity -= min(remaining_quantity, max(0, max_stack - existing_items[i].quantity));
        }
    }

    var storage = { grid_width: _storage.grid_width, grid_height: _storage.grid_height, items: array_concat(_storage.items, []) };
    var additions = [];

    while (remaining_quantity > 0)
    {
        var placed_item = stash_place_item(_item_key, -1, -1, 0, storage);
        if (is_undefined(placed_item)) placed_item = stash_place_item(_item_key, -1, -1, 90, storage);
        if (is_undefined(placed_item)) return false;

        placed_item.quantity = min(remaining_quantity, max_stack);
        remaining_quantity -= placed_item.quantity;
        array_push(additions, placed_item);
    }

    remaining_quantity = _quantity;

    if (definition.stackable)
    {
        for (var i = 0; i < array_length(existing_items) && remaining_quantity > 0; i++)
        {
            var added_quantity = min(remaining_quantity, max(0, max_stack - existing_items[i].quantity));
            existing_items[i].quantity += added_quantity;
            remaining_quantity -= added_quantity;
        }
    }

    for (var i = 0; i < array_length(additions); i++) array_push(_storage.items, additions[i]);
    return true;
}

function stash_remove(_item_key, _quantity)
{
    if (_quantity <= 0 || !stash_has(_item_key, _quantity)) return false;

    for (var i = array_length(stash.items) - 1; i >= 0 && _quantity > 0; i--)
    {
        var item = stash.items[i];
        if (item.item_key != _item_key) continue;

        var removed_quantity = min(item.quantity, _quantity);
        item.quantity -= removed_quantity;
        _quantity -= removed_quantity;

        if (item.quantity <= 0) stash_remove_item(item);
    }

    return true;
}
