function loadout_move_to_inventory(_item_key)
{
    if (!raid_bag_remove(_item_key, 1))
    {
        return false;
    }

    inventory_add(
        _item_key,
        1
    );

    return true;
}