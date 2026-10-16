function raid_inventory_get_loot_grid()
{
    if (is_undefined(raid.active_loot_container)) return undefined;

    return {
        key: "loot",
        storage: raid.active_loot_container.storage,
        left: 1300,
        top: 150,
        cell_size: 60
    };
}
