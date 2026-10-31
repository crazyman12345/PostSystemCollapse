function step_hideout_crafting(_skill_key)
{
    var recipes = recipe_get_for_skill(_skill_key);
    var recipe_count = array_length(recipes);

    if (recipe_count > 0)
    {
        var mouse_menu = terminal_menu_mouse_input(crafting_recipe_index, min(crafting_visible_rows, recipe_count - crafting_recipe_scroll), crafting_recipe_scroll, 365, 175, 380, 52);
        crafting_recipe_index = mouse_menu.index;

        if (crafting_recipe_index >= crafting_recipe_scroll + crafting_visible_rows)
            crafting_recipe_scroll = crafting_recipe_index - crafting_visible_rows + 1;

        if (crafting_recipe_index < crafting_recipe_scroll)
            crafting_recipe_scroll = crafting_recipe_index;

        if (keyboard_check_pressed(ord("E")) || mouse_menu.confirm)
        {
            var recipe = recipes[crafting_recipe_index];

            if (recipe_craft(_skill_key, recipe))
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
