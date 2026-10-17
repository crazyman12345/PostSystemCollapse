function raid_bag_remove(_item_key, _quantity)
{
    if (_quantity <= 0 || raid_bag_get_quantity(_item_key) < _quantity) return false;

    for (var i = array_length(stash.backpack.items) - 1; i >= 0 && _quantity > 0; i--)
    {
        var item = stash.backpack.items[i];
        if (item.item_key != _item_key) continue;
        var removed = min(item.quantity, _quantity);
        item.quantity -= removed;
        _quantity -= removed;
        if (item.quantity == 0) stash_remove_item(item, stash.backpack);
    }
    save_mark_dirty();
    return true;
}
