function raid_action_completed(_action_key)
{
    if (!variable_struct_exists(
        raid.completed_actions,
        _action_key
    ))
    {
        return false;
    }

    return variable_struct_get(
        raid.completed_actions,
        _action_key
    );
}