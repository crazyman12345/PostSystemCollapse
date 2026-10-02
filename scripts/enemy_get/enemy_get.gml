function enemy_get(_enemy_key)
{
    if (!variable_struct_exists(global.enemies, _enemy_key))
    {
        show_debug_message(
            "ERROR: Unknown enemy: "
            + _enemy_key
        );

        return undefined;
    }

    return variable_struct_get(
        global.enemies,
        _enemy_key
    );
}