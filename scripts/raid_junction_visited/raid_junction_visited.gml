function raid_junction_visited(_junction_key)
{
    if (!variable_struct_exists(
        raid.visited_junctions,
        _junction_key
    ))
    {
        return false;
    }

    return variable_struct_get(
        raid.visited_junctions,
        _junction_key
    );
}