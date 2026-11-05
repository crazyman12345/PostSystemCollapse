function step_hideout()
{
    player_health_update_post_raid_recovery();
    if (crafting_minigame_state.active)
    {
        step_weapon_crafting_minigame();
        return;
    }

    if (onboarding_step_hideout()) return;
    onboarding_update_field_supplies_tip();

    var _trading_overlay_open = (hideout_page == HideoutPage.TRADERS || hideout_page == HideoutPage.MESSAGES)
        && trader_mode == TraderMode.BUY;
    var _inventory_popup_open = hideout_page == HideoutPage.STASH
        && (inventory_context_active || !is_undefined(inventory_inspect_item));
    var _sidebar_hover = -1;
    var _sidebar_mouse_x = device_mouse_x_to_gui(0);
    var _sidebar_mouse_y = device_mouse_y_to_gui(0);
    if (!_trading_overlay_open && !_inventory_popup_open)
    {
        for (var _hover_i = 0; _hover_i < array_length(hideout_menu_items); _hover_i++)
        {
            var _hover_entry = hideout_menu_items[_hover_i];
            var _hover_y = hideout_sidebar_item_top(_hover_i);
            if (_sidebar_mouse_x >= 18 && _sidebar_mouse_x <= 302
            && _sidebar_mouse_y >= _hover_y && _sidebar_mouse_y < _hover_y + 42
            && hideout_entry_is_unlocked(_hover_entry))
            {
                _sidebar_hover = _hover_i;
                break;
            }
        }
    }
    ui_hover_sound("hideout_sidebar", _sidebar_hover == -1 ? "" : string(_sidebar_hover));
    if (!_trading_overlay_open && !_inventory_popup_open && mouse_check_button_pressed(mb_left))
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
            var _conversation_open = trader_mode == TraderMode.CONVERSATION;
            var _clicked_entry = hideout_menu_items[_clicked_index];
            if (_conversation_open && _clicked_entry.key == "messages")
            {
                dialogue_close();
                hideout_menu_index = _clicked_index;
                hideout_page = HideoutPage.MESSAGES;
                hideout_focus = HideoutFocus.CONTENT;
                menu_index = 0;
                audio_play_sound(snd_interact, 0, false);
                return;
            }
            if (_clicked_index != hideout_menu_index || _conversation_open)
            {
                if (_conversation_open) dialogue_close();
                else trader_mode = TraderMode.SELECT;

                if (_clicked_index != hideout_menu_index)
                {
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
                }

                audio_play_sound(snd_interact, 0, false);
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
    if (_entry.bench_key != "") return variable_struct_get(workshop_progress, _entry.bench_key) > 0;
    return false;
}
