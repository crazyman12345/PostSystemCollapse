function quest_get_definition(_quest_key)
{
    for (var i = 0; i < array_length(quest_definitions); i++)
        if (quest_definitions[i].key == _quest_key) return quest_definitions[i];
    return undefined;
}

function quest_get_progress(_quest_key)
{
    if (!variable_struct_exists(quest_progress, _quest_key)) return undefined;
    return variable_struct_get(quest_progress, _quest_key);
}

function quest_prerequisites_complete(_definition)
{
    if (is_undefined(trader_get(_definition.trader_key))) return false;
    for (var i = 0; i < array_length(_definition.prerequisites); i++)
    {
        var prerequisite = quest_get_progress(_definition.prerequisites[i]);
        if (is_undefined(prerequisite) || prerequisite.state != QuestState.COMPLETED) return false;
    }
    return true;
}

function quest_refresh_states()
{
    for (var i = 0; i < array_length(quest_definitions); i++)
    {
        var definition = quest_definitions[i];
        var progress = quest_get_progress(definition.key);
        if (progress.state == QuestState.LOCKED && quest_prerequisites_complete(definition))
            progress.state = QuestState.AVAILABLE;
    }
}

function quest_accept(_quest_key)
{
    var progress = quest_get_progress(_quest_key);
    if (is_undefined(progress) || progress.state != QuestState.AVAILABLE) return false;
    var definition = quest_get_definition(_quest_key);
    if (variable_struct_exists(definition, "start_items"))
    {
        for (var i = 0; i < array_length(definition.start_items); i++)
        {
            var supplied_item = definition.start_items[i];
            if (!stash_can_add(supplied_item.item_key, supplied_item.quantity)) return false;
        }
        for (var i = 0; i < array_length(definition.start_items); i++)
        {
            var supplied_item = definition.start_items[i];
            stash_add(supplied_item.item_key, supplied_item.quantity);
        }
    }
    progress.state = QuestState.ACTIVE;
    if (tracked_quest_key == "") tracked_quest_key = _quest_key;
    quest_notification_add("QUEST ACCEPTED", definition.title);
    save_mark_dirty();
    return true;
}

function quest_track(_quest_key)
{
    var progress = quest_get_progress(_quest_key);
    if (is_undefined(progress) || (progress.state != QuestState.ACTIVE && progress.state != QuestState.READY_TO_TURN_IN)) return false;
    tracked_quest_key = tracked_quest_key == _quest_key ? "" : _quest_key;
    save_mark_dirty();
    return true;
}

function quest_event(_objective_type, _target, _amount = 1)
{
    if (_amount <= 0) return;
    if (_objective_type == QuestObjectiveType.COLLECT_ITEM)
    {
        var raid_collected = variable_struct_exists(quest_raid_collected, _target)
            ? variable_struct_get(quest_raid_collected, _target) : 0;
        variable_struct_set(quest_raid_collected, _target, raid_collected + _amount);
    }

    for (var quest_index = 0; quest_index < array_length(quest_definitions); quest_index++)
    {
        var definition = quest_definitions[quest_index];
        var progress = quest_get_progress(definition.key);
        if (progress.state != QuestState.ACTIVE) continue;

        for (var objective_index = 0; objective_index < array_length(definition.objectives); objective_index++)
        {
            var objective = definition.objectives[objective_index];
            if (_objective_type == QuestObjectiveType.COLLECT_ITEM
            && objective.type == QuestObjectiveType.EXTRACT_WITH_ITEM
            && objective.target == _target
            && progress.objectives[objective_index] < objective.amount)
            {
                quest_notification_add("ITEM ACQUIRED", "EXTRACT TO COMPLETE",
                    "extract:" + definition.key + ":" + string(objective_index));
            }
            if (objective.type != _objective_type || objective.target != _target) continue;
            if (objective.requires_extraction)
            {
                var pending_key = definition.key + ":" + string(objective_index);
                var pending = variable_struct_exists(quest_raid_pending, pending_key)
                    ? variable_struct_get(quest_raid_pending, pending_key) : 0;
                variable_struct_set(quest_raid_pending, pending_key, pending + _amount);
                continue;
            }
            quest_add_objective_progress(definition, progress, objective_index, _amount);
        }
        quest_update_ready_state(definition, progress);
    }
}

function quest_add_objective_progress(_definition, _progress, _objective_index, _amount)
{
    var objective = _definition.objectives[_objective_index];
    var previous = _progress.objectives[_objective_index];
    var current = min(objective.amount, previous + _amount);
    if (current <= previous) return false;
    _progress.objectives[_objective_index] = current;
    var complete = current >= objective.amount;
    var title = complete ? "OBJECTIVE COMPLETE" : "OBJECTIVE UPDATED";
    var message = objective.text + " " + string(current) + "/" + string(objective.amount);
    quest_notification_add(title, message, "objective:" + _definition.key + ":" + string(_objective_index));
    save_mark_dirty();
    return true;
}

function quest_update_ready_state(_definition, _progress)
{
    if (_progress.state != QuestState.ACTIVE) return;
    for (var i = 0; i < array_length(_definition.objectives); i++)
        if (_progress.objectives[i] < _definition.objectives[i].amount) return;
    _progress.state = QuestState.READY_TO_TURN_IN;
    quest_notification_add("QUEST COMPLETE", _definition.title, "quest:" + _definition.key);
    save_mark_dirty();
}

function quest_raid_begin()
{
    quest_raid_collected = {};
    quest_raid_pending = {};
    quest_tracker_raid_begin();
}

function quest_get_objective_display_progress(_definition, _progress, _objective_index)
{
    var objective = _definition.objectives[_objective_index];
    var current = _progress.objectives[_objective_index];
    if (state != GameState.RAID || !objective.requires_extraction) return current;

    if (objective.type == QuestObjectiveType.EXTRACT_WITH_ITEM)
    {
        var collected = variable_struct_exists(quest_raid_collected, objective.target)
            ? variable_struct_get(quest_raid_collected, objective.target) : 0;
        return min(objective.amount, current + min(collected, quest_carried_item_quantity(objective.target)));
    }

    var pending_key = _definition.key + ":" + string(_objective_index);
    if (variable_struct_exists(quest_raid_pending, pending_key))
        current = min(objective.amount, current + variable_struct_get(quest_raid_pending, pending_key));
    return current;
}

function quest_extraction_complete(_level_name)
{
    for (var quest_index = 0; quest_index < array_length(quest_definitions); quest_index++)
    {
        var definition = quest_definitions[quest_index];
        var progress = quest_get_progress(definition.key);
        if (progress.state != QuestState.ACTIVE) continue;

        for (var objective_index = 0; objective_index < array_length(definition.objectives); objective_index++)
        {
            var objective = definition.objectives[objective_index];
            var amount = 0;
            if (objective.type == QuestObjectiveType.EXTRACT_LEVEL && objective.target == _level_name) amount = 1;
            else if (objective.type == QuestObjectiveType.EXTRACT_WITH_ITEM)
            {
                var collected = variable_struct_exists(quest_raid_collected, objective.target)
                    ? variable_struct_get(quest_raid_collected, objective.target) : 0;
                amount = min(collected, quest_carried_item_quantity(objective.target));
            }
            else if (objective.requires_extraction)
            {
                var pending_key = definition.key + ":" + string(objective_index);
                if (variable_struct_exists(quest_raid_pending, pending_key)) amount = variable_struct_get(quest_raid_pending, pending_key);
            }
            if (amount > 0) quest_add_objective_progress(definition, progress, objective_index, amount);
        }
        quest_update_ready_state(definition, progress);
    }
    quest_raid_begin();
}

function quest_carried_item_quantity(_item_key)
{
    var total = 0;
    var containers = [stash.backpack, stash.pockets, stash.secure_container];
    for (var container_index = 0; container_index < array_length(containers); container_index++)
    {
        var items = containers[container_index].items;
        for (var i = 0; i < array_length(items); i++)
            if (items[i].item_key == _item_key) total += items[i].quantity;
    }
    return total;
}

function quest_turn_in(_quest_key)
{
    var definition = quest_get_definition(_quest_key);
    var progress = quest_get_progress(_quest_key);
    if (is_undefined(definition) || is_undefined(progress) || progress.state != QuestState.READY_TO_TURN_IN || progress.reward_claimed) return false;

    for (var i = 0; i < array_length(definition.rewards.items); i++)
    {
        var reward_item = definition.rewards.items[i];
        if (!stash_can_add(reward_item.item_key, reward_item.quantity)) return false;
    }
    if (definition.rewards.cash > 0 && !stash_can_add("cash", definition.rewards.cash)) return false;

    progress.reward_claimed = true;
    for (var i = 0; i < array_length(definition.rewards.items); i++)
    {
        var reward_item = definition.rewards.items[i];
        stash_add(reward_item.item_key, reward_item.quantity);
    }
    if (definition.rewards.cash > 0) stash_add("cash", definition.rewards.cash);
    for (var i = 0; i < array_length(definition.rewards.flags); i++) progress_set_flag(definition.rewards.flags[i], true);

    progress.state = QuestState.COMPLETED;
    if (tracked_quest_key == _quest_key) tracked_quest_key = "";
    quest_notification_add("QUEST COMPLETED", definition.title);
    quest_refresh_states();
    save_mark_dirty();
    return true;
}

function quest_save_data()
{
    var saved_progress = {};
    for (var i = 0; i < array_length(quest_definitions); i++)
    {
        var definition = quest_definitions[i];
        var progress = quest_get_progress(definition.key);
        variable_struct_set(saved_progress, definition.key, {
            state: progress.state,
            objectives: array_concat(progress.objectives, []),
            reward_claimed: progress.reward_claimed
        });
    }
    return { tracked: tracked_quest_key, progress: saved_progress };
}

function quest_load_data(_data)
{
    if (!is_struct(_data))
    {
        quest_refresh_states();
        return;
    }
    var saved_progress = save_value(_data, "progress", {});
    for (var i = 0; i < array_length(quest_definitions); i++)
    {
        var definition = quest_definitions[i];
        if (!is_struct(saved_progress) || !variable_struct_exists(saved_progress, definition.key)) continue;
        var saved = variable_struct_get(saved_progress, definition.key);
        if (!is_struct(saved)) continue;
        var progress = quest_get_progress(definition.key);
        var state = floor(save_number(saved, "state", QuestState.LOCKED));
        progress.state = clamp(state, QuestState.LOCKED, QuestState.COMPLETED);
        progress.reward_claimed = save_value(saved, "reward_claimed", false) == true;
        var objectives = save_value(saved, "objectives", []);
        if (is_array(objectives))
            for (var j = 0; j < min(array_length(objectives), array_length(progress.objectives)); j++)
                if (is_real(objectives[j])) progress.objectives[j] = clamp(floor(objectives[j]), 0, definition.objectives[j].amount);
    }
    tracked_quest_key = save_value(_data, "tracked", "");
    var tracked = quest_get_progress(tracked_quest_key);
    if (is_undefined(tracked) || (tracked.state != QuestState.ACTIVE && tracked.state != QuestState.READY_TO_TURN_IN)) tracked_quest_key = "";
    quest_refresh_states();
}
