function craft_basic_grow()
{
    if (!can_craft_basic_grow())
    {
        log_add(
            "Unable to craft Morrowleaf Grow Kit: missing materials."
        );

        return false;
    }

    inventory_remove("dirt", 2);
    inventory_remove("fertilizer", 1);
    inventory_remove("morrowleaf_seed", 1);

    inventory_add(
        "morrowleaf_grow_kit",
        1
    );

    log_add(
        "Crafted Morrowleaf Grow Kit."
    );

    return true;
}