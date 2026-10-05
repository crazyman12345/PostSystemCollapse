function inventory_remove(_item_key, _quantity)
{
    if (_quantity <= 0)
    {
        return false;
    }

    var current_quantity =
        inventory_get_quantity(_item_key);

    // Not enough owned
    if (current_quantity < _quantity)
    {
        return false;
    }

    var definition = item_get(_item_key);

    if (definition.stackable)
    {
        var stacked_quantity = 0;

        for (var i = 0; i < array_length(stash.items); i++)
        {
            var stash_item = stash.items[i];

            if (stash_item.item_key == _item_key)
            {
                stacked_quantity += stash_item.quantity;
            }
        }

        if (stacked_quantity < _quantity) return false;

        var remaining_quantity = _quantity;

        for (var i = array_length(stash.items) - 1; i >= 0 && remaining_quantity > 0; i--)
        {
            var stash_item = stash.items[i];

            if (stash_item.item_key == _item_key)
            {
                var removed_quantity = min(stash_item.quantity, remaining_quantity);
                stash_item.quantity -= removed_quantity;
                remaining_quantity -= removed_quantity;

                if (stash_item.quantity == 0) stash_remove_item(stash_item);
            }
        }
    }
    else
    {
        var matching_items = 0;

        for (var i = 0; i < array_length(stash.items); i++)
        {
            if (stash.items[i].item_key == _item_key)
            {
                matching_items++;
            }
        }

        if (matching_items < _quantity) return false;

        var removed = 0;

        for (var i = array_length(stash.items) - 1; i >= 0 && removed < _quantity; i--)
        {
            if (stash.items[i].item_key == _item_key)
            {
                stash_remove_item(stash.items[i]);
                removed++;
            }
        }
    }

    var new_quantity =
        current_quantity - _quantity;

    variable_struct_set(
        inventory,
        _item_key,
        new_quantity
    );

    return true;
}
