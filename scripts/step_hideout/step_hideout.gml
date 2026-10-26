function step_hideout()
{
    player_health_update_post_raid_recovery();
    if (onboarding_step_hideout()) return;
    onboarding_update_field_supplies_tip();

    if (trader_mode == TraderMode.BUY)
    {
        step_trader_buy();
        return;
    }

    if (hideout_focus == HideoutFocus.SIDEBAR
    && (mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right)))
    {
        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);
        if (_mouse_x >= 320 && _mouse_x <= display_get_gui_width()
        && _mouse_y >= 1 && _mouse_y <= display_get_gui_height())
        {
            var _selected = hideout_menu_items[hideout_menu_index];
            if (!hideout_entry_is_unlocked(_selected)) return;
            hideout_focus = HideoutFocus.CONTENT;
            if (variable_struct_exists(recipe_db, _selected.key))
            {
                crafting_recipe_index = 0;
                crafting_recipe_scroll = 0;
                crafting_message = "";
            }
            audio_play_sound(snd_interact, 0, false);
            return;
        }
    }

    if (hideout_focus == HideoutFocus.CONTENT
    && (mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right)))
    {
        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);
        if (_mouse_x >= 1 && _mouse_x <= 320 && _mouse_y >= 1 && _mouse_y <= display_get_gui_height())
        {
            hideout_focus = HideoutFocus.SIDEBAR;
            var _item_y = 85;
            for (var _i = 0; _i < array_length(hideout_menu_items); _i++)
            {
                var _entry = hideout_menu_items[_i];
                if (_entry.header != "") _item_y += 50;
                if (_mouse_x >= 25 && _mouse_x <= 295 && _mouse_y >= _item_y && _mouse_y < _item_y + 34
                && hideout_entry_is_unlocked(_entry))
                {
                    hideout_menu_index = _i;
                    hideout_page = _entry.page;
                    break;
                }
                _item_y += 34;
                if (_entry.key == "workshop" || _entry.key == "drugmaking") _item_y += 30;
            }
            scroll_sound();
            return;
        }
    }

    if (hideout_focus == HideoutFocus.SIDEBAR)
    {
        if (keyboard_check_pressed(vk_escape))
        {
            state = GameState.MAIN_MENU;
            menu_index = 0;
            audio_play_sound(snd_interact, 0, false);
            return;
        }

        if (keyboard_check_pressed(ord("W")))
        {
            repeat (array_length(hideout_menu_items))
            {
                hideout_menu_index--;
                if (hideout_menu_index < 0) hideout_menu_index = array_length(hideout_menu_items) - 1;

                var entry = hideout_menu_items[hideout_menu_index];
                if (hideout_entry_is_unlocked(entry))
                    break;
            }
			scroll_sound();
        }

        if (keyboard_check_pressed(ord("S")))
        {
            repeat (array_length(hideout_menu_items))
            {
                hideout_menu_index++;
                if (hideout_menu_index >= array_length(hideout_menu_items)) hideout_menu_index = 0;

                var entry = hideout_menu_items[hideout_menu_index];
                if (hideout_entry_is_unlocked(entry))
                    break;
            }
			scroll_sound();
        }

        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);
        var hover_index = -1;
        var item_y = 85;
        for (var i = 0; i < array_length(hideout_menu_items); i++)
        {
            var hover_entry = hideout_menu_items[i];
            if (hover_entry.header != "") item_y += 50;
            if (_mouse_x >= 25 && _mouse_x <= 295 && _mouse_y >= item_y && _mouse_y < item_y + 34
                && hideout_entry_is_unlocked(hover_entry)) hover_index = i;
            item_y += 34;
            if (hover_entry.key == "workshop" || hover_entry.key == "drugmaking") item_y += 30;
        }

        if (hover_index != -1 && hideout_menu_index != hover_index)
        {
            hideout_menu_index = hover_index;
            scroll_sound();
        }

        var selected = hideout_menu_items[hideout_menu_index];
        hideout_page = selected.page;

        if (keyboard_check_pressed(vk_enter)
        || (hover_index != -1 && (mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right))))
        {
            if (!hideout_entry_is_unlocked(selected)) return;

            hideout_focus = HideoutFocus.CONTENT;

            if (variable_struct_exists(recipe_db, selected.key))
            {
                crafting_recipe_index = 0;
                crafting_recipe_scroll = 0;
                crafting_message = "";
            }
			audio_play_sound(snd_interact,0,false);
        }

        return;
    }

    switch (hideout_page)
    {
        case HideoutPage.TRADERS: step_hideout_traders(); break;
        case HideoutPage.MESSAGES: step_hideout_traders(); break;
        case HideoutPage.STASH: step_hideout_stash(); break;
        case HideoutPage.SKILLS: step_hideout_skills(); break;
        case HideoutPage.SALVAGE: step_hideout_salvage(); break;

        case HideoutPage.GUNMAKING: step_hideout_crafting("gunmaking"); break;
        case HideoutPage.ARMORCRAFTING: step_hideout_crafting("armorcrafting"); break;
        case HideoutPage.DRUG_LAB: step_hideout_crafting("drugmaking"); break;
        case HideoutPage.MEDICAL_CRAFTING: step_hideout_crafting("medical_crafting"); break;

        case HideoutPage.RAIDS: step_hideout_raid(); break;
        case HideoutPage.WORKSHOP: step_workshop(); break;
    }
}

function hideout_entry_is_unlocked(_entry)
{
    if (_entry.key == "messages" || _entry.key == "stash" || _entry.key == "raids") return true;

    var first_quest = quest_get_progress("test_safe_return");
    var first_quest_complete = !is_undefined(first_quest) && first_quest.state == QuestState.COMPLETED;
    if (!first_quest_complete) return false;

    if (_entry.key == "traders" || _entry.key == "workshop") return true;
    if (_entry.key == "skills")
    {
        var workbench_quest = quest_get_progress("test_field_supplies");
        return !is_undefined(workbench_quest) && workbench_quest.state == QuestState.COMPLETED;
    }
    if (_entry.key == "salvaging") return variable_struct_get(workshop_progress, "salvage_bench") > 0;
    return false;
}
