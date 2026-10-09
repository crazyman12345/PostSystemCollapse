function loadout_move_to_bag(_item_key)
{
    var items = stash_find_items(_item_key);
    if (array_length(items) == 0) return false;

    var item = items[0];
    stash_remove_item(item);

    if (!stash_place_existing_item(item, stash.backpack))
    {
        array_push(stash.items, item);
        return false;
    }

    return true;
}
