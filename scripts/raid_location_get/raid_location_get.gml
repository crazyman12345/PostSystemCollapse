function raid_location_get(_location_key)
{
    if (!variable_struct_exists(
        global.raid_locations,
        _location_key
    ))
    {
        return undefined;
    }

    return variable_struct_get(
        global.raid_locations,
        _location_key
    );
}