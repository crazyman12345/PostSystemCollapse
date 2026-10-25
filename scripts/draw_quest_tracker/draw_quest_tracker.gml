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
    return 10 + (quest_tracker_expanded_remaining > 0 ? 116 : 42);
}

function draw_quest_tracker()
{
    if (!quest_tracker_is_visible()) return;

    var definition = quest_get_definition(tracked_quest_key);
    var progress = quest_get_progress(tracked_quest_key);
    if (is_undefined(definition) || is_undefined(progress)) return;

    var objective_index = quest_tracker_get_objective_index(definition, progress);
    var objective_text = "READY TO TURN IN";
    var progress_text = "";
    if (objective_index >= 0)
    {
        var objective = definition.objectives[objective_index];
        var amount = quest_get_objective_display_progress(definition, progress, objective_index);
        objective_text = objective.text;
        progress_text = string(amount) + "/" + string(objective.amount);
    }

    var panel_right = display_get_gui_width() - 30;
    var panel_left = panel_right - 460;
    var panel_top = 10;
    var expanded = quest_tracker_expanded_remaining > 0;
    var panel_bottom = quest_tracker_get_panel_bottom();

    draw_set_alpha(0.88);
    draw_set_color(c_black);
    draw_rectangle(panel_left, panel_top, panel_right, panel_bottom, false);
    draw_set_alpha(1);
    draw_set_color(c_green);
    draw_rectangle(panel_left, panel_top, panel_right, panel_bottom, true);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    if (expanded)
    {
        draw_set_font(fnt_terminal_tiny);
        draw_set_color(c_green);
        draw_text(panel_left + 12, panel_top + 9, "TRACKED QUEST");
        draw_set_font(fnt_terminal_small);
        draw_set_color(c_lime);
        draw_text(panel_left + 12, panel_top + 34, definition.title);
        draw_set_font(fnt_terminal_tiny);
        draw_set_color(c_green);
        draw_text(panel_left + 12, panel_top + 78, objective_text);
        draw_set_halign(fa_right);
        draw_set_color(c_lime);
        draw_text(panel_right - 12, panel_top + 78, progress_text);
    }
    else
    {
        draw_set_font(fnt_terminal_tiny);
        draw_set_color(c_lime);
        var line = definition.title + " - " + objective_text;
        var progress_width = progress_text == "" ? 0 : string_width(progress_text) + 14;
        var available_width = panel_right - panel_left - 24 - progress_width;
        var line_scale = min(1, available_width / max(1, string_width(line)));
        draw_text_transformed(panel_left + 12, panel_top + 12, line, line_scale, 1, 0);
        draw_set_halign(fa_right);
        draw_text(panel_right - 12, panel_top + 12, progress_text);
    }

    draw_set_alpha(1);
    draw_set_color(c_lime);
    draw_set_font(fnt_terminal);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
