function draw_drug_lab()
{
    // ==============================
    // HEADER
    // ==============================

    terminal_header("DRUG LAB");


    terminal_panel(80, 180, 800, 520, "PRODUCTION");

    terminal_menu_item(
        120,
        400,
        "CRAFT BASIC GROW",
        menu_index == 0
    );

    terminal_menu_item(
        120,
        450,
        "ACTIVE GROWS",
        menu_index == 1
    );

    terminal_menu_item(
        120,
        500,
        "LAB UPGRADES",
        menu_index == 2
    );

	// ==============================
    // LAYOUT
    // ==============================

    var recipe_x = 1000;
    var recipe_value_offset = 400;
    var recipe_row_spacing = 50;
    var recipe_start_y = 260;
   
    // ==============================
    // RECIPE PANEL
    // ==============================

    terminal_panel(950, 180, 820, 520, "BASIC GROW RECIPE");

    terminal_value(
        recipe_x,
        recipe_start_y,
        "DIRT",
        string(inventory.dirt) + " / 2",
        recipe_value_offset
    );

    terminal_value(
        recipe_x,
        recipe_start_y + recipe_row_spacing,
        "FERTILIZER",
        string(inventory.fertilizer) + " / 1",
        recipe_value_offset
    );

    terminal_value(
        recipe_x,
        recipe_start_y + recipe_row_spacing * 2,
        "MORROWLEAF SEED",
        string(inventory.morrowleaf_seed) + " / 1",
        recipe_value_offset
    );

    if (can_craft_basic_grow())
    {
        draw_text(1000, 550, "[ READY TO CRAFT ]");
    }
    else
    {
        draw_text(1000, 550, "[ MISSING MATERIALS ]");
    }

    terminal_prompt(
        "W/S: SELECT    ENTER: CONFIRM    I: INVENTORY    ESC: BACK"
    );
}