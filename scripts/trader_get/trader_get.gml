function trader_get(_trader_key)
{
    if (!variable_struct_exists(global.traders, _trader_key))
    {
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