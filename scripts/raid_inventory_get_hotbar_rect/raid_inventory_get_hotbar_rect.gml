function raid_inventory_get_hotbar_rect()
{
    var secure_top = 518;
    if (crew[raid.crew_index].bag != "")
        secure_top = 348 + (stash.backpack.grid_height * 60);

    return { left: 505, top: secure_top + 48 + (stash.secure_container.grid_height * 60) + 234, width: 424, height: 64 };
}
