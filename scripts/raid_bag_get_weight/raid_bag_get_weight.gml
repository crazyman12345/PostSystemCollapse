function raid_bag_get_weight()
{
    var total_weight = 0;
    for (var i = 0; i < array_length(stash.backpack.items); i++)
    {
        var item = stash.backpack.items[i];
        var definition = item_get(item.item_key);
        if (!is_undefined(definition)) total_weight += definition.weight * item.quantity;
    }
    return total_weight;
}
