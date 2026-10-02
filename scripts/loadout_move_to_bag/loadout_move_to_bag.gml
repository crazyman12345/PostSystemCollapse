function loadout_move_to_bag(_item_key)
{
    if (!inventory_has(_item_key, 1))
    {
        return false;
    }

    if (!inventory_remove(_item_key, 1))
    {
        return false;
    }

    if (!raid_bag_add(_item_key, 1))
    {
        inventory_add(_item_key, 1);
        return false;
    }

    return true;
}