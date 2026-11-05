function workshop_upgrade_interact(_key)
{
    var bench = variable_struct_get(workshop_db, _key);
    var level = variable_struct_get(workshop_progress, _key);

    if (level >= bench.max_level)
    {
        return false;
    }

    if (!workshop_can_upgrade(_key))
    {
        return false;
    }

    return workshop_upgrade(_key);
}
