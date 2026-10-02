function item_get(_item_key)
{
    if (!variable_struct_exists(global.items, _item_key))
    {
        show_debug_message(
            "ERROR: Unknown item: "
            + _item_key
        );

        return undefined;
    }

    return variable_struct_get(
        global.items,
        _item_key
    );
}