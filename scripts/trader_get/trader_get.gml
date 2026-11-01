function trader_get(_trader_key)
{
    if (!variable_struct_exists(global.traders, _trader_key))
    {
        var registry_keys = variable_struct_get_names(global.traders);
        for (var i = 0; i < array_length(registry_keys); i++)
        {
            var trader = variable_struct_get(global.traders, registry_keys[i]);
            if (trader.trader_key == _trader_key) return trader;
        }
        show_debug_message(
            "ERROR: Unknown trader: "
            + _trader_key
        );

        return undefined;
    }

    return variable_struct_get(
        global.traders,
        _trader_key
    );
}

function trader_is_unlocked(_trader_key)
{
    if (_trader_key == "admin") return global.admin_trader_enabled;
    if (_trader_key == "ghost") return true;
    if (_trader_key == "mara" || _trader_key == "sawbones" || _trader_key == "iron" || _trader_key == "bastion")
    {
        var field_supplies_progress = quest_get_progress("test_field_supplies");
        return !is_undefined(field_supplies_progress) && field_supplies_progress.state == QuestState.COMPLETED;
    }
    return false;
}

function trader_is_shop_unlocked(_trader_key)
{
    if (_trader_key == "admin") return global.admin_trader_enabled;
    var _field_supplies_progress = quest_get_progress("test_field_supplies");
    return !is_undefined(_field_supplies_progress) && _field_supplies_progress.state == QuestState.COMPLETED;
}

function trader_get_unlocked_keys()
{
    var keys = [];
    var ordered_keys = ["ghost", "mara", "sawbones", "iron", "bastion"];
    for (var i = 0; i < array_length(ordered_keys); i++)
        if (trader_is_unlocked(ordered_keys[i])) array_push(keys, ordered_keys[i]);
    if (global.admin_trader_enabled) array_push(keys, "admin");
    return keys;
}

function trader_get_message_keys()
{
    var keys = trader_get_unlocked_keys();
    if (array_length(keys) == 0) array_push(keys, "ghost");
    return keys;
}
