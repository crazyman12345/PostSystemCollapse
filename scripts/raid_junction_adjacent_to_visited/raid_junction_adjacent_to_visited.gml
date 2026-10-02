function raid_junction_adjacent_to_visited(_junction_key)
{
    var location =
        raid_location_get(raid.location_key);

    if (is_undefined(location))
        return false;


    var junction_keys =
        variable_struct_get_names(
            location.junctions
        );


    for (var i = 0; i < array_length(junction_keys); i++)
    {
        var other_key =
            junction_keys[i];

        // Only check rooms already explored
        if (!raid_junction_visited(other_key))
            continue;


        var _other =
            variable_struct_get(
                location.junctions,
                other_key
            );


        if (!variable_struct_exists(
            _other,
            "connections"
        ))
        {
            continue;
        }


        for (
            var c = 0;
            c < array_length(_other.connections);
            c++
        )
        {
            if (_other.connections[c] == _junction_key)
            {
                return true;
            }
        }
    }


    return false;
}