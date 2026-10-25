function draw_quests_overlay()
{
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var panel_width = min(1720, gui_width - 60);
    var left = (gui_width - panel_width) * 0.5;
    var top = 40;
    var right = left + panel_width;
    var bottom = gui_height - 40;
    var divider = left + 600;

    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_rectangle(left, top, right, bottom, false);
    draw_set_color(c_lime);
    draw_ascii_rectangle(left, top, right, bottom);
    draw_text(left + 30, top + 25, "QUESTS");
    draw_set_color(c_green);
    draw_line(left + 25, top + 75, right - 25, top + 75);
    draw_line(divider, top + 95, divider, bottom - 30);

    var count = array_length(quest_overlay_quests);
    if (count <= 0)
    {
        draw_set_color(c_lime);
        draw_text(left + 35, top + 115, "NO QUESTS AVAILABLE");
        return;
    }

    quest_overlay_index = clamp(quest_overlay_index, 0, count - 1);
    var list_top = 155;
    var row_height = 52;
    var visible_rows = max(1, floor((gui_height - 245) / row_height));
    var last_section = "";
    for (var row = 0; row < visible_rows; row++)
    {
        var index = quest_overlay_scroll + row;
        if (index >= count) break;
        var definition = quest_overlay_quests[index];
        var progress = quest_get_progress(definition.key);
        var section = quest_state_section(progress.state);
        var row_top = list_top + row * row_height;
        var selected = index == quest_overlay_index;

        if (selected)
        {
            draw_set_color(c_dkgray);
            draw_rectangle(left + 22, row_top - 3, divider - 22, row_top + row_height - 5, false);
            draw_set_color(c_lime);
            draw_rectangle(left + 22, row_top - 3, divider - 22, row_top + row_height - 5, true);
        }
        draw_set_font(fnt_terminal_tiny);
        draw_set_color(c_green);
        if (section != last_section) draw_text(left + 34, row_top + 3, section);
        draw_set_font(fnt_terminal_small);
        draw_set_color(selected ? c_lime : c_green);
        var tracked = tracked_quest_key == definition.key ? "> " : "  ";
        draw_text(left + 34, row_top + 23, tracked + definition.title);
        last_section = section;
    }

    var selected_definition = quest_overlay_quests[quest_overlay_index];
    var selected_progress = quest_get_progress(selected_definition.key);
    var detail_left = divider + 35;
    var detail_right = right - 35;
    var trader = trader_get(selected_definition.trader_key);
    draw_set_font(fnt_terminal_medium);
    draw_set_color(c_lime);
    draw_text(detail_left, top + 110, selected_definition.title);
    draw_set_font(fnt_terminal_small);
    draw_set_color(c_green);
    draw_text(detail_left, top + 158, "TRADER: " + string_upper(trader.name));
    var state_text = quest_state_name(selected_progress.state);
    if (selected_progress.state == QuestState.ACTIVE && tracked_quest_key == selected_definition.key) state_text += " - TRACKED";
    draw_text(detail_left, top + 198, state_text);
    draw_set_color(c_lime);
    draw_text_ext(detail_left, top + 245, selected_definition.description, 26, detail_right - detail_left);

    var objective_y = top + 355;
    if (selected_progress.state != QuestState.AVAILABLE)
    {
        draw_set_color(c_green);
        draw_text(detail_left, objective_y, "OBJECTIVES");
        objective_y += 42;
        for (var i = 0; i < array_length(selected_definition.objectives); i++)
        {
            var objective = selected_definition.objectives[i];
            var amount = selected_progress.objectives[i];
            var complete = amount >= objective.amount;
            draw_set_color(complete ? c_lime : c_green);
            draw_text(detail_left + 10, objective_y, (complete ? "[X] " : "[ ] ") + objective.text);
            draw_set_halign(fa_right);
            draw_text(detail_right, objective_y, string(amount) + " / " + string(objective.amount));
            draw_set_halign(fa_left);
            if (objective.requires_extraction && !complete)
            {
                draw_set_font(fnt_terminal_tiny);
                draw_text(detail_left + 42, objective_y + 27, "EXTRACT TO COMPLETE");
                draw_set_font(fnt_terminal_small);
                objective_y += 24;
            }
            objective_y += 48;
        }
    }

    var rewards_y = max(objective_y + 20, bottom - 210);
    draw_set_color(c_green);
    draw_text(detail_left, rewards_y, "REWARDS");
    rewards_y += 40;
    if (selected_definition.rewards.cash > 0)
    {
        draw_set_color(c_lime);
        draw_text(detail_left + 10, rewards_y, "$" + string(selected_definition.rewards.cash));
        rewards_y += 34;
    }
    for (var i = 0; i < array_length(selected_definition.rewards.items); i++)
    {
        var reward = selected_definition.rewards.items[i];
        var item = item_get(reward.item_key);
        draw_set_color(c_lime);
        draw_text(detail_left + 10, rewards_y, string(reward.quantity) + "x " + string_upper(item.name));
        rewards_y += 34;
    }
}

function quest_state_section(_state)
{
    if (_state == QuestState.ACTIVE || _state == QuestState.READY_TO_TURN_IN) return "ACTIVE";
    if (_state == QuestState.AVAILABLE) return "AVAILABLE";
    return "COMPLETED";
}

function quest_state_name(_state)
{
    switch (_state)
    {
        case QuestState.LOCKED: return "LOCKED";
        case QuestState.AVAILABLE: return "AVAILABLE";
        case QuestState.ACTIVE: return "ACTIVE";
        case QuestState.READY_TO_TURN_IN: return "READY TO TURN IN";
        case QuestState.COMPLETED: return "COMPLETED";
    }
    return "UNKNOWN";
}
