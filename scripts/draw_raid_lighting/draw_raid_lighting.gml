function draw_raid_lighting()
{
    var _camera_x = camera_get_view_x(raid_camera);
    var _camera_y = camera_get_view_y(raid_camera);
    var _surface_width = max(1, ceil(camera_get_view_width(raid_camera)));
    var _surface_height = max(1, ceil(camera_get_view_height(raid_camera)));

    if (!surface_exists(raid_lighting_surface)
    || surface_get_width(raid_lighting_surface) != _surface_width
    || surface_get_height(raid_lighting_surface) != _surface_height)
    {
        if (surface_exists(raid_lighting_surface)) surface_free(raid_lighting_surface);
        raid_lighting_surface = surface_create(_surface_width, _surface_height);
    }

    if (!surface_exists(raid_colored_lighting_surface)
    || surface_get_width(raid_colored_lighting_surface) != _surface_width
    || surface_get_height(raid_colored_lighting_surface) != _surface_height)
    {
        if (surface_exists(raid_colored_lighting_surface)) surface_free(raid_colored_lighting_surface);
        raid_colored_lighting_surface = surface_create(_surface_width, _surface_height);
    }

    if (!surface_exists(raid_lighting_surface) || !surface_exists(raid_colored_lighting_surface)) return;

    var _previous_blend_mode = gpu_get_blendmode_ext_sepalpha();
    var _previous_color = draw_get_color();
    var _previous_alpha = draw_get_alpha();

    surface_set_target(raid_lighting_surface);
    draw_clear_alpha(c_black, clamp(raid_lighting_ambient_alpha, 0, 1));

    // Keep the darkness color and remove only its alpha beneath each light.
    gpu_set_blendmode_ext_sepalpha(bm_zero, bm_one, bm_zero, bm_inv_src_alpha);
    draw_raid_radial_light(
        raid_player_x - _camera_x,
        raid_player_y - _camera_y,
        raid_player_light_radius,
        raid_player_light_strength,
        c_white
    );

    // Additional world-space lights reveal the existing world beneath the darkness.
    for (var _light_index = 0; _light_index < array_length(raid_light_sources); _light_index++)
    {
        var _light = raid_light_sources[_light_index];
        if (variable_struct_exists(_light, "enabled") && !_light.enabled) continue;

        var _intensity = variable_struct_exists(_light, "intensity")
            ? _light.intensity
            : _light.strength;
        var _color = variable_struct_exists(_light, "color") ? _light.color : c_white;
        var _falloff_rotation = variable_struct_exists(_light, "falloff_rotation") ? _light.falloff_rotation : 0;
        var _falloff_x_scale = variable_struct_exists(_light, "falloff_x_scale") ? _light.falloff_x_scale : 1;
        var _falloff_y_scale = variable_struct_exists(_light, "falloff_y_scale") ? _light.falloff_y_scale : 1;
        var _falloff_offset = variable_struct_exists(_light, "falloff_offset") ? _light.falloff_offset : 0;
        draw_raid_radial_light(
            _light.x + lengthdir_x(_light.radius * _falloff_offset, _falloff_rotation) - _camera_x,
            _light.y + lengthdir_y(_light.radius * _falloff_offset, _falloff_rotation) - _camera_y,
            _light.radius,
            _intensity,
            _color,
            _falloff_rotation,
            _falloff_x_scale,
            _falloff_y_scale
        );
    }

    surface_reset_target();

    surface_set_target(raid_colored_lighting_surface);
    draw_clear_alpha(c_black, 0);

    // Store only premultiplied light RGB so the color pass remains independent of the darkness mask.
    gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_one, bm_zero, bm_one);
    for (var _color_index = 0; _color_index < array_length(raid_light_sources); _color_index++)
    {
        var _color_light = raid_light_sources[_color_index];
        if (variable_struct_exists(_color_light, "enabled") && !_color_light.enabled) continue;

        var _color_intensity = variable_struct_exists(_color_light, "intensity")
            ? _color_light.intensity
            : _color_light.strength;
        var _light_color = variable_struct_exists(_color_light, "color") ? _color_light.color : c_white;
        var _color_falloff_rotation = variable_struct_exists(_color_light, "falloff_rotation") ? _color_light.falloff_rotation : 0;
        var _color_falloff_x_scale = variable_struct_exists(_color_light, "falloff_x_scale") ? _color_light.falloff_x_scale : 1;
        var _color_falloff_y_scale = variable_struct_exists(_color_light, "falloff_y_scale") ? _color_light.falloff_y_scale : 1;
        var _color_falloff_offset = variable_struct_exists(_color_light, "falloff_offset") ? _color_light.falloff_offset : 0;
        draw_raid_radial_light(
            _color_light.x + lengthdir_x(_color_light.radius * _color_falloff_offset, _color_falloff_rotation) - _camera_x,
            _color_light.y + lengthdir_y(_color_light.radius * _color_falloff_offset, _color_falloff_rotation) - _camera_y,
            _color_light.radius,
            _color_intensity * raid_colored_light_strength,
            _light_color,
            _color_falloff_rotation,
            _color_falloff_x_scale,
            _color_falloff_y_scale
        );
    }

    surface_reset_target();
    gpu_set_blendmode(bm_normal);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_surface(raid_lighting_surface, _camera_x, _camera_y);

    // Add the subtle colored illumination without re-drawing the darkness surface.
    gpu_set_blendmode_ext_sepalpha(bm_one, bm_one, bm_zero, bm_one);
    draw_surface(raid_colored_lighting_surface, _camera_x, _camera_y);

    // Keep only the powered bulbs brighter than the illumination they cast.
    gpu_set_blendmode(bm_normal);
    draw_raid_wall_lights(true);

    gpu_set_blendmode_ext_sepalpha(_previous_blend_mode);
    draw_set_color(_previous_color);
    draw_set_alpha(_previous_alpha);
}

function draw_raid_radial_light(_x, _y, _radius, _strength, _color = c_white, _rotation = 0, _x_scale = 1, _y_scale = 1)
{
    if (_radius <= 0 || _strength <= 0) return;

    var _segments = 32;
    var _alpha = clamp(_strength, 0, 1);
    var _angle_step = 360 / _segments;

    draw_primitive_begin(pr_trianglelist);
    for (var _segment = 0; _segment < _segments; _segment++)
    {
        var _angle_1 = _segment * _angle_step;
        var _angle_2 = (_segment + 1) * _angle_step;

        draw_vertex_colour(_x, _y, _color, _alpha);
        var _point_1_x = lengthdir_x(_radius * _x_scale, _angle_1);
        var _point_1_y = lengthdir_y(_radius * _y_scale, _angle_1);
        var _point_2_x = lengthdir_x(_radius * _x_scale, _angle_2);
        var _point_2_y = lengthdir_y(_radius * _y_scale, _angle_2);

        draw_vertex_colour(
            _x + lengthdir_x(_point_1_x, _rotation) - lengthdir_y(_point_1_y, _rotation),
            _y + lengthdir_y(_point_1_x, _rotation) + lengthdir_x(_point_1_y, _rotation),
            _color,
            0
        );
        draw_vertex_colour(
            _x + lengthdir_x(_point_2_x, _rotation) - lengthdir_y(_point_2_y, _rotation),
            _y + lengthdir_y(_point_2_x, _rotation) + lengthdir_x(_point_2_y, _rotation),
            _color,
            0
        );
    }
    draw_primitive_end();
}

function raid_spawn_wall_light(_x, _y, _rotation = 0, _enabled = true, _radius = 100, _color = c_orange, _intensity = 0.55)
{
    var _fixture = {
        x: _x,
        y: _y,
        rotation: _rotation,
        enabled: _enabled,
        radius: _radius,
        color: _color,
        intensity: _intensity,
        falloff_rotation: _rotation,
        falloff_x_scale: 1.15,
        falloff_y_scale: 0.85,
        falloff_offset: 0.2
    };

    array_push(raid_wall_lights, _fixture);
    array_push(raid_light_sources, _fixture);
    return _fixture;
}

function raid_generate_room_wall_lights()
{
    raid_wall_lights = [];
    raid_light_sources = [];
	var _o = 25;
    var _warm_orange = make_color_rgb(255, 185, 120);
	//right
    raid_spawn_wall_light(1168 - _o, 397, 180, true, 100, _warm_orange, 0.55);
    raid_spawn_wall_light(1168 - _o, 584, 180, true, 100, _warm_orange, 0.55);
	//left
	 raid_spawn_wall_light(752 + _o, 683, 0, true, 100, _warm_orange, 0.55);
	 raid_spawn_wall_light(752 + _o, 457, 0, true, 100, _warm_orange, 0.55);
	 //top
	 raid_spawn_wall_light(1101, 335 + _o, 270, true, 100, _warm_orange, 0.55);	
	 raid_spawn_wall_light(819, 335 + _o, 270, true, 100, _warm_orange, 0.55);	
	 //bottom
	 raid_spawn_wall_light(1018, 744 - _o, 90, true, 100, _warm_orange, 0.55);	
	 raid_spawn_wall_light(801, 744 - _o, 90, true, 100, _warm_orange, 0.55);	
}

function draw_raid_wall_lights(_glow_only = false)
{
    var _scale = 0.02;
    var _shelf_mount_offset = 24;

    for (var _light_index = 0; _light_index < array_length(raid_wall_lights); _light_index++)
    {
        var _light = raid_wall_lights[_light_index];
        if (_glow_only && !_light.enabled) continue;

        var _sprite = _glow_only
            ? spr_wall_lamp_glow
            : (_light.enabled ? spr_wall_lamp_on : spr_wall_lamp_off);
        var _offset_x = (sprite_get_width(_sprite) * 0.5 - sprite_get_xoffset(_sprite)) * _scale;
        var _offset_y = (sprite_get_height(_sprite) * 0.5 - sprite_get_yoffset(_sprite)) * _scale;
        var _offset_distance = point_distance(0, 0, _offset_x, _offset_y);
        var _offset_direction = point_direction(0, 0, _offset_x, _offset_y) + _light.rotation;
        var _mount_x = _light.x - lengthdir_x(_shelf_mount_offset, _light.rotation);
        var _mount_y = _light.y - lengthdir_y(_shelf_mount_offset, _light.rotation);

        draw_sprite_ext(
            _sprite,
            0,
            _mount_x - lengthdir_x(_offset_distance, _offset_direction),
            _mount_y - lengthdir_y(_offset_distance, _offset_direction),
            _scale,
            _scale,
            _light.rotation,
            c_white,
            1
        );
    }
}
