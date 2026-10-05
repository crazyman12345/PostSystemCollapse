function inventory_add(_item_key, _quantity)
{
    // Make sure this item actually exists in the database
    if (!variable_struct_exists(global.items, _item_key))
    {
        show_debug_message(
            "ERROR: Tried to add unknown item: "
            + _item_key
        );

        return false;
    }

    if (_quantity <= 0)
    {
        return false;
    }

    var definition = item_get(_item_key);

    if (definition.stackable)
    {
        var max_stack = 999999;
        if (variable_struct_exists(definition, "max_stack"))
        {
            max_stack = max(1, definition.max_stack);
        }

        var stack_items = [];
        var total_quantity = _quantity;

        for (var i = 0; i < array_length(stash.items); i++)
        {
            if (stash.items[i].item_key == _item_key)
            {
                array_push(stack_items, stash.items[i]);
                total_quantity += stash.items[i].quantity;
            }
        }

        var required_stacks = ceil(total_quantity / max_stack);
        var new_stack_count = max(0, required_stacks - array_length(stack_items));
        var placed_stacks = [];

        for (var i = 0; i < new_stack_count; i++)
        {
            var placed_item = stash_place_item(_item_key, -1, -1, 0);

            if (is_undefined(placed_item))
            {
                for (var placed_index = 0; placed_index < array_length(placed_stacks); placed_index++)
                {
                    stash_remove_item(placed_stacks[placed_index]);
                }

                return false;
            }

            array_push(stack_items, placed_item);
            array_push(placed_stacks, placed_item);
        }

        for (var i = 0; i < array_length(stack_items); i++)
        {
            if (i < required_stacks)
            {
                stack_items[i].quantity = min(total_quantity, max_stack);
                total_quantity -= stack_items[i].quantity;
            }
            else
            {
                stash_remove_item(stack_items[i]);
            }
        }

        variable_struct_set(inventory, _item_key, inventory_get_quantity(_item_key) + _quantity);
        return true;
    }

    var placed_items = [];

    for (var i = 0; i < _quantity; i++)
    {
        var placed_item = stash_place_item(_item_key, -1, -1, 0);

        if (is_undefined(placed_item))
        {
            for (var placed_index = 0; placed_index < array_length(placed_items); placed_index++)
            {
                stash_remove_item(placed_items[placed_index]);
            }

            return false;
        }

        array_push(placed_items, placed_item);
    }

    if (definition.stackable) placed_items[0].quantity = _quantity;

    var current_quantity =
        inventory_get_quantity(_item_key);

    variable_struct_set(
        inventory,
        _item_key,
        current_quantity + _quantity
    );

    return true;
}
