function raid_bag_get_quantity(_item_key)
{
    var quantity = 0;
    var containers = [stash.backpack, stash.pockets];
    for (var container_index = 0; container_index < array_length(containers); container_index++)
    {
        var container = containers[container_index];
        for (var i = 0; i < array_length(container.items); i++)
        {
            var item = container.items[i];
            if (item.item_key == _item_key) quantity += item.quantity;
        }
    }
    return quantity;
}
