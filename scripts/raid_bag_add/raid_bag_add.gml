function raid_bag_add(_item_key, _quantity)
{
	var collected_quantity = _quantity;
    var additions = raid_bag_prepare_add(_item_key, _quantity);
    if (is_undefined(additions)) return false;

    // Commit only after every new stack fits; keep existing instances in place.
    var definition = item_get(_item_key);
    var max_stack = 1;
    if (definition.stackable)
        max_stack = variable_struct_exists(definition, "max_stack") ? max(1, definition.max_stack) : 999999;

    for (var i = 0; i < array_length(stash.backpack.items) && _quantity > 0; i++)
    {
        var item = stash.backpack.items[i];
        if (!definition.stackable || item.item_key != _item_key) continue;
        var added = min(_quantity, max(0, max_stack - item.quantity));
        item.quantity += added;
        _quantity -= added;
    }
    for (var i = 0; i < array_length(additions); i++) array_push(stash.backpack.items, additions[i]);
	quest_event(QuestObjectiveType.COLLECT_ITEM, _item_key, collected_quantity);
    save_mark_dirty();
    return true;
}

function raid_bag_prepare_add(_item_key, _quantity)
{
    var definition = item_get(_item_key);
    var backpack = item_get(crew[raid.crew_index].bag);
    if (_quantity <= 0 || is_undefined(definition) || is_undefined(backpack)) return undefined;

    var max_stack = 1;
    if (definition.stackable)
        max_stack = variable_struct_exists(definition, "max_stack") ? max(1, definition.max_stack) : 999999;

    var storage = { grid_width: backpack.grid_width, grid_height: backpack.grid_height, items: array_concat(stash.backpack.items, []) };
    var additions = [];
    if (definition.stackable)
    {
        for (var i = 0; i < array_length(storage.items); i++)
        {
            var item = storage.items[i];
            if (item.item_key == _item_key) _quantity -= min(_quantity, max(0, max_stack - item.quantity));
        }
    }

    while (_quantity > 0)
    {
        var placed = stash_place_item(_item_key, -1, -1, 0, storage);
        if (is_undefined(placed)) placed = stash_place_item(_item_key, -1, -1, 90, storage);
        if (is_undefined(placed)) return undefined;
        placed.quantity = min(_quantity, max_stack);
        _quantity -= placed.quantity;
        array_push(additions, placed);
    }
    return additions;
}
