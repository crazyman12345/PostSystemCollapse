function raid_hotbar_find_item(_item)
{
    var containers = [stash.backpack, stash.pockets, stash.secure_container];
    for (var i = 0; i < array_length(containers); i++)
    {
        var container = containers[i];
        for (var j = 0; j < array_length(container.items); j++)
        {
            if (container.items[j] == _item) return container;
        }
    }
    return undefined;
}
