function step_hideout_crafting(_skill_key)
{
    if (crafting_minigame_state.active)
    {
        step_weapon_crafting_minigame();
        return;
    }

    var all_recipes = recipe_get_for_skill(_skill_key);
    var recipes = [];
    for (var recipe_index = 0; recipe_index < array_length(all_recipes); recipe_index++)
    {
        var available_recipe = all_recipes[recipe_index];
        if (recipe_is_unlocked(_skill_key, available_recipe)) array_push(recipes, available_recipe);
    }

    var recipe_count = array_length(recipes);
    if (recipe_count > 0)
    {
        var panel_top = 80;
        var panel_height = display_get_gui_height() - panel_top - 20;
        var list_left = 340;
        var content_right = display_get_gui_width() - 20;
        var gap = 15;
        var panel_width = floor((content_right - list_left - gap) * 0.5);
        var details_left = list_left + panel_width + gap;
        var padding = 20;
        var list_row_height = 76;
        var list_row_pitch = 84;
        var row_pitch = 72;
        var list_top = panel_top + 50;
        var skill_info_height = 220;
        list_top += skill_info_height + 12;
        var visible_rows = max(1, floor((panel_height - 115 - skill_info_height - 12) / list_row_pitch));
        var mouse_gui_x = device_mouse_x_to_gui(0);
        var mouse_gui_y = device_mouse_y_to_gui(0);
        var hovered_recipe = -1;

        var mouse_over_list = point_in_rectangle(mouse_gui_x, mouse_gui_y, list_left, panel_top,
            list_left + panel_width, panel_top + panel_height);
        if (mouse_over_list && mouse_wheel_up()) crafting_recipe_scroll--;
        if (mouse_over_list && mouse_wheel_down()) crafting_recipe_scroll++;

        crafting_recipe_index = clamp(crafting_recipe_index, 0, recipe_count - 1);
        crafting_recipe_scroll = clamp(crafting_recipe_scroll, 0, max(0, recipe_count - visible_rows));
        var last_recipe = min(crafting_recipe_scroll + visible_rows, recipe_count);

        for (var i = crafting_recipe_scroll; i < last_recipe; i++)
        {
            var row_top = list_top + (i - crafting_recipe_scroll) * list_row_pitch;
            if (point_in_rectangle(mouse_gui_x, mouse_gui_y, list_left + padding, row_top,
                list_left + panel_width - padding, row_top + list_row_height))
            {
                hovered_recipe = i;
                break;
            }
        }

        ui_hover_sound("crafting_recipe", hovered_recipe == -1 ? "" : string(hovered_recipe));
        if (hovered_recipe != -1 && mouse_check_button_pressed(mb_left))
        {
            crafting_recipe_index = hovered_recipe;
            audio_play_sound(snd_interact, 0, false);
        }

        var recipe = recipes[crafting_recipe_index];
        var details_right = content_right - padding;
        var details_x = details_left + padding;
        var ingredients_top = panel_top + 50 + 112 + 24 + 40;
        var craft_top = ingredients_top + array_length(recipe.ingredients) * row_pitch + 22;
        var craft_height = 60;
        var craft_hovered = point_in_rectangle(mouse_gui_x, mouse_gui_y, details_x, craft_top,
            details_right, craft_top + craft_height);
        var craft_pressed = craft_hovered && mouse_check_button_pressed(mb_left);

        ui_hover_sound("crafting_craft_button", craft_hovered ? "craft" : "");
        if (craft_pressed) audio_play_sound(snd_interact, 0, false);

        if (keyboard_check_pressed(ord("E")) || craft_pressed)
        {
            if (variable_struct_exists(recipe, "crafting_minigame"))
            {
                if (!weapon_crafting_minigame_start(_skill_key, recipe))
                    crafting_message = "CRAFT FAILED: REQUIREMENTS OR STASH SPACE";
            }
            else if (recipe_craft(_skill_key, recipe))
                crafting_message = "CRAFTED: " + recipe.name;
            else
                crafting_message = "CRAFT FAILED: REQUIREMENTS NOT MET";
        }
    }
    else
    {
        crafting_recipe_index = 0;
        crafting_recipe_scroll = 0;
    }

    if (keyboard_check_pressed(vk_escape))
    {
        audio_play_sound(snd_interact, 0, false);
        hideout_focus = HideoutFocus.SIDEBAR;
        crafting_message = "";
    }
}
