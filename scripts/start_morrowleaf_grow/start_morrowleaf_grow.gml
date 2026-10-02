function start_morrowleaf_grow()
{
    if (grow_active)
    {
        show_debug_message("A grow is already active.");
        return false;
    }

    if (!inventory_has("morrowleaf_grow_kit", 1))
	{
    log_add(
        "No Morrowleaf Grow Kit available."
    );
    return false;
	}

    inventory_remove(
    "morrowleaf_grow_kit",
    1
	);

    // Start grow
	log_add("Morrowleaf cultivation started");
    grow_active = true;
    grow.growth = 0;
    grow.health = 100;
    grow.quality = 50;
	grow.neglect_timer = 0;
    grow.moisture = 50;
    grow.nutrients = 50;
    grow.stress = 10;
	grow.water_cooldown = 0;
	grow.feed_cooldown = 0;
	grow.tend_cooldown = 0;
    grow.elapsed = 0;

    grow_menu_index = 0;
	
    return true;
}