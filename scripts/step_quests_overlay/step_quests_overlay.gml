function quest_overlay_refresh()
{
    quest_refresh_states();
    quest_overlay_quests = [];
    var ordered_states = [QuestState.ACTIVE, QuestState.READY_TO_TURN_IN, QuestState.AVAILABLE, QuestState.COMPLETED];
    for (var state_index = 0; state_index < array_length(ordered_states); state_index++)
        for (var quest_index = 0; quest_index < array_length(quest_definitions); quest_index++)
        {
            var definition = quest_definitions[quest_index];
            if (quest_get_progress(definition.key).state == ordered_states[state_index]) array_push(quest_overlay_quests, definition);
        }
    quest_overlay_index = clamp(quest_overlay_index, 0, max(0, array_length(quest_overlay_quests) - 1));
}

function step_quests_overlay()
{
    if (keyboard_check_pressed(vk_escape))
    {
        overlay_close();
        return;
    }

    quest_overlay_refresh();
    var count = array_length(quest_overlay_quests);
    if (count <= 0) return;

    var move = keyboard_check_pressed(ord("S")) + keyboard_check_pressed(vk_down)
        - keyboard_check_pressed(ord("W")) - keyboard_check_pressed(vk_up);
    var gui_mouse_x = device_mouse_x_to_gui(0);
    var gui_mouse_y = device_mouse_y_to_gui(0);
    var panel_left = max(30, (display_get_gui_width() - 1720) * 0.5);
    var list_top = 155;
    var row_height = 52;
    var visible_rows = max(1, floor((display_get_gui_height() - 245) / row_height));
    if (gui_mouse_x >= panel_left + 25 && gui_mouse_x <= panel_left + 570)
        move += mouse_wheel_down() - mouse_wheel_up();

    if (move != 0)
    {
        quest_overlay_index = clamp(quest_overlay_index + sign(move), 0, count - 1);
        scroll_sound();
    }

    var hover_index = -1;
    if (gui_mouse_x >= panel_left + 25 && gui_mouse_x <= panel_left + 570 && gui_mouse_y >= list_top)
    {
        var hover_row = floor((gui_mouse_y - list_top) / row_height);
        if (hover_row >= 0 && hover_row < visible_rows && quest_overlay_scroll + hover_row < count)
            hover_index = quest_overlay_scroll + hover_row;
    }
    if (hover_index != -1 && hover_index != quest_overlay_index)
    {
        quest_overlay_index = hover_index;
        scroll_sound();
    }

    if (quest_overlay_index < quest_overlay_scroll) quest_overlay_scroll = quest_overlay_index;
    else if (quest_overlay_index >= quest_overlay_scroll + visible_rows) quest_overlay_scroll = quest_overlay_index - visible_rows + 1;
    quest_overlay_scroll = clamp(quest_overlay_scroll, 0, max(0, count - visible_rows));

    if (!keyboard_check_pressed(vk_enter) && !(hover_index != -1 && mouse_check_button_pressed(mb_left))) return;
    var selected = quest_overlay_quests[quest_overlay_index];
    var progress = quest_get_progress(selected.key);
    if (progress.state == QuestState.AVAILABLE) quest_accept(selected.key);
    else if (progress.state == QuestState.READY_TO_TURN_IN) quest_turn_in(selected.key);
    else if (progress.state == QuestState.ACTIVE) quest_track(selected.key);
    quest_overlay_refresh();
}
