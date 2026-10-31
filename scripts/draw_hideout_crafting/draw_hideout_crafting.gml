function draw_hideout_crafting(_skill_key, _x1, _y1, _x2, _y2)
{
    var gap = 15;
    var panel_top = _y1 + 80;
    var panel_height = _y2 - panel_top - 20;
    var list_left = _x1 + 20;
    var list_width = 420;
    var details_left = list_left + list_width + gap;
    var details_width = 650;
    var inventory_left = details_left + details_width + gap;
    var inventory_width = _x2 - inventory_left - 20;
    var padding = 25;

    // Taller rows because each recipe now uses 2 lines
    var row_height = 52;

    var recipes = recipe_get_for_skill(_skill_key);
    var recipe_count = array_length(recipes);
    var skill_level = skill_get_level(_skill_key);
    var skill_info = skill_db_get(_skill_key);


    draw_set_font(fnt_terminal_small);
    draw_set_color(global.ui_text_color);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);


    terminal_panel(
        list_left,
        panel_top,
        list_width,
        panel_height,
        "RECIPES"
    );

    terminal_panel(
        details_left,
        panel_top,
        details_width,
        panel_height,
        "RECIPE DETAILS"
    );

    terminal_panel(
        inventory_left,
        panel_top,
        inventory_width,
        panel_height,
        "MATERIAL INVENTORY"
    );


    // ==============================
    // SKILL HEADER
    // ==============================

    draw_text(
        list_left + padding,
        panel_top + 45,
        skill_info.name
        + "  LVL "
        + string(skill_level)
    );


    // ==============================
    // NO RECIPES
    // ==============================

    if (recipe_count == 0)
    {
        draw_text(
            list_left + padding,
            panel_top + 95,
            "NO RECIPES AVAILABLE"
        );

        return;
    }


    // ==============================
    // RECIPE LIST
    // ==============================

    var selected_index =
        clamp(
            crafting_recipe_index,
            0,
            recipe_count - 1
        );

    var last_recipe =
        min(
            crafting_recipe_scroll
            + crafting_visible_rows,
            recipe_count
        );

    var list_y =
        panel_top + 95;


    for (
        var i = crafting_recipe_scroll;
        i < last_recipe;
        i++
    )
    {
        var listed_recipe =
            recipes[i];

        var locked =
            skill_level
            < listed_recipe.skill_level;

        var selected =
            selected_index == i;

        var row_y =
            list_y
            + ((i - crafting_recipe_scroll)
            * row_height);


        // ==============================
        // RECIPE NAME
        // ==============================

        if (locked)
            draw_set_color(c_gray);
        else
            draw_set_color(global.ui_text_color);


        terminal_menu_item(
            list_left + padding,
            row_y,
            listed_recipe.name,
            selected,
            !locked
        );


        // ==============================
        // LEVEL / LOCKED SUB-LINE
        // ==============================

        var status_text =
            "LVL "
            + string(
                listed_recipe.skill_level
            );

        if (locked)
            status_text += "  [LOCKED]";


        draw_text_transformed(
            list_left + padding + 20,
            row_y + 22,
            status_text,
            0.8,
            0.8,
            0
        );
    }


    draw_set_color(global.ui_text_color);


    // ==============================
    // SCROLL INDICATORS
    // ==============================

    if (crafting_recipe_scroll > 0)
    {
        draw_text(
            list_left + list_width - 45,
            list_y,
            "^"
        );
    }


    if (last_recipe < recipe_count)
    {
        draw_text(
            list_left + list_width - 45,
            panel_top + panel_height - 100,
            "v"
        );
    }


    draw_text(
        list_left + padding,
        panel_top + panel_height - 90,
        "RECIPE "
        + string(selected_index + 1)
        + " / "
        + string(recipe_count)
    );


    // ==============================
    // SELECTED RECIPE DETAILS
    // ==============================

    var recipe =
        recipes[selected_index];

    var details_x =
        details_left + padding;

    var details_y =
        panel_top + 50;

    var level_ok =
        skill_level >= recipe.skill_level;


    draw_text(
        details_x,
        details_y,
        recipe.name
    );


    details_y += 45;


    draw_text(
        details_x,
        details_y,

        (level_ok ? "[OK] " : "[X] ")
        + "REQUIRED "
        + skill_info.name
        + ": "
        + string(skill_level)
        + "/"
        + string(recipe.skill_level)
    );


    details_y += 55;


    draw_text(
        details_x,
        details_y,
        "INGREDIENTS"
    );


    details_y += 40;


    // ==============================
    // INGREDIENTS
    // ==============================

    for (
        var ingredient_index = 0;
        ingredient_index
        < array_length(recipe.ingredients);
        ingredient_index++
    )
    {
        var ingredient =
            recipe.ingredients[
                ingredient_index
            ];

        var ingredient_item =
            item_get(
                ingredient.item_key
            );

        var owned =
            stash_get_quantity(
                ingredient.item_key
            );

        var ingredient_ok =
            owned >= ingredient.quantity;


        draw_text(
            details_x,
            details_y,

            (ingredient_ok
                ? "[OK] "
                : "[X] ")

            + ingredient_item.name
            + "  "
            + string(owned)
            + "/"
            + string(
                ingredient.quantity
            )
        );


        details_y += 36;
    }


    // ==============================
    // OUTPUT
    // ==============================

    var output_item =
        item_get(
            recipe.output.item_key
        );


    details_y += 25;


    draw_text(
        details_x,
        details_y,
        "OUTPUT"
    );


    details_y += 40;


    draw_text(
        details_x,
        details_y,

        output_item.name
        + "  x"
        + string(
            recipe.output.quantity
        )
    );


    details_y += 55;


    // ==============================
    // CRAFT TIME
    // ==============================

    if (
        variable_struct_exists(
            recipe,
            "craft_time"
        )
    )
    {
        draw_text(
            details_x,
            details_y,

            "CRAFT TIME: "
            + string(
                recipe.craft_time
            )
            + " SEC"
        );

        details_y += 36;
    }


    // ==============================
    // XP
    // ==============================

    if (
        variable_struct_exists(
            recipe,
            "xp"
        )
    )
    {
        draw_text(
            details_x,
            details_y,

            "CRAFT XP: "
            + string(recipe.xp)
        );

        details_y += 36;
    }


    if (crafting_message != "")
    {
        draw_text(
            details_x,
            panel_top
            + panel_height
            - 55,
            crafting_message
        );
    }


    // ==============================
    // MATERIAL INVENTORY
    // ==============================

    var inventory_x =
        inventory_left + padding;

    var inventory_y =
        panel_top + 50;


    draw_text(
        inventory_x,
        inventory_y,
        "RELEVANT MATERIALS"
    );


    inventory_y += 45;


    for (
        var material_index = 0;
        material_index
        < array_length(recipe.ingredients);
        material_index++
    )
    {
        var material =
            recipe.ingredients[
                material_index
            ];

        var material_item =
            item_get(
                material.item_key
            );

        var material_owned =
            stash_get_quantity(
                material.item_key
            );


        draw_text(
            inventory_x,
            inventory_y,
            material_item.name
        );


        inventory_y += 30;


        draw_text(
            inventory_x + 20,
            inventory_y,

            "OWNED: "
            + string(material_owned)
            + "  REQUIRED: "
            + string(
                material.quantity
            )
        );


        inventory_y += 50;
    }
}
