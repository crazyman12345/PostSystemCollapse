function raid_bag_get_weight()
{
    var total_weight = 0;
    var containers = [stash.backpack, stash.pockets];
    for (var container_index = 0; container_index < array_length(containers); container_index++)
    {
        var container = containers[container_index];
        for (var i = 0; i < array_length(container.items); i++)
        {
            var item = container.items[i];
            var definition = item_get(item.item_key);
            if (!is_undefined(definition)) total_weight += definition.weight * item.quantity;
        }
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
