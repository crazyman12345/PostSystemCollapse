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

function trader_get_reputation(_trader_key)
{
    var _trader = trader_get(_trader_key);
    if (is_undefined(_trader) || _trader_key == "admin") return 0;

    var _reputation = 10;
    if (progress_get_flag("prototype_boss_dead")) _reputation += 5;

    for (var _i = 0; _i < array_length(quest_definitions); _i++)
    {
        var _definition = quest_definitions[_i];
        if (_definition.trader_key != _trader.trader_key) continue;
        var _progress = quest_get_progress(_definition.key);
        if (is_undefined(_progress) || _progress.state != QuestState.COMPLETED) continue;
        _reputation += variable_struct_exists(_definition, "reputation") ? _definition.reputation : 5;
    }
    return _reputation;
}

function trader_get_level(_trader_key)
{
    if (_trader_key == "admin") return 10;
    return max(1, floor(trader_get_reputation(_trader_key) / 10));
}

function trader_get_reputation_marker(_reputation)
{
    if (_reputation >= 100) return "LEGENDARY";
    if (_reputation >= 90) return "EXALTED";
    if (_reputation >= 80) return "REVERED";
    if (_reputation >= 70) return "HONORED";
    if (_reputation >= 60) return "RESPECTED";
    if (_reputation >= 50) return "TRUSTED";
    if (_reputation >= 40) return "TRUSTWORTHY";
    if (_reputation >= 30) return "FRIENDLY";
    if (_reputation >= 20) return "NEUTRAL";
    return "UNTRUSTWORTHY";
}

function trader_stock_entry_is_unlocked(_trader_key, _stock_entry)
{
    if (_trader_key == "admin") return true;
    var _definition = item_get(_stock_entry.item_key);
    if (is_undefined(_definition)) return false;
    var _tier = variable_struct_exists(_stock_entry, "item_instance")
        && variable_struct_exists(_stock_entry.item_instance, "tier")
        ? _stock_entry.item_instance.tier
        : (variable_struct_exists(_definition, "tier") ? _definition.tier : 1);
    return _tier <= trader_get_level(_trader_key);
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
