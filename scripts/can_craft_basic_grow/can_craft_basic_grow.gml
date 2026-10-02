function can_craft_basic_grow()
{
    return
        inventory_has("dirt", 2) &&
        inventory_has("fertilizer", 1) &&
        inventory_has("morrowleaf_seed", 1);
}