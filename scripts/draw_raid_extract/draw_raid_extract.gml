function draw_raid_extract()
{
    if (!raid.extract_active)
        return;

    var _x = raid_room_x1 + raid_environment.ladder_x_offset;

    var _bottom = raid_room_y1 + raid_environment.ladder_y_offset;
    var _height = raid_environment.ladder_height;
    var _width = raid_environment.ladder_width;
    var _projection_x = raid_environment.ladder_projection_x;
    var _projection_y = raid_environment.ladder_projection_y;
    var _top_left = raid_environment_vertex(_x - _width * 0.5, _bottom, _height, 0, 0, _projection_x, _projection_y);
    var _top_right = raid_environment_vertex(_x + _width * 0.5, _bottom, _height, 1, 0, _projection_x, _projection_y);
    var _bottom_right = raid_environment_vertex(_x + _width * 0.5, _bottom, 0, 1, 1, _projection_x, _projection_y);
    var _bottom_left = raid_environment_vertex(_x - _width * 0.5, _bottom, 0, 0, 1, _projection_x, _projection_y);

    raid_environment_project(_top_left, raid_environment.ladder_perspective_x, raid_environment.ladder_perspective_y);
    raid_environment_project(_top_right, raid_environment.ladder_perspective_x, raid_environment.ladder_perspective_y);
    raid_environment_project(_bottom_right, raid_environment.ladder_perspective_x, raid_environment.ladder_perspective_y);
    raid_environment_project(_bottom_left, raid_environment.ladder_perspective_x, raid_environment.ladder_perspective_y);

    if (global.graphics_settings.contact_shadows && raid_character_shadows_enabled)
        draw_raid_character_shadow(
            _x + raid_environment.ladder_contact_shadow_offset_x,
            _bottom + raid_environment.ladder_contact_shadow_offset_y,
            _width / max(1, raid_character_shadow_size),
            1.5
        );

    var _previous_texfilter = gpu_get_texfilter();
    var _material = raid_environment.ladder_material;
    gpu_set_texfilter(false);
    draw_primitive_begin_texture(pr_trianglestrip, _material.texture);
    raid_environment_draw_vertex(_top_left, _material, c_white);
    raid_environment_draw_vertex(_top_right, _material, c_white);
    raid_environment_draw_vertex(_bottom_left, _material, c_white);
    raid_environment_draw_vertex(_bottom_right, _material, c_white);
    draw_primitive_end();
    gpu_set_texfilter(_previous_texfilter);

    if (raid_ladder_projection_debug_enabled)
    {
        draw_set_color(c_lime);
        draw_line(_top_left.draw_x, _top_left.draw_y, _top_right.draw_x, _top_right.draw_y);
        draw_line(_top_right.draw_x, _top_right.draw_y, _bottom_right.draw_x, _bottom_right.draw_y);
        draw_line(_bottom_right.draw_x, _bottom_right.draw_y, _bottom_left.draw_x, _bottom_left.draw_y);
        draw_line(_bottom_left.draw_x, _bottom_left.draw_y, _top_left.draw_x, _top_left.draw_y);
        draw_circle(_x, _bottom, 2, false);
    }

    // LABEL
    draw_set_color(c_white);
    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_center);

    draw_text_transformed(
        _x,
        _bottom + 18,
        "EXTRACT",
        0.35,
        0.35,
        0
    );
    draw_set_halign(fa_left);
}

function draw_raid_extract_prompt()
{
    if (!raid.extract_active) return;

    var _x = raid_room_x1 + raid_environment.ladder_x_offset;
    var _distance = point_distance(raid_player_x, raid_player_y, _x,
        raid_room_y1 + raid_environment.ladder_y_offset - 15);
    if (_distance <= 50) draw_interact_prompt(raid_player_x, raid_player_y - 38);
}
