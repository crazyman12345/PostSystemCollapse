function draw_raid_map(_x1, _y1, _x2, _y2)
{
    var location =
        raid_location_get(
            raid.location_key
        );

    if (is_undefined(location))
        return;


    var junction_keys =
        variable_struct_get_names(
            location.junctions
        );


    // --------------------------------------------------
    // MAP SETTINGS
    // --------------------------------------------------

    var cell_width = 260;
    var cell_height = 160;

    var box_width = 180;
    var box_height = 100;


    var map_width =
        _x2 - _x1;

    var map_height =
        _y2 - _y1;


    // --------------------------------------------------
    // CREATE / RECREATE SURFACE
    // --------------------------------------------------

    if (
        !surface_exists(raid_map_surface)
        ||
        surface_get_width(raid_map_surface) != map_width
        ||
        surface_get_height(raid_map_surface) != map_height
    )
    {
        if (surface_exists(raid_map_surface))
        {
            surface_free(raid_map_surface);
        }

        raid_map_surface =
            surface_create(
                map_width,
                map_height
            );
    }


    // --------------------------------------------------
    // CURRENT ROOM
    // --------------------------------------------------

    var current_junction =
        raid_junction_get(
            raid.junction_key
        );

    if (is_undefined(current_junction))
        return;


    // --------------------------------------------------
    // DRAW MAP ONTO SURFACE
    // --------------------------------------------------

    surface_set_target(
        raid_map_surface
    );


    draw_clear_alpha(
        c_black,
        1
    );


    draw_set_font(
        fnt_ascii
    );

    draw_set_color(
        c_lime
    );


    // Center of surface
    var map_center_x =
        map_width / 2;

    var map_center_y =
        map_height / 2;


    // Keep current room centered
    var map_origin_x =
        map_center_x
        - current_junction.map_x * cell_width
        - box_width / 2;

    var map_origin_y =
        map_center_y
        - current_junction.map_y * cell_height
        - box_height / 2;


    // --------------------------------------------------
    // DRAW CONNECTIONS FIRST
    // --------------------------------------------------

    for (
        var i = 0;
        i < array_length(junction_keys);
        i++
    )
    {
        var junction_key =
            junction_keys[i];

        var junction =
            variable_struct_get(
                location.junctions,
                junction_key
            );


        if (!variable_struct_exists(
            junction,
            "connections"
        ))
        {
            continue;
        }


        var room_x =
            map_origin_x
            + junction.map_x
            * cell_width;

        var room_y =
            map_origin_y
            + junction.map_y
            * cell_height;


        for (
            var c = 0;
            c < array_length(junction.connections);
            c++
        )
        {
            var target_key =
                junction.connections[c];

            var target =
                variable_struct_get(
                    location.junctions,
                    target_key
                );


            if (is_undefined(target))
                continue;


            var target_room_x =
                map_origin_x
                + target.map_x
                * cell_width;

            var target_room_y =
                map_origin_y
                + target.map_y
                * cell_height;


            draw_ascii_connection(
                room_x,
                room_y,
                target_room_x,
                target_room_y,
                box_width,
                box_height
            );
        }
    }


    // --------------------------------------------------
    // DRAW ROOM BOXES
    // --------------------------------------------------

    for (
        var i = 0;
        i < array_length(junction_keys);
        i++
    )
    {
        var junction_key =
            junction_keys[i];

        var junction =
            variable_struct_get(
                location.junctions,
                junction_key
            );


        var room_x =
            map_origin_x
            + junction.map_x
            * cell_width;

        var room_y =
            map_origin_y
            + junction.map_y
            * cell_height;


        var visited =
            raid_junction_visited(
                junction_key
            );


        var current =
            junction_key
            == raid.junction_key;


		var adjacent =
		    raid_junction_adjacent_to_visited(
		        junction_key
		    );


		var room_text = "?????";


		// Already explored
		if (visited)
		{
		    room_text =
		        junction.name;
		}


		// Adjacent but unexplored
		else if (adjacent)
		{
		    room_text =
		        "?"
		        + junction.name
		        + "?";
		}

		
        if (current)
        {
            room_text =
                "> "
                + room_text
                + " <";
        }


        // Black room interior
        draw_set_color(
            c_black
        );

        draw_rectangle(
            room_x,
            room_y,
            room_x + box_width,
            room_y + box_height,
            false
        );


        // ASCII border
        draw_set_color(
            c_lime
        );

        draw_ascii_rectangle(
            room_x,
            room_y,
            room_x + box_width,
            room_y + box_height
        );


        // Center room text
        draw_set_font(
            fnt_ascii
        );

        draw_set_color(
            c_lime
        );


        var text_width =
            string_width(
                room_text
            );

        var text_height =
            string_height(
                room_text
            );


        var text_x =
            room_x
            + box_width / 2
            - text_width / 2;

        var text_y =
            room_y
            + box_height / 2
            - text_height / 2;


        draw_text(
            text_x,
            text_y,
            room_text
        );
    }


    // --------------------------------------------------
    // FINISH SURFACE
    // --------------------------------------------------

    surface_reset_target();


    // --------------------------------------------------
    // DRAW MAP SURFACE TO GUI
    // --------------------------------------------------

    draw_surface(
        raid_map_surface,
        _x1,
        _y1
    );


    // --------------------------------------------------
    // OUTER MAP BORDER
    // --------------------------------------------------

    draw_set_font(
        fnt_ascii
    );

    draw_set_color(
        c_lime
    );


    draw_ascii_rectangle(
        _x1,
        _y1,
        _x2+10,
        _y2+10
    );
}