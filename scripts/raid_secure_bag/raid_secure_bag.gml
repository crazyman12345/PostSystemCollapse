function raid_secure_bag()
{
    // The backpack and secure container are already the persistent grids.
    // Return a held item to its source before dropping the temporary raid
    // references; no inventory instances are copied here.
    raid_inventory_clear_held();
    raid.inventory_rotation = 0;

    raid.active_loot_container = undefined;
    raid_lootables = [];
    raid.last_loot = [];
    raid.loot_index = 0;
}
