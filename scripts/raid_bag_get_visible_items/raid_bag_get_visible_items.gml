function raid_bag_get_visible_items()
{
    var visible_items = [];
    var containers = [stash.backpack, stash.pockets];
    for (var container_index = 0; container_index < array_length(containers); container_index++)
    {
        var container = containers[container_index];
        for (var i = 0; i < array_length(container.items); i++)
        {
            var item = container.items[i];
            if (item.quantity > 0 && !array_contains(visible_items, item.item_key))
                array_push(visible_items, item.item_key);
        }
    }
    return visible_items;
}
