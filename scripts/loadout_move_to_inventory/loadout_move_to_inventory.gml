function loadout_move_to_inventory(_item_key)
{
    var items = stash_find_items(_item_key, stash.backpack);
    if (array_length(items) == 0) return false;

    var item = items[0];
    stash_remove_item(item, stash.backpack);

    if (!stash_place_existing_item(item))
    {
        array_push(stash.backpack.items, item);
        return false;
    }

    return true;
}
