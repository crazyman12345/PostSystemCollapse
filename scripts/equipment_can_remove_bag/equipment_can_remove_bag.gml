function equipment_can_remove_bag()
{
    if (!raid.active)
    {
        return true;
    }

    // No backpack = 2 KG pocket capacity
    var pocket_capacity = 2.0;

    return raid_bag_get_weight() <= pocket_capacity;
}