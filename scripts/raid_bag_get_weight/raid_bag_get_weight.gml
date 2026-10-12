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

function strength_xp_for_weight(_weight)
{
    if (_weight < 5) return 0;
    if (_weight < 10) return 1;
    if (_weight < 20) return 2;
    if (_weight < 30) return 3;
    if (_weight < 40) return 4;
    if (_weight < 50) return 5;
    return 6;
}
