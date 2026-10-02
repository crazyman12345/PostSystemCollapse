function raid_junction_get(_junction_key)
{
    var location =
        raid_location_get(
            raid.location_key
        );

    if (is_undefined(location))
    {
        return undefined;
    }


    if (!variable_struct_exists(
        location.junctions,
        _junction_key
    ))
    {
        return undefined;
    }


    return variable_struct_get(
        location.junctions,
        _junction_key
    );
}