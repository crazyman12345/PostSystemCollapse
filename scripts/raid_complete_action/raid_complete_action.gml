function raid_complete_action(_action_key)
{
    variable_struct_set(
        raid.completed_actions,
        _action_key,
        true
    );
}