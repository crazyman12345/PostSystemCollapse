function debug_command_items()
{
    var item_keys =
        variable_struct_get_names(global.items);

    for (var i = 0; i < array_length(item_keys); i++)
    {
        var item_key = item_keys[i];
        var item = item_get(item_key);

        debug_log_add(
            item_key
            + " - "
            + item.name
        );
    }
}
