function raid_inventory_get_hotbar_rect()
{
    var backpack_height = 300;
    if (crew[raid.crew_index].bag != "") backpack_height = max(backpack_height, stash.backpack.grid_height * 60);
    var pockets_top = 150 + backpack_height + 28;
    var secure_top = pockets_top + 170;

    return { left: 505, top: secure_top + (stash.secure_container.grid_height * 60) + 84, width: 424, height: 64 };
}
