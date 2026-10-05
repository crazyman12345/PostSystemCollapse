function raid_bag_get_quantity(_item_key)
{
    var quantity = 0;
    for (var i = 0; i < array_length(stash.backpack.items); i++)
    {
        var item = stash.backpack.items[i];
        if (item.item_key == _item_key) quantity += item.quantity;
    }
    return quantity;
}
