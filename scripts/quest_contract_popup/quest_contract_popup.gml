function quest_contract_popup_open(_quest_key, _claim, _next_node = "")
{
    if (!variable_instance_exists(id, "quest_contract_popup_state"))
        quest_contract_popup_state = { active: false, quest_key: "", claim: false, selection: 0, next_node: "" };
    var definition = quest_get_definition(_quest_key);
    var progress = quest_get_progress(_quest_key);
    if (is_undefined(definition) || is_undefined(progress)) return false;
    if (_claim && progress.state != QuestState.READY_TO_TURN_IN) return false;
    if (!_claim && progress.state != QuestState.AVAILABLE) return false;

    quest_contract_popup_state.active = true;
    quest_contract_popup_state.quest_key = _quest_key;
    quest_contract_popup_state.claim = _claim;
    quest_contract_popup_state.selection = 0;
    quest_contract_popup_state.next_node = _next_node;
    return true;
}

function quest_contract_popup_close()
{
    if (!variable_instance_exists(id, "quest_contract_popup_state")) return;
    quest_contract_popup_state.active = false;
    quest_contract_popup_state.quest_key = "";
    quest_contract_popup_state.selection = 0;
    quest_contract_popup_state.next_node = "";
}

function quest_contract_popup_rect()
{
    var width = display_get_gui_width() / 3;
    var height = display_get_gui_height() / 2;
    var left = (display_get_gui_width() - width) * 0.5;
    var top = (display_get_gui_height() - height) * 0.5;
    return { left: left, top: top, right: left + width, bottom: top + height };
}

function quest_contract_popup_confirm()
{
    if (quest_contract_popup_state.selection == 1)
    {
        audio_play_sound(snd_interact, 0, false);
        quest_contract_popup_close();
        return;
    }

    var quest_key = quest_contract_popup_state.quest_key;
    var next_node = quest_contract_popup_state.next_node;
    var succeeded = quest_contract_popup_state.claim ? quest_turn_in(quest_key) : quest_accept(quest_key);
    if (!succeeded) return;
    if (!quest_contract_popup_state.claim) audio_play_sound(snd_interact, 0, false);

    if (!quest_contract_popup_state.claim)
    {
        if (quest_key == "test_field_supplies")
            dialogue_set_flag("field_supplies_tutorial_started", true);
        quest_contract_popup_close();
        dialogue_close();
        hideout_page = HideoutPage.MESSAGES;
        hideout_menu_index = 1;
        hideout_focus = HideoutFocus.CONTENT;
        if (quest_key == "test_safe_return") onboarding_update_starting_crate_tip();
        return;
    }

    quest_contract_popup_close();
    if (next_node != "") dialogue_set_node(next_node);
}

function quest_contract_popup_step()
{
    var move = keyboard_check_pressed(vk_right) + keyboard_check_pressed(vk_down)
        - keyboard_check_pressed(vk_left) - keyboard_check_pressed(vk_up);
    if (move != 0)
    {
        quest_contract_popup_state.selection = 1 - quest_contract_popup_state.selection;
        scroll_sound();
    }

    var rect = quest_contract_popup_rect();
    var gap = 14;
    var button_left = rect.left + 28;
    var button_right = rect.right - 28;
    var button_top = rect.bottom - 70;
    var button_width = (button_right - button_left - gap) * 0.5;
    var gui_mouse_x = device_mouse_x_to_gui(0);
    var gui_mouse_y = device_mouse_y_to_gui(0);
    var hover = -1;
    if (point_in_rectangle(gui_mouse_x, gui_mouse_y, button_left, button_top, button_left + button_width, rect.bottom - 24)) hover = 0;
    else if (point_in_rectangle(gui_mouse_x, gui_mouse_y, button_left + button_width + gap, button_top, button_right, rect.bottom - 24)) hover = 1;
    if (hover != -1 && hover != quest_contract_popup_state.selection)
    {
        quest_contract_popup_state.selection = hover;
    }
    ui_hover_sound("quest_contract_buttons", hover == -1 ? "" : string(hover));

    if (keyboard_check_pressed(vk_escape))
    {
        audio_play_sound(snd_interact, 0, false);
        quest_contract_popup_close();
        return;
    }
    if (keyboard_check_pressed(vk_enter) || (hover != -1 && mouse_check_button_pressed(mb_left)))
    {
        quest_contract_popup_confirm();
    }
}
