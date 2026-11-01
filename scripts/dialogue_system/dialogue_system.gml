function dialogue_make_response(_text, _target = "", _condition = undefined, _action = undefined)
{
    return { text: _text, target: _target, condition: _condition, action: _action };
}

function dialogue_register_node(_id, _speaker, _message, _responses)
{
    variable_struct_set(global.dialogue_nodes, _id, {
        id: _id,
        speaker: _speaker,
        message: _message,
        responses: _responses
    });
}

function dialogue_has_trader(_trader_key)
{
    return variable_struct_exists(global.dialogue_roots, _trader_key);
}

function dialogue_get_flag(_key)
{
    if (!variable_struct_exists(dialogue_flags, _key)) return false;
    return variable_struct_get(dialogue_flags, _key);
}

function dialogue_set_flag(_key, _value)
{
    if (dialogue_get_flag(_key) == _value) return false;
    variable_struct_set(dialogue_flags, _key, _value);
    save_mark_dirty();
    return true;
}

function dialogue_trader_has_ready_quest(_trader_key)
{
    var trader = trader_get(_trader_key);
    if (is_undefined(trader)) return false;
    for (var i = 0; i < array_length(quest_definitions); i++)
    {
        var definition = quest_definitions[i];
        var progress = quest_get_progress(definition.key);
        if (definition.trader_key == trader.trader_key && progress.state == QuestState.READY_TO_TURN_IN) return true;
    }
    return false;
}

function dialogue_trader_has_available_quest(_trader_key)
{
    var trader = trader_get(_trader_key);
    if (is_undefined(trader)) return false;
    for (var i = 0; i < array_length(quest_definitions); i++)
    {
        var definition = quest_definitions[i];
        var progress = quest_get_progress(definition.key);
        if (definition.trader_key == trader.trader_key && progress.state == QuestState.AVAILABLE) return true;
    }
    return false;
}

function dialogue_has_ready_quest()
{
    for (var i = 0; i < array_length(quest_definitions); i++)
    {
        var progress = quest_get_progress(quest_definitions[i].key);
        if (!is_undefined(progress) && progress.state == QuestState.READY_TO_TURN_IN) return true;
    }
    return false;
}

function dialogue_condition_met(_condition)
{
    if (is_undefined(_condition)) return true;
    if (is_array(_condition))
    {
        for (var i = 0; i < array_length(_condition); i++)
            if (!dialogue_condition_met(_condition[i])) return false;
        return true;
    }
    if (!is_struct(_condition)) return false;

    var expected = variable_struct_exists(_condition, "value") ? _condition.value : true;
    var result = false;
    switch (_condition.type)
    {
        case "flag":
        case "boss_defeated": result = progress_get_flag(_condition.key); break;
        case "dialogue_flag": result = dialogue_get_flag(_condition.key); break;
        case "quest_available":
            var available = quest_get_progress(_condition.key);
            result = !is_undefined(available) && available.state == QuestState.AVAILABLE;
            break;
        case "quest_active":
            var active = quest_get_progress(_condition.key);
            result = !is_undefined(active) && (active.state == QuestState.ACTIVE || active.state == QuestState.READY_TO_TURN_IN);
            break;
        case "quest_completed":
            var completed = quest_get_progress(_condition.key);
            result = !is_undefined(completed) && completed.state == QuestState.COMPLETED;
            break;
        case "trader_quest_ready": result = dialogue_trader_has_ready_quest(_condition.key); break;
        case "level_unlocked": result = global.progress.danger_level >= _condition.level; break;
        case "danger_at_least": result = global.progress.danger_level >= _condition.level; break;
    }
    return result == expected;
}

function dialogue_get_visible_responses(_node)
{
    var result = [];
    if (is_undefined(_node)) return result;
    for (var i = 0; i < array_length(_node.responses); i++)
        if (dialogue_condition_met(_node.responses[i].condition)) array_push(result, _node.responses[i]);
    return result;
}

function dialogue_add_history(_speaker, _message)
{
    array_push(dialogue_history, { speaker: _speaker, message: _message });
    if (array_length(dialogue_history) > 8) array_delete(dialogue_history, 0, 1);
}

function dialogue_set_node(_node_id)
{
    var node = dialogue_resolve_node(_node_id);
    if (is_undefined(node)) return false;
    dialogue_current_node = node;
    dialogue_response_index = 0;
    dialogue_response_scroll = 0;
    dialogue_add_history(node.speaker, node.message);
    return true;
}

function dialogue_open(_trader_key)
{
    if (state != GameState.HIDEOUT || !dialogue_has_trader(_trader_key)) return false;
    current_trader_key = _trader_key;
    trader_mode = TraderMode.CONVERSATION;
    dialogue_history = [];
    var first_meeting = !dialogue_get_flag("met_" + _trader_key);
    var root = variable_struct_get(global.dialogue_roots, _trader_key);
    dialogue_set_node(first_meeting ? root + "_greeting" : root);
    if (first_meeting) dialogue_set_flag("met_" + _trader_key, true);
    return true;
}

function dialogue_close()
{
    dialogue_set_flag("conversation_" + current_trader_key + "_complete", true);
    dialogue_current_node = undefined;
    dialogue_history = [];
    trader_mode = TraderMode.SELECT;
    menu_index = 0;
}

function dialogue_run_action(_action)
{
    if (is_undefined(_action)) return true;
    if (is_array(_action))
    {
        for (var i = 0; i < array_length(_action); i++)
            if (!dialogue_run_action(_action[i])) return false;
        return true;
    }
    switch (_action.type)
    {
        case "accept_quest": return quest_accept(_action.key);
        case "turn_in_quest": return quest_turn_in(_action.key);
        case "set_dialogue_flag": return dialogue_set_flag(_action.key, _action.value);
        case "tutorial":
            tutorial_callout_show(
                _action.message,
                _action.target_x,
                _action.target_y,
                _action.box_x,
                _action.box_y,
                _action.box_width,
                _action.box_height
            );
            return true;
        case "trade":
            if (!trader_is_shop_unlocked(current_trader_key)) return false;
            trader_mode = TraderMode.BUY;
            trader_stock_layout = trader_stock_grid_build(current_trader_key, 11);
            trader_stock_scroll_row = 0;
            trader_selected_stock_index = -1;
            trader_hovered_stock_index = -1;
            trader_purchase_quantity_text = "1";
            return true;
        case "end": dialogue_close(); return true;
    }
    return true;
}

function dialogue_select_response(_response)
{
    if (is_undefined(_response)) return;
    dialogue_add_history("YOU", _response.text);
    var action_succeeded = dialogue_run_action(_response.action);
    if (trader_mode != TraderMode.CONVERSATION) return;
    if (action_succeeded && _response.target != "") dialogue_set_node(_response.target);
}

function dialogue_resolve_node(_node_id)
{
    if (variable_struct_exists(global.dialogue_nodes, _node_id)) return variable_struct_get(global.dialogue_nodes, _node_id);
    if (string_pos("available:", _node_id) == 1) return dialogue_build_available_node(string_delete(_node_id, 1, 10));
    if (string_pos("offer:", _node_id) == 1) return dialogue_build_offer_node(string_delete(_node_id, 1, 6), false);
    if (string_pos("details:", _node_id) == 1) return dialogue_build_offer_node(string_delete(_node_id, 1, 8), true);
    if (string_pos("active:", _node_id) == 1) return dialogue_build_active_node(string_delete(_node_id, 1, 7));
    if (string_pos("job:", _node_id) == 1) return dialogue_build_job_node(string_delete(_node_id, 1, 4));
    if (string_pos("claim:", _node_id) == 1) return dialogue_build_claim_node(string_delete(_node_id, 1, 6));
    return undefined;
}

function dialogue_build_claim_node(_trader_key)
{
    var trader = trader_get(_trader_key);
    if (is_undefined(trader)) return undefined;
    for (var i = 0; i < array_length(quest_definitions); i++)
    {
        var definition = quest_definitions[i];
        var progress = quest_get_progress(definition.key);
        if (definition.trader_key == trader.trader_key && progress.state == QuestState.READY_TO_TURN_IN)
        {
            if (variable_struct_exists(definition, "completion_node"))
                return dialogue_resolve_node(definition.completion_node);
            var message = definition.key == "test_field_supplies"
                ? "Useful. The other traders are willing to speak with you now."
                : "Thanks. Here is your reward.";
            message += "\n\nREWARD: $" + string(definition.rewards.cash);
            for (var reward_index = 0; reward_index < array_length(definition.rewards.items); reward_index++)
            {
                var reward = definition.rewards.items[reward_index];
                var item = item_get(reward.item_key);
                message += " + " + string(reward.quantity) + "x " + string_upper(item.name);
            }
            if (definition.key == "test_field_supplies") message += "\nTRADER ACCESS";
            return { id: "claim:" + _trader_key, speaker: trader.name, message: message, responses: [
                dialogue_make_response("Claim reward.", variable_struct_get(global.dialogue_roots, _trader_key), undefined,
                    { type: "turn_in_quest", key: definition.key })
            ] };
        }
    }
    return undefined;
}

function dialogue_build_available_node(_trader_key)
{
    quest_refresh_states();
    var trader = trader_get(_trader_key);
    var responses = [];
    for (var i = 0; i < array_length(quest_definitions); i++)
    {
        var definition = quest_definitions[i];
        var progress = quest_get_progress(definition.key);
        if (definition.trader_key == trader.trader_key && progress.state == QuestState.AVAILABLE)
        {
            var offer_target = variable_struct_exists(definition, "offer_node") ? definition.offer_node : "offer:" + definition.key;
            array_push(responses, dialogue_make_response(definition.title, offer_target));
        }
    }
    var message = array_length(responses) > 0 ? "I have work available. Which contract do you want to discuss?" : "Nothing new for you right now.";
    array_push(responses, dialogue_make_response("Back.", variable_struct_get(global.dialogue_roots, _trader_key)));
    return { id: "available:" + _trader_key, speaker: trader.name, message: message, responses: responses };
}

function dialogue_build_offer_node(_quest_key, _details)
{
    var definition = quest_get_definition(_quest_key);
    if (is_undefined(definition)) return undefined;
    var trader = trader_get(current_trader_key);
    var message = _details ? dialogue_quest_description(definition, quest_get_progress(_quest_key), false)
        : definition.title + ". Interested?";
    var responses = [];
    if (!_details)
        array_push(responses, dialogue_make_response("Tell me the details.", "details:" + _quest_key));
    else if (quest_get_progress(_quest_key).state == QuestState.AVAILABLE)
        array_push(responses, dialogue_make_response("I'll take the job.", variable_struct_get(global.dialogue_roots, current_trader_key), undefined,
            { type: "accept_quest", key: _quest_key }));
    array_push(responses, dialogue_make_response("Not now.", "available:" + current_trader_key));
    array_push(responses, dialogue_make_response("Back.", variable_struct_get(global.dialogue_roots, current_trader_key)));
    return { id: (_details ? "details:" : "offer:") + _quest_key, speaker: trader.name, message: message, responses: responses };
}

function dialogue_build_active_node(_trader_key)
{
    var trader = trader_get(_trader_key);
    var responses = [];
    for (var i = 0; i < array_length(quest_definitions); i++)
    {
        var definition = quest_definitions[i];
        var progress = quest_get_progress(definition.key);
        if (definition.trader_key == trader.trader_key
        && (progress.state == QuestState.ACTIVE || progress.state == QuestState.READY_TO_TURN_IN))
            array_push(responses, dialogue_make_response(definition.title, "job:" + definition.key));
    }
    var message = array_length(responses) > 0 ? "Let's talk about your current work." : "You don't have an active job from me.";
    array_push(responses, dialogue_make_response("Back.", variable_struct_get(global.dialogue_roots, _trader_key)));
    return { id: "active:" + _trader_key, speaker: trader.name, message: message, responses: responses };
}

function dialogue_build_job_node(_quest_key)
{
    var definition = quest_get_definition(_quest_key);
    if (is_undefined(definition)) return undefined;
    var progress = quest_get_progress(_quest_key);
    var trader = trader_get(current_trader_key);
    var responses = [];
    if (progress.state == QuestState.READY_TO_TURN_IN)
    {
        var completion_target = variable_struct_exists(definition, "completion_node")
            ? definition.completion_node : "claim:" + current_trader_key;
        array_push(responses, dialogue_make_response("The job is done.", completion_target));
    }
    array_push(responses, dialogue_make_response("Back to my jobs.", "active:" + current_trader_key));
    array_push(responses, dialogue_make_response("Back.", variable_struct_get(global.dialogue_roots, current_trader_key)));
    return { id: "job:" + _quest_key, speaker: trader.name,
        message: variable_struct_exists(definition, "active_message") ? definition.active_message
            + "\n\n" + dialogue_quest_description(definition, progress, true)
            : dialogue_quest_description(definition, progress, true), responses: responses };
}

function dialogue_quest_description(_definition, _progress, _show_progress)
{
    var text = _definition.description + "\n\nOBJECTIVES:";
    for (var i = 0; i < array_length(_definition.objectives); i++)
    {
        var objective = _definition.objectives[i];
        text += "\n- " + objective.text;
        if (_show_progress) text += " " + string(_progress.objectives[i]) + "/" + string(objective.amount);
    }
    text += "\n\nREWARD: $" + string(_definition.rewards.cash);
    for (var i = 0; i < array_length(_definition.rewards.items); i++)
    {
        var reward = _definition.rewards.items[i];
        var item = item_get(reward.item_key);
        text += " + " + string(reward.quantity) + "x " + string_upper(item.name);
    }
    return text;
}

function dialogue_save_data()
{
    var saved_flags = {};
    var keys = variable_struct_get_names(dialogue_flags);
    for (var i = 0; i < array_length(keys); i++)
        variable_struct_set(saved_flags, keys[i], variable_struct_get(dialogue_flags, keys[i]));
    return { flags: saved_flags };
}

function dialogue_load_data(_data)
{
    var saved_flags = save_value(_data, "flags", {});
    if (!is_struct(saved_flags)) return;
    var keys = variable_struct_get_names(saved_flags);
    for (var i = 0; i < array_length(keys); i++)
        variable_struct_set(dialogue_flags, keys[i], variable_struct_get(saved_flags, keys[i]));
}
