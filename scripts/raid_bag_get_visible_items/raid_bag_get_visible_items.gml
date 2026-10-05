function raid_bag_get_visible_items()
{
    var visible_items = [];
    for (var i = 0; i < array_length(stash.backpack.items); i++)
    {
        var item = stash.backpack.items[i];
        if (item.quantity > 0 && !array_contains(visible_items, item.item_key))
            array_push(visible_items, item.item_key);
    }
    return visible_items;
}
