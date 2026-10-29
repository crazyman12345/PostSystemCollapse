function quest_tracker_raid_begin()
{
    quest_tracker_expanded_remaining = 240;
}

function quest_tracker_update()
{
    if (quest_tracker_expanded_remaining > 0)
        quest_tracker_expanded_remaining = max(0, quest_tracker_expanded_remaining - frame_scale);
}

function quest_tracker_is_visible()
{
    if (state != GameState.RAID || tracked_quest_key == "" || overlay_mode != OverlayMode.NONE) return false;
    if (raid.state == RaidState.INACTIVE || raid.state == RaidState.PAUSED
    || raid.state == RaidState.RESULT || raid.state == RaidState.DEATH) return false;
    if (raid_gun_tuning_active) return false;

    var progress = quest_get_progress(tracked_quest_key);
    return !is_undefined(progress)
        && (progress.state == QuestState.ACTIVE || progress.state == QuestState.READY_TO_TURN_IN);
}

function quest_objective_is_raid_relevant(_objective)
{
    if (_objective.type != QuestObjectiveType.EXTRACT_LEVEL) return true;
    return variable_struct_exists(raid, "selected_area")
        && is_struct(raid.selected_area) && _objective.target == raid.selected_area.name;
}

function quest_tracker_get_objective_index(_definition, _progress)
{
    for (var i = 0; i < array_length(_definition.objectives); i++)
        if (_progress.objectives[i] < _definition.objectives[i].amount
        && quest_objective_is_raid_relevant(_definition.objectives[i])) return i;

    for (var i = 0; i < array_length(_definition.objectives); i++)
        if (_progress.objectives[i] < _definition.objectives[i].amount) return i;
    return -1;
}

function quest_tracker_get_panel_bottom()
{
    var definition = quest_get_definition(tracked_quest_key);
    var objective_count = is_undefined(definition) ? 1 : max(1, array_length(definition.objectives));
    return 126 + (max(0, objective_count - 1) * 38);
}

function draw_quest_tracker()
{
    if (!quest_tracker_is_visible()) return;

    var definition = quest_get_definition(tracked_quest_key);
    var progress = quest_get_progress(tracked_quest_key);
    if (is_undefined(definition) || is_undefined(progress)) return;

    var panel_right = display_get_gui_width() - 20;
    var panel_left = panel_right - 520;
    var panel_top = 20;
    var panel_bottom = quest_tracker_get_panel_bottom();
    var header_bottom = panel_top + 36;
    var quest_row_bottom = header_bottom + 70;
    var current_objective_index = quest_tracker_get_objective_index(definition, progress);

    draw_terminal_rectangle(panel_left, panel_top, panel_right, panel_bottom, c_green, 0.88);
    draw_terminal_rectangle(panel_left, panel_top, panel_right, header_bottom, c_green, 0.55);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_font(fnt_terminal_small);
    draw_set_color(c_lime);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text((panel_left + panel_right) * 0.5, panel_top + 18, "QUESTS (1)");

    var icon_left = panel_left + 12;
    var icon_top = header_bottom + 13;
    var icon_size = 44;
    draw_terminal_rectangle(icon_left, icon_top, icon_left + icon_size, icon_top + icon_size, c_green, 0.65);
    draw_set_font(fnt_terminal);
    draw_set_color(c_lime);
    draw_text(icon_left + (icon_size * 0.5), icon_top + (icon_size * 0.5), "?");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_terminal_small);
    draw_set_color(c_lime);
    draw_text(icon_left + icon_size + 14, header_bottom + 10, string_upper(definition.title));

    if (array_length(definition.objectives) > 0)
    {
        var first_objective = definition.objectives[0];
        var first_amount = quest_get_objective_display_progress(definition, progress, 0);
        var first_complete = progress.objectives[0] >= first_objective.amount;
        var first_text = string_lower(first_objective.text);
        first_text = string_upper(string_copy(first_text, 1, 1)) + string_delete(first_text, 1, 1);

        draw_set_font(fnt_terminal_tiny);
        draw_set_color(first_complete ? c_gray : c_white);
        draw_text(icon_left + icon_size + 14, header_bottom + 39, first_text);
        draw_set_halign(fa_right);
        draw_set_color(first_complete ? c_gray : c_lime);
        draw_text(panel_right - 14, header_bottom + 39, string(first_amount) + " / " + string(first_objective.amount));
    }
    else
    {
        draw_set_font(fnt_terminal_tiny);
        draw_set_color(c_lime);
        draw_text(icon_left + icon_size + 14, header_bottom + 39, "Ready to turn in");
    }

    for (var i = 1; i < array_length(definition.objectives); i++)
    {
        var row_top = quest_row_bottom + ((i - 1) * 38);
        var objective = definition.objectives[i];
        var amount = quest_get_objective_display_progress(definition, progress, i);
        var complete = progress.objectives[i] >= objective.amount;
        var objective_text = string_lower(objective.text);
        objective_text = string_upper(string_copy(objective_text, 1, 1)) + string_delete(objective_text, 1, 1);

        draw_set_alpha(0.45);
        draw_set_color(c_green);
        draw_line(panel_left + 6, row_top, panel_right - 6, row_top);
        draw_set_alpha(1);

        var box_left = panel_left + 18;
        var box_top = row_top + 9;
        draw_terminal_rectangle(box_left, box_top, box_left + 20, box_top + 20, complete ? c_green : c_dkgray, 0.55);
        if (complete)
        {
            draw_set_font(fnt_terminal_tiny);
            draw_set_color(c_green);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(box_left + 10, box_top + 10, "X");
        }

        draw_set_font(fnt_terminal_tiny);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(complete ? c_gray : (i == current_objective_index ? c_white : c_gray));
        draw_text(panel_left + 50, row_top + 11, objective_text);
        draw_set_halign(fa_right);
        draw_set_color(complete ? c_gray : (i == current_objective_index ? c_lime : c_gray));
        draw_text(panel_right - 14, row_top + 11, string(amount) + " / " + string(objective.amount));
    }

    draw_set_alpha(1);
    draw_set_color(c_lime);
    draw_set_font(fnt_terminal);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
