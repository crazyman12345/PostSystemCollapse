function raid_bag_get_weight()
{
    var _bag = armor_get_equipped_bag_stats();
    var total_weight = is_undefined(_bag) ? 0 : _bag.weight;
    var _chest = armor_get_equipped_chest_stats();
    var _head = armor_get_equipped_head_stats();
    if (!is_undefined(_chest)) total_weight += _chest.weight;
    if (!is_undefined(_head)) total_weight += _head.weight;
    var containers = [stash.backpack, stash.pockets, stash.secure_container];
    for (var container_index = 0; container_index < array_length(containers); container_index++)
    {
        var container = containers[container_index];
        for (var i = 0; i < array_length(container.items); i++)
        {
            var item = container.items[i];
            var definition = item_get(item.item_key);
            if (!is_undefined(definition) && definition.category == ItemCategory.WEAPON)
                definition = weapon_get_effective_stats(item);
            else if (!is_undefined(definition) && armor_category_is_equipment(definition.category))
                definition = armor_get_effective_stats(item);
            if (!is_undefined(definition))
            {
                var _weight = definition.weight * item.quantity;
                if (container_index == 0 && !is_undefined(_bag)) _weight *= _bag.stored_weight_multiplier;
                total_weight += _weight;
            }
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
