function step_trader_conversation()
{
    if (state != GameState.HIDEOUT)
    {
        dialogue_close();
        return;
    }
    if (keyboard_check_pressed(vk_escape))
    {
        audio_play_sound(snd_interact, 0, false);
        dialogue_close();
        return;
    }

    var responses = dialogue_get_visible_responses(dialogue_current_node);
    var count = array_length(responses);
    if (count <= 0) return;
    dialogue_response_index = clamp(dialogue_response_index, 0, count - 1);
    var move = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
    var gui_mouse_x = device_mouse_x_to_gui(0);
    var gui_mouse_y = device_mouse_y_to_gui(0);
    var list_left = 1010;
    var list_top = 555;
    var list_width = 820;
    var row_height = 58;
    var visible_rows = 7;
    if (gui_mouse_x >= list_left && gui_mouse_x <= list_left + list_width && gui_mouse_y >= list_top)
        move += mouse_wheel_down() - mouse_wheel_up();
    if (move != 0)
    {
        dialogue_response_index = clamp(dialogue_response_index + sign(move), 0, count - 1);
        scroll_sound();
    }

    var hover_index = -1;
    if (point_in_rectangle(gui_mouse_x, gui_mouse_y, list_left, list_top, list_left + list_width, list_top + visible_rows * row_height))
    {
        var hover_row = floor((gui_mouse_y - list_top) / row_height);
        if (dialogue_response_scroll + hover_row < count) hover_index = dialogue_response_scroll + hover_row;
    }
    if (hover_index != -1 && hover_index != dialogue_response_index)
    {
        dialogue_response_index = hover_index;
        scroll_sound();
    }
    if (dialogue_response_index < dialogue_response_scroll) dialogue_response_scroll = dialogue_response_index;
    else if (dialogue_response_index >= dialogue_response_scroll + visible_rows)
        dialogue_response_scroll = dialogue_response_index - visible_rows + 1;
    dialogue_response_scroll = clamp(dialogue_response_scroll, 0, max(0, count - visible_rows));

    var numbered_index = -1;
    for (var i = 0; i < min(9, count); i++)
        if (keyboard_check_pressed(ord(string(i + 1)))) numbered_index = i;
    if (numbered_index >= 0) dialogue_response_index = numbered_index;

    if (keyboard_check_pressed(vk_enter) || (hover_index != -1 && mouse_check_button_pressed(mb_left)) || numbered_index >= 0)
    {
        audio_play_sound(snd_interact, 0, false);
        dialogue_select_response(responses[dialogue_response_index]);
    }
}

function step_messages_all()
{
    var trader_keys = onboarding_is_active() ? ["mara"] : trader_get_message_keys();
    var mouse_menu = terminal_menu_mouse_input(menu_index, array_length(trader_keys), 0, 370, 235, 555, 92);
    menu_index = mouse_menu.index;

    if (keyboard_check_pressed(vk_enter) || mouse_menu.confirm)
    {
        if (onboarding_is_active()) onboarding_open_mara_message();
        else dialogue_open(trader_keys[menu_index]);
        return;
    }

    if (keyboard_check_pressed(vk_escape))
    {
        audio_play_sound(snd_interact, 0, false);
        hideout_focus = HideoutFocus.SIDEBAR;
        menu_index = 0;
    }
}
