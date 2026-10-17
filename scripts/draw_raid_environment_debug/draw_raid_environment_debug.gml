function draw_raid_environment_debug()
{
    if (!raid_environment.enabled || !raid_environment.debug || is_undefined(raid_environment.geometry)) return;
    var _geometry = raid_environment.geometry;
    var _cap_offset = raid_environment.wall_height * max(0, raid_environment.vertical_projection)
        + raid_environment.wall_thickness;
    var _outer_left = raid_room_x1 - _cap_offset;
    var _outer_top = raid_room_y1 - _cap_offset;
    var _outer_right = raid_room_x2 + _cap_offset;
    var _outer_bottom = raid_room_y2 + _cap_offset;

    draw_set_alpha(1);
    draw_set_color(c_lime);
    draw_rectangle(raid_room_x1, raid_room_y1, raid_room_x2, raid_room_y2, true);
    draw_set_color(c_yellow);
    draw_rectangle(_outer_left, _outer_top, _outer_right, _outer_bottom, true);
    draw_set_color(c_aqua);
    raid_environment_debug_batch(_geometry.back_inner_faces);
    raid_environment_debug_batch(_geometry.back_caps);
    raid_environment_debug_batch(_geometry.front_inner_faces);
    raid_environment_debug_batch(_geometry.front_caps);

    draw_set_color(c_red);
    for (var _opening_index = 0; _opening_index < array_length(_geometry.openings); _opening_index++)
    {
        var _opening = _geometry.openings[_opening_index];
        draw_line(_opening.left, raid_room_y1 - 8, _opening.left, raid_room_y1 + 8);
        draw_line(_opening.right, raid_room_y1 - 8, _opening.right, raid_room_y1 + 8);
    }

    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(raid_room_x1, raid_room_y2 + raid_environment.wall_thickness + 8,
        "2.5D wall height: " + string(raid_environment.wall_height)
        + "  perspective: (" + string_format(raid_environment.perspective_x * raid_environment.wall_height, 0, 2)
        + ", " + string_format(raid_environment.perspective_y * raid_environment.wall_height, 0, 2) + ")");
    draw_set_color(c_white);
}


function raid_environment_debug_batch(_batch)
{
    for (var _quad_index = 0; _quad_index < array_length(_batch); _quad_index++)
    {
        var _vertices = _batch[_quad_index].vertices;
        for (var _vertex_index = 0; _vertex_index < 4; _vertex_index++)
        {
            var _vertex = _vertices[_vertex_index];
            draw_point(_vertex.draw_x, _vertex.draw_y);
        }
    }
}
