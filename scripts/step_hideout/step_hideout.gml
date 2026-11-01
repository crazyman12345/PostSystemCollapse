function step_hideout()
{
    player_health_update_post_raid_recovery();
    if (onboarding_step_hideout()) return;
    onboarding_update_field_supplies_tip();

    var _trader_subscreen_open = (hideout_page == HideoutPage.TRADERS || hideout_page == HideoutPage.MESSAGES)
        && trader_mode != TraderMode.SELECT;
    var _inventory_popup_open = hideout_page == HideoutPage.STASH
        && (inventory_context_active || !is_undefined(inventory_inspect_item));
    if (!_trader_subscreen_open && !_inventory_popup_open && mouse_check_button_pressed(mb_left))
    {
        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);
        var _clicked_index = -1;

        for (var _i = 0; _i < array_length(hideout_menu_items); _i++)
        {
            var _entry = hideout_menu_items[_i];
            var _item_y = hideout_sidebar_item_top(_i);
            if (_mouse_x >= 18 && _mouse_x <= 302 && _mouse_y >= _item_y && _mouse_y < _item_y + 42
            && hideout_entry_is_unlocked(_entry))
            {
                _clicked_index = _i;
                break;
            }
        }

        if (_clicked_index != -1)
        {
            if (_clicked_index != hideout_menu_index)
            {
                if (trader_mode == TraderMode.CONVERSATION) dialogue_close();
                else trader_mode = TraderMode.SELECT;

                hideout_menu_index = _clicked_index;
                var _selected = hideout_menu_items[hideout_menu_index];
                hideout_page = _selected.page;
                hideout_focus = HideoutFocus.CONTENT;

                if (variable_struct_exists(recipe_db, _selected.key))
                {
                    crafting_recipe_index = 0;
                    crafting_recipe_scroll = 0;
                    crafting_message = "";
                }

                scroll_sound();
            }
            return;
        }
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
