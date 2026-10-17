function raid_inventory_get_grids()
{
    // Match draw_stash_equipment_and_carried_storage's raid panel layout.
    var grids = [];
    var backpack_height = 300;
    if (crew[raid.crew_index].bag != "")
    {
        array_push(grids, { storage: stash.backpack, left: 670, top: 150 });
        backpack_height = max(backpack_height, stash.backpack.grid_height * 60);
    }
    var pockets_top = 150 + backpack_height + 28;
    var secure_top = pockets_top + 170;
    array_push(grids, { storage: stash.pockets, left: 505, top: pockets_top, cell_size: 60, cell_stride: 66 });
    array_push(grids, { storage: stash.secure_container, left: 670, top: secure_top });
    var loot_grid = raid_inventory_get_loot_grid();
    if (!is_undefined(loot_grid)) array_push(grids, loot_grid);
    return grids;
}
