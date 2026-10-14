function draw_raid_lighting()
{
    var _camera_x = camera_get_view_x(raid_camera);
    var _camera_y = camera_get_view_y(raid_camera);
    var _surface_width = max(1, ceil(camera_get_view_width(raid_camera)));
    var _surface_height = max(1, ceil(camera_get_view_height(raid_camera)));
    var _bloom_width = _surface_width;
    var _bloom_height = _surface_height;
    var _bloom_scale_x = _bloom_width / _surface_width;
    var _bloom_scale_y = _bloom_height / _surface_height;
    var _projectile_lists = [raid_bullets, raid_enemy_bullets];
    var _projectile_light_count = 0;

    // Count only visible lights and limit their combined contribution when projectile counts spike.
    for (var _count_list_index = 0; _count_list_index < array_length(_projectile_lists); _count_list_index++)
    {
        var _count_list = _projectile_lists[_count_list_index];
        for (var _count_index = 0; _count_index < array_length(_count_list); _count_index++)
        {
            var _count_projectile = _count_list[_count_index];
            if (variable_struct_exists(_count_projectile, "light_enabled") && !_count_projectile.light_enabled) continue;

            var _count_radius = variable_struct_exists(_count_projectile, "light_radius") ? _count_projectile.light_radius : 30;
            if (_count_projectile.bx + _count_radius < _camera_x
            || _count_projectile.bx - _count_radius > _camera_x + _surface_width
            || _count_projectile.by + _count_radius < _camera_y
            || _count_projectile.by - _count_radius > _camera_y + _surface_height) continue;

            _projectile_light_count++;
        }
    }

    var _projectile_light_scale = min(1, 4 / max(1, _projectile_light_count));

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

    if (raid_bloom_enabled && (!surface_exists(raid_emissive_surface)
    || surface_get_width(raid_emissive_surface) != _bloom_width
    || surface_get_height(raid_emissive_surface) != _bloom_height))
    {
        if (surface_exists(raid_emissive_surface)) surface_free(raid_emissive_surface);
        raid_emissive_surface = surface_create(_bloom_width, _bloom_height);
    }

    if (raid_bloom_enabled && (!surface_exists(raid_bloom_blur_surface)
    || surface_get_width(raid_bloom_blur_surface) != _bloom_width
    || surface_get_height(raid_bloom_blur_surface) != _bloom_height))
    {
        if (surface_exists(raid_bloom_blur_surface)) surface_free(raid_bloom_blur_surface);
        raid_bloom_blur_surface = surface_create(_bloom_width, _bloom_height);
    }

    if (raid_bloom_enabled && (!surface_exists(raid_bloom_surface)
    || surface_get_width(raid_bloom_surface) != _bloom_width
    || surface_get_height(raid_bloom_surface) != _bloom_height))
    {
        if (surface_exists(raid_bloom_surface)) surface_free(raid_bloom_surface);
        raid_bloom_surface = surface_create(_bloom_width, _bloom_height);
    }

    if (!surface_exists(raid_lighting_surface)
    || !surface_exists(raid_colored_lighting_surface)
    || (raid_bloom_enabled && (!surface_exists(raid_emissive_surface)
    || !surface_exists(raid_bloom_blur_surface)
    || !surface_exists(raid_bloom_surface)))) return;

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

    for (var _temporary_index = 0; _temporary_index < array_length(raid_temporary_lights); _temporary_index++)
    {
        var _temporary_light = raid_temporary_lights[_temporary_index];
        draw_raid_radial_light(
            _temporary_light.x - _camera_x,
            _temporary_light.y - _camera_y,
            _temporary_light.radius,
            _temporary_light.intensity,
            _temporary_light.color
        );
    }

    for (var _projectile_list_index = 0; _projectile_list_index < array_length(_projectile_lists); _projectile_list_index++)
    {
        var _projectile_list = _projectile_lists[_projectile_list_index];
        for (var _projectile_index = 0; _projectile_index < array_length(_projectile_list); _projectile_index++)
        {
            var _projectile = _projectile_list[_projectile_index];
            if (variable_struct_exists(_projectile, "light_enabled") && !_projectile.light_enabled) continue;

            var _projectile_radius = variable_struct_exists(_projectile, "light_radius") ? _projectile.light_radius : 30;
            if (_projectile.bx + _projectile_radius < _camera_x
            || _projectile.bx - _projectile_radius > _camera_x + _surface_width
            || _projectile.by + _projectile_radius < _camera_y
            || _projectile.by - _projectile_radius > _camera_y + _surface_height) continue;

            var _projectile_intensity = variable_struct_exists(_projectile, "light_intensity") ? _projectile.light_intensity : 0.22;
            var _projectile_color = variable_struct_exists(_projectile, "light_color")
                ? _projectile.light_color
                : (_projectile_list_index == 0 ? make_color_rgb(255, 190, 80) : make_color_rgb(255, 95, 40));
            draw_raid_radial_light(
                _projectile.bx - _camera_x,
                _projectile.by - _camera_y,
                _projectile_radius,
                _projectile_intensity * _projectile_light_scale,
                _projectile_color,
                0,
                1,
                1,
                16
            );
        }
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

    for (var _temporary_color_index = 0; _temporary_color_index < array_length(raid_temporary_lights); _temporary_color_index++)
    {
        var _temporary_color_light = raid_temporary_lights[_temporary_color_index];
        draw_raid_radial_light(
            _temporary_color_light.x - _camera_x,
            _temporary_color_light.y - _camera_y,
            _temporary_color_light.radius,
            _temporary_color_light.intensity * raid_colored_light_strength,
            _temporary_color_light.color
        );
    }

    for (var _projectile_color_list_index = 0; _projectile_color_list_index < array_length(_projectile_lists); _projectile_color_list_index++)
    {
        var _projectile_color_list = _projectile_lists[_projectile_color_list_index];
        for (var _projectile_color_index = 0; _projectile_color_index < array_length(_projectile_color_list); _projectile_color_index++)
        {
            var _color_projectile = _projectile_color_list[_projectile_color_index];
            if (variable_struct_exists(_color_projectile, "light_enabled") && !_color_projectile.light_enabled) continue;

            var _color_projectile_radius = variable_struct_exists(_color_projectile, "light_radius") ? _color_projectile.light_radius : 30;
            if (_color_projectile.bx + _color_projectile_radius < _camera_x
            || _color_projectile.bx - _color_projectile_radius > _camera_x + _surface_width
            || _color_projectile.by + _color_projectile_radius < _camera_y
            || _color_projectile.by - _color_projectile_radius > _camera_y + _surface_height) continue;

            var _color_projectile_intensity = variable_struct_exists(_color_projectile, "light_intensity") ? _color_projectile.light_intensity : 0.22;
            var _color_projectile_color = variable_struct_exists(_color_projectile, "light_color")
                ? _color_projectile.light_color
                : (_projectile_color_list_index == 0 ? make_color_rgb(255, 190, 80) : make_color_rgb(255, 95, 40));
            draw_raid_radial_light(
                _color_projectile.bx - _camera_x,
                _color_projectile.by - _camera_y,
                _color_projectile_radius,
                _color_projectile_intensity * _projectile_light_scale * raid_colored_light_strength,
                _color_projectile_color,
                0,
                1,
                1,
                16
            );
        }
    }

    surface_reset_target();

    if (raid_bloom_enabled)
    {
        // Render only emissive sprites into a fixed low-resolution bloom source.
        surface_set_target(raid_emissive_surface);
        draw_clear_alpha(c_black, 0);
        gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
        draw_raid_emissives(
            _camera_x,
            _camera_y,
            _bloom_scale_x,
            _bloom_scale_y,
            true,
            raid_bloom_wall_lamp_source_scale,
            raid_bloom_projectile_source_scale,
            raid_bloom_muzzle_flash_source_scale,
            raid_bloom_explosion_source_scale
        );
        surface_reset_target();

        var _blur_texel = shader_get_uniform(shd_raid_bloom_blur, "u_texel_size");
        var _blur_direction = shader_get_uniform(shd_raid_bloom_blur, "u_direction");
        var _blur_radius = shader_get_uniform(shd_raid_bloom_blur, "u_radius");
        var _bloom_texel_x = 1 / surface_get_width(raid_emissive_surface);
        var _bloom_texel_y = 1 / surface_get_height(raid_emissive_surface);
        var _previous_texfilter = gpu_get_texfilter();
        gpu_set_texfilter(true);

        for (var _blur_pass = 0; _blur_pass < clamp(raid_bloom_blur_passes, 1, 4); _blur_pass++)
        {
            // Horizontal Gaussian pass.
            surface_set_target(raid_bloom_blur_surface);
            draw_clear_alpha(c_black, 0);
            gpu_set_blendmode_ext_sepalpha(bm_one, bm_zero, bm_one, bm_zero);
            shader_set(shd_raid_bloom_blur);
            shader_set_uniform_f(_blur_texel, _bloom_texel_x, _bloom_texel_y);
            shader_set_uniform_f(_blur_direction, 1, 0);
            shader_set_uniform_f(_blur_radius, clamp(raid_bloom_blur_radius, 0, 16));
            draw_surface(_blur_pass == 0 ? raid_emissive_surface : raid_bloom_surface, 0, 0);
            shader_reset();
            surface_reset_target();

            // Vertical Gaussian pass.
            surface_set_target(raid_bloom_surface);
            draw_clear_alpha(c_black, 0);
            gpu_set_blendmode_ext_sepalpha(bm_one, bm_zero, bm_one, bm_zero);
            shader_set(shd_raid_bloom_blur);
            shader_set_uniform_f(_blur_texel, _bloom_texel_x, _bloom_texel_y);
            shader_set_uniform_f(_blur_direction, 0, 1);
            shader_set_uniform_f(_blur_radius, clamp(raid_bloom_blur_radius, 0, 16));
            draw_surface(raid_bloom_blur_surface, 0, 0);
            shader_reset();
            surface_reset_target();
        }

        gpu_set_texfilter(_previous_texfilter);
    }

    gpu_set_blendmode(bm_normal);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_surface(raid_lighting_surface, _camera_x, _camera_y);

    // Add the subtle colored illumination without re-drawing the darkness surface.
    gpu_set_blendmode_ext_sepalpha(bm_one, bm_one, bm_zero, bm_one);
    draw_surface(raid_colored_lighting_surface, _camera_x, _camera_y);

    // Keep the original sharp emissive sprites beneath the soft bloom.
    gpu_set_blendmode(bm_normal);
    draw_raid_emissives(0, 0, 1, 1, false);

    if (raid_bloom_enabled)
    {
        var _bloom_intensity = clamp(raid_bloom_intensity, 0, 3);
        var _previous_bloom_texfilter = gpu_get_texfilter();
        gpu_set_texfilter(true);
        gpu_set_blendmode_ext_sepalpha(bm_one, bm_one, bm_zero, bm_one);
        while (_bloom_intensity > 0)
        {
            var _bloom_draw_strength = min(1, _bloom_intensity);
            var _bloom_tint = make_color_rgb(255 * _bloom_draw_strength, 255 * _bloom_draw_strength, 255 * _bloom_draw_strength);
            draw_surface_stretched_ext(
                raid_bloom_surface,
                _camera_x,
                _camera_y,
                _surface_width,
                _surface_height,
                _bloom_tint,
                1
            );
            _bloom_intensity -= _bloom_draw_strength;
        }
        gpu_set_texfilter(_previous_bloom_texfilter);
    }

    // Draw the sharp projectile core normally above its emissive glow.
    gpu_set_blendmode(bm_normal);
    if (raid.state != RaidState.DEATH)
    {
        draw_raid_bullets();
        draw_raid_enemy_bullets();
    }

    shader_reset();
    gpu_set_blendmode_ext_sepalpha(
        _previous_blend_mode[0],
        _previous_blend_mode[1],
        _previous_blend_mode[2],
        _previous_blend_mode[3]
    );
    draw_set_color(_previous_color);
    draw_set_alpha(_previous_alpha);
}

function draw_raid_emissives(_camera_x, _camera_y, _scale_x, _scale_y, _include_explosions = true, _wall_light_source_scale = 1, _projectile_source_scale = 1, _muzzle_flash_source_scale = 1, _explosion_source_scale = 1)
{
    draw_raid_wall_lights(true, _camera_x, _camera_y, _scale_x, _scale_y, _wall_light_source_scale);

    if (raid.state == RaidState.DEATH) return;

    var _projectile_lists = [raid_bullets, raid_enemy_bullets];
    if (!_include_explosions) gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_one, bm_zero, bm_one);

    for (var _list_index = 0; _list_index < array_length(_projectile_lists); _list_index++)
    {
        var _projectiles = _projectile_lists[_list_index];
        var _xscale = 0.30 * _scale_x * _projectile_source_scale;
        var _yscale = 0.14 * _scale_y * _projectile_source_scale;
        var _sprite = _list_index == 0 ? spr_player_bullet_glow : spr_enemy_bullet_glow;
        var _color = _list_index == 0 ? make_color_rgb(255, 190, 80) : c_white;
        var _alpha = _list_index == 0 ? 0.35 : 0.40;

        for (var _projectile_index = 0; _projectile_index < array_length(_projectiles); _projectile_index++)
        {
            var _projectile = _projectiles[_projectile_index];
            draw_sprite_ext(
                _sprite,
                0,
                (_projectile.bx - _camera_x) * _scale_x,
                (_projectile.by - _camera_y) * _scale_y,
                _xscale,
                _yscale,
                _projectile.bdirection,
                _color,
                _alpha
            );
        }
    }

    if (!_include_explosions) gpu_set_blendmode(bm_normal);

    if (is_struct(raid_muzzle_flash_light) && raid_muzzle_flash_light.lifetime > 0)
    {
        draw_sprite_ext(
            spr_muzzle_flash,
            raid_muzzle_flash_light.flash_subimage,
            (round(raid_muzzle_flash_light.x) - _camera_x) * _scale_x,
            (round(raid_muzzle_flash_light.y) - _camera_y) * _scale_y,
            raid_muzzle_flash_light.flash_xscale * _scale_x * _muzzle_flash_source_scale,
            raid_muzzle_flash_light.flash_yscale * _scale_y * _muzzle_flash_source_scale,
            raid_muzzle_flash_light.flash_direction,
            c_white,
            1
        );
    }

    for (var _enemy_flash_index = 0; _enemy_flash_index < array_length(raid_enemies); _enemy_flash_index++)
    {
        var _enemy_flash = raid_enemies[_enemy_flash_index].enemy_muzzle_flash_light;
        if (!is_struct(_enemy_flash) || _enemy_flash.lifetime <= 0) continue;

        draw_sprite_ext(
            spr_muzzle_flash,
            _enemy_flash.flash_subimage,
            (round(_enemy_flash.x) - _camera_x) * _scale_x,
            (round(_enemy_flash.y) - _camera_y) * _scale_y,
            _enemy_flash.flash_xscale * _scale_x * _muzzle_flash_source_scale,
            _enemy_flash.flash_yscale * _scale_y * _muzzle_flash_source_scale,
            _enemy_flash.flash_direction,
            c_white,
            1
        );
    }

    if (_include_explosions)
    {
        for (var _explosion_index = 0; _explosion_index < array_length(raid_ring_hazards); _explosion_index++)
        {
            var _explosion = raid_ring_hazards[_explosion_index];
            if (!_explosion.active || _explosion.state != "ACTIVE") continue;

            draw_set_color(_explosion.ring_color);
            draw_set_alpha(1);
            var _half_thickness = _explosion.thickness * 0.5;
            for (var _offset = -_half_thickness; _offset <= _half_thickness; _offset += 0.5)
            {
                draw_circle(
                    (_explosion.x - _camera_x) * _scale_x,
                    (_explosion.y - _camera_y) * _scale_y,
                    max(0, (_explosion.current_radius + _offset) * min(_scale_x, _scale_y) * _explosion_source_scale),
                    true
                );
            }
        }
    }

    draw_set_color(c_white);
    draw_set_alpha(1);
}

function draw_raid_radial_light(_x, _y, _radius, _strength, _color = c_white, _rotation = 0, _x_scale = 1, _y_scale = 1, _segments = 32)
{
    if (_radius <= 0 || _strength <= 0) return;

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

function raid_spawn_temporary_light(_x, _y, _radius, _color, _intensity, _lifetime)
{
    if (_radius <= 0 || _intensity <= 0 || _lifetime <= 0) return undefined;

    var _light = {
        x: _x,
        y: _y,
        radius: _radius,
        color: _color,
        intensity: _intensity,
        lifetime: _lifetime
    };

    array_push(raid_temporary_lights, _light);
    return _light;
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

function draw_raid_wall_lights(_glow_only = false, _camera_x = 0, _camera_y = 0, _draw_scale_x = 1, _draw_scale_y = 1, _emissive_scale = 1)
{
    var _scale = 0.64;
    var _shelf_mount_offset = 24;

    for (var _light_index = 0; _light_index < array_length(raid_wall_lights); _light_index++)
    {
        var _light = raid_wall_lights[_light_index];
        if (_glow_only && !_light.enabled) continue;

        var _sprite = _glow_only
            ? spr_wall_lamp_glow
            : (_light.enabled ? spr_wall_lamp_on : spr_wall_lamp_off);
        var _sprite_scale = _scale * (_glow_only ? _emissive_scale : 1);
        var _offset_x = (sprite_get_width(_sprite) * 0.5 - sprite_get_xoffset(_sprite)) * _scale;
        var _offset_y = (sprite_get_height(_sprite) * 0.5 - sprite_get_yoffset(_sprite)) * _scale;
        if (_glow_only)
        {
            // Scale the emissive sprite around the bulb pixels rather than the sprite canvas center.
            var _bulb_pivot_x = 16;
            var _bulb_pivot_y = 20.5;
            _offset_x += (_bulb_pivot_x - sprite_get_xoffset(_sprite)) * (_sprite_scale - _scale);
            _offset_y += (_bulb_pivot_y - sprite_get_yoffset(_sprite)) * (_sprite_scale - _scale);
        }
        var _offset_distance = point_distance(0, 0, _offset_x, _offset_y);
        var _offset_direction = point_direction(0, 0, _offset_x, _offset_y) + _light.rotation;
        var _mount_x = _light.x - lengthdir_x(_shelf_mount_offset, _light.rotation);
        var _mount_y = _light.y - lengthdir_y(_shelf_mount_offset, _light.rotation);

        draw_sprite_ext(
            _sprite,
            0,
            (_mount_x - lengthdir_x(_offset_distance, _offset_direction) - _camera_x) * _draw_scale_x,
            (_mount_y - lengthdir_y(_offset_distance, _offset_direction) - _camera_y) * _draw_scale_y,
            _sprite_scale * _draw_scale_x,
            _sprite_scale * _draw_scale_y,
            _light.rotation,
            c_white,
            1
        );
    }
}
