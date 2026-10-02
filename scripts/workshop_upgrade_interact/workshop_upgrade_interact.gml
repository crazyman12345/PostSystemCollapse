function workshop_upgrade_interact(_key)
{
    var bench = variable_struct_get(workshop_db, _key);
    var level = variable_struct_get(workshop_progress, _key);

    if (level >= bench.max_level)
    {
        log_add(bench.name + " is already max level.");
        return;
    }

    if (!workshop_can_upgrade(_key))
    {
        log_add("Not enough materials to upgrade " + bench.name + ".");
        return;
    }

    if (workshop_upgrade(_key))
    {
        var new_level = variable_struct_get(workshop_progress, _key);

        if (new_level == 1) log_add(bench.name + " built.");
        else log_add(bench.name + " upgraded to Level " + string(new_level) + ".");
    }
}