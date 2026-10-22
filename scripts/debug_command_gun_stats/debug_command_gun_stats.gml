function debug_command_gun_stats()
{
    var _item_keys = variable_struct_get_names(global.items);

    for (var i = 0; i < array_length(_item_keys); i++)
    {
        var _item = item_get(_item_keys[i]);
        if (!is_struct(_item) || _item.category != ItemCategory.WEAPON) continue;

        var _damage = variable_struct_exists(_item, "damage_min") && variable_struct_exists(_item, "damage_max")
            ? string(_item.damage_min) + " - " + string(_item.damage_max)
            : "-";
        var _fire_rate = variable_struct_exists(_item, "fire_rate") ? string(_item.fire_rate) : "-";
        var _reload = variable_struct_exists(_item, "reload_time") ? string(_item.reload_time) : "-";
        var _magazine = variable_struct_exists(_item, "mag_size") ? string(_item.mag_size) : "-";
        var _accuracy = variable_struct_exists(_item, "accuracy") ? string(_item.accuracy) : "-";
        var _handling = variable_struct_exists(_item, "handling") ? string(_item.handling) : "-";

        show_debug_message(
            "Name: " + _item.name + "\n"
            + "Damage: " + _damage + "\n"
            + "Fire rate: " + _fire_rate + "\n"
            + "Reload: " + _reload + "\n"
            + "Magazine: " + _magazine + "\n"
            + "Accuracy: " + _accuracy + "\n"
            + "Handling: " + _handling + "\n"
        );
    }

    debug_log_add("Gun stats printed to the GameMaker log.");
}
