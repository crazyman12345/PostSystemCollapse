function raid_inventory_get_grids()
{
    // Match draw_stash_equipment_and_carried_storage's raid panel layout.
    var grids = [];
    var secure_top = 518;
    if (crew[raid.crew_index].bag != "")
    {
        array_push(grids, { storage: stash.backpack, left: 670, top: 150 });
        secure_top = 348 + (stash.backpack.grid_height * 60);
    }
    array_push(grids, { storage: stash.secure_container, left: 670, top: secure_top });
    var loot_grid = raid_inventory_get_loot_grid();
    if (!is_undefined(loot_grid)) array_push(grids, loot_grid);
    return grids;
}
