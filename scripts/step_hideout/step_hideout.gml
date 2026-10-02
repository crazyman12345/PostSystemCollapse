function step_hideout()
{
    if (hideout_focus == HideoutFocus.SIDEBAR)
    {
        if (keyboard_check_pressed(ord("W")))
        {
            hideout_menu_index--;
            if (hideout_menu_index < 0) hideout_menu_index = array_length(hideout_menu_items) - 1;
        }

        if (keyboard_check_pressed(ord("S")))
        {
            hideout_menu_index++;
            if (hideout_menu_index >= array_length(hideout_menu_items)) hideout_menu_index = 0;
        }

        var selected = hideout_menu_items[hideout_menu_index];
        hideout_page = selected.page;

        if (keyboard_check_pressed(vk_enter))
        {
            hideout_focus = HideoutFocus.CONTENT;

            if (variable_struct_exists(recipe_db, selected.key))
            {
                crafting_recipe_index = 0;
                crafting_recipe_scroll = 0;
                crafting_message = "";
            }
        }

        return;
    }

    switch (hideout_page)
    {
        case HideoutPage.TRADERS: step_hideout_traders(); break;
        case HideoutPage.STASH: step_hideout_stash(); break;
        case HideoutPage.SALVAGE: step_hideout_salvage(); break;

        case HideoutPage.GUNMAKING: step_hideout_crafting("gunmaking"); break;
        case HideoutPage.ARMORCRAFTING: step_hideout_crafting("armorcrafting"); break;
        case HideoutPage.DRUG_LAB: step_hideout_crafting("drugmaking"); break;
        case HideoutPage.MEDICAL_CRAFTING: step_hideout_crafting("medical_crafting"); break;

        case HideoutPage.RAIDS: step_hideout_raid(); break;
        case HideoutPage.WORKSHOP: step_workshop(); break;
    }
}
