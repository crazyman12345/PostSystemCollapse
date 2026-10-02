function raid_action_requirements_met(_action)
{
    // No requirements = allowed
    if (!variable_struct_exists(
        _action,
        "requirements"
    ))
    {
        return true;
    }


    var requirements =
        _action.requirements;


    if (array_length(requirements) <= 0)
    {
        return true;
    }


    for (
        var i = 0;
        i < array_length(requirements);
        i++
    )
    {
        if (!raid_req_met(
            requirements[i]
        ))
        {
            return false;
        }
    }


    return true;
}