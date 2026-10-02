function raid_get_available_actions()
{
    // ========================================================
    // GET CURRENT JUNCTION
    // ========================================================

    var junction =
        raid_junction_get(
            raid.junction_key
        );


    if (is_undefined(junction))
    {
        return [];
    }


    // ========================================================
    // MAKE SURE JUNCTION HAS ACTIONS
    // ========================================================

    if (!variable_struct_exists(
        junction,
        "actions"
    ))
    {
        return [];
    }


    var available_actions =
        [];


    // ========================================================
    // CHECK EACH ACTION
    // ========================================================

    for (
        var i = 0;
        i < array_length(junction.actions);
        i++
    )
    {
        var action =
            junction.actions[i];


        // ----------------------------------------------------
        // DEFAULT REPEATABLE TO FALSE
        // ----------------------------------------------------

        var repeatable =
            false;


        if (
            variable_struct_exists(
                action,
                "repeatable"
            )
        )
        {
            repeatable =
                action.repeatable;
        }


        // ----------------------------------------------------
        // HIDE COMPLETED NON-REPEATABLE ACTIONS
        // ----------------------------------------------------

        if (
            !repeatable
            && raid_action_completed(
                action.action_key
            )
        )
        {
            continue;
        }


        // ----------------------------------------------------
        // ADD ACTION
        //
        // IMPORTANT:
        // We do NOT check requirements here.
        // Locked actions should still be visible.
        // ----------------------------------------------------

        array_push(
            available_actions,
            action
        );
    }


    return available_actions;
}