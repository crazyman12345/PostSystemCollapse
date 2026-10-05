function inventory_find_item_at(_container, _x, _y)
{
    for (var i = array_length(_container.items) - 1; i >= 0; i--)
    {
        var item = _container.items[i];
        var definition = item_get(item.item_key);
        var width = item.rotation == 90 ? definition.grid_height : definition.grid_width;
        var height = item.rotation == 90 ? definition.grid_width : definition.grid_height;
        if (_x >= item.x && _x < item.x + width && _y >= item.y && _y < item.y + height)
            return item;
    }
    return undefined;
}

function inventory_merge_stacks(_source, _target)
{
    if (!item_can_stack(_source, _target)) return 0;

    var amount = min(_source.quantity, max(0, item_get_max_stack(_target) - _target.quantity));
    if (amount <= 0) return 0;

    _target.quantity += amount;
    _source.quantity -= amount;

    if (_source.quantity <= 0 && variable_struct_exists(raid, "hotbar"))
    {
        for (var i = 0; i < array_length(raid.hotbar); i++)
            if (raid.hotbar[i] == _source) raid.hotbar[i] = _target;
    }

    return amount;
}

function inventory_can_place_item(_item, _x, _y, _container)
{
    var target = inventory_find_item_at(_container, _x, _y);
    if (!is_undefined(target)) return item_can_stack(_item, target) && target.quantity < item_get_max_stack(target);
    return stash_item_fits(_item.item_key, _x, _y, _item.rotation, _container);
}
