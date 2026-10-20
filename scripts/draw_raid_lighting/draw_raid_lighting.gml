function draw_raid_lighting()
{
    var _settings = global.graphics_settings;
    var _dynamic_lighting = _settings.dynamic_lighting;
    var _use_darkness = _dynamic_lighting && _settings.ambient_darkness;
    var _use_colored_lighting = _dynamic_lighting && _settings.colored_lighting;
    var _use_projected_shadows = _settings.environment_shadows || _settings.character_shadows;
    var _use_smoke_lighting = _settings.smoke_effects && (_use_darkness || _use_colored_lighting);
    var _need_darkness_surface = _use_darkness || _use_smoke_lighting;
    var _need_colored_surface = _use_colored_lighting || _use_smoke_lighting;
    var _camera_x = camera_get_view_x(raid_camera);
    var _camera_y = camera_get_view_y(raid_camera);
    var _surface_width = max(1, ceil(camera_get_view_width(raid_camera)));
    var _surface_height = max(1, ceil(camera_get_view_height(raid_camera)));
    var _bloom_width = _surface_width;
    var _bloom_height = _surface_height;
    var _bloom_scale_x = _bloom_width / _surface_width;
    var _bloom_scale_y = _bloom_height / _surface_height;
    var _projectile_lights = [];
    var _shadow_occluders = _dynamic_lighting && _use_projected_shadows ? raid_shadow_get_active_occluders() : [];
    var _share_shadow_pass = _use_darkness && _use_colored_lighting && array_length(_shadow_occluders) > 0;

    // Select visible projectile lights once for both lighting passes. Projectile
    // sprites, bloom, smoke, and gameplay are independent of this capped list.
    if (_dynamic_lighting && _settings.projectile_lighting)
    {
        var _projectile_lists = [raid_bullets, raid_enemy_bullets];
        for (var _count_list_index = 0; _count_list_index < array_length(_projectile_lists); _count_list_index++)
        {
            var _count_list = _projectile_lists[_count_list_index];
            for (var _count_index = 0; _count_index < array_length(_count_list); _count_index++)
            {
                var _count_projectile = _count_list[_count_index];
                if (variable_struct_exists(_count_projectile, "light_enabled") && !_count_projectile.light_enabled) continue;

                var _count_radius = variable_struct_exists(_count_projectile, "light_radius") ? _count_projectile.light_radius : raid_projectile_light_radius;
                if (_count_projectile.bx + _count_radius < _camera_x
                || _count_projectile.bx - _count_radius > _camera_x + _surface_width
                || _count_projectile.by + _count_radius < _camera_y
                || _count_projectile.by - _count_radius > _camera_y + _surface_height) continue;

                var _distance_x = _count_projectile.bx - raid_player_x;
                var _distance_y = _count_projectile.by - raid_player_y;
                array_push(_projectile_lights, {
                    projectile: _count_projectile,
                    color: variable_struct_exists(_count_projectile, "light_color")
                        ? _count_projectile.light_color
                        : (_count_list_index == 0 ? raid_player_projectile_light_color : raid_enemy_projectile_light_color),
                    distance_squared: _distance_x * _distance_x + _distance_y * _distance_y
                });
            }
        }

        array_sort(_projectile_lights, function(_a, _b) { return _a.distance_squared - _b.distance_squared; });
        if (array_length(_projectile_lights) > raid_projectile_light_max)
            array_resize(_projectile_lights, raid_projectile_light_max);
    }

    if (_need_darkness_surface && (!surface_exists(raid_lighting_surface)
    || surface_get_width(raid_lighting_surface) != _surface_width
    || surface_get_height(raid_lighting_surface) != _surface_height))
    {
        if (surface_exists(raid_lighting_surface)) surface_free(raid_lighting_surface);
        raid_lighting_surface = surface_create(_surface_width, _surface_height);
    }

    if (_need_colored_surface && (!surface_exists(raid_colored_lighting_surface)
    || surface_get_width(raid_colored_lighting_surface) != _surface_width
    || surface_get_height(raid_colored_lighting_surface) != _surface_height))
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

    if (raid_bloom_enabled && (!surface_exists(raid_projectile_emissive_surface)
    || surface_get_width(raid_projectile_emissive_surface) != _bloom_width
    || surface_get_height(raid_projectile_emissive_surface) != _bloom_height))
    {
        if (surface_exists(raid_projectile_emissive_surface)) surface_free(raid_projectile_emissive_surface);
        raid_projectile_emissive_surface = surface_create(_bloom_width, _bloom_height);
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

    if (raid_bloom_enabled && (!surface_exists(raid_projectile_bloom_surface)
    || surface_get_width(raid_projectile_bloom_surface) != _bloom_width
    || surface_get_height(raid_projectile_bloom_surface) != _bloom_height))
    {
        if (surface_exists(raid_projectile_bloom_surface)) surface_free(raid_projectile_bloom_surface);
        raid_projectile_bloom_surface = surface_create(_bloom_width, _bloom_height);
    }

    if (!_need_darkness_surface) raid_lighting_surface = graphics_settings_release_surface(raid_lighting_surface);
    if (!_need_colored_surface) raid_colored_lighting_surface = graphics_settings_release_surface(raid_colored_lighting_surface);
    if (!raid_bloom_enabled)
    {
        raid_emissive_surface = graphics_settings_release_surface(raid_emissive_surface);
        raid_projectile_emissive_surface = graphics_settings_release_surface(raid_projectile_emissive_surface);
        raid_bloom_blur_surface = graphics_settings_release_surface(raid_bloom_blur_surface);
        raid_bloom_surface = graphics_settings_release_surface(raid_bloom_surface);
        raid_projectile_bloom_surface = graphics_settings_release_surface(raid_projectile_bloom_surface);
    }

    if ((_need_darkness_surface && !surface_exists(raid_lighting_surface))
    || (_need_colored_surface && !surface_exists(raid_colored_lighting_surface))
    || (raid_bloom_enabled && (!surface_exists(raid_emissive_surface)
    || !surface_exists(raid_projectile_emissive_surface)
    || !surface_exists(raid_bloom_blur_surface)
    || !surface_exists(raid_bloom_surface)
    || !surface_exists(raid_projectile_bloom_surface)))) return;

    // Preserve sharp emissive feedback and projectile cores without doing any
    // lighting, shadow, smoke, or post-processing setup when all are disabled.
    if (!_need_darkness_surface && !_need_colored_surface && !raid_bloom_enabled && !_settings.smoke_effects)
    {
        draw_raid_emissives(0, 0, 1, 1, false);
        if (raid.state != RaidState.DEATH)
        {
            draw_raid_bullets();
            draw_raid_enemy_bullets();
        }
        return;
    }

    var _previous_blend_mode = gpu_get_blendmode_ext_sepalpha();
    var _previous_scissor = gpu_get_scissor();
    var _previous_color = draw_get_color();
    var _previous_alpha = draw_get_alpha();
    // Allow the clip edge to be tuned around the border shelves without changing the arena bounds.
    var _clip_offset = max(0, raid_lighting_clip_offset);
    var _clip_left = clamp(floor(raid_room_x1 - _clip_offset - _camera_x), 0, _surface_width);
    var _clip_top = clamp(floor(raid_room_y1 - _clip_offset - _camera_y), 0, _surface_height);
    var _clip_right = clamp(ceil(raid_room_x2 + _clip_offset - _camera_x), 0, _surface_width);
    var _clip_bottom = clamp(ceil(raid_room_y2 + _clip_offset - _camera_y), 0, _surface_height);
    var _top_door_clips = [];
    var _extended_clip_top = _clip_top;
    var _lighting_door_positions = [raid_room_x1 + 140, raid_room_x2 - 140];

    if (array_length(raid_doors) > 0)
    {
        _lighting_door_positions = [];
        for (var _position_index = 0; _position_index < array_length(raid_doors); _position_index++)
        {
            array_push(_lighting_door_positions, raid_doors[_position_index].door_x);
        }
    }

    if (array_length(_lighting_door_positions) > 0)
    {
        var _door_sprite_width = sprite_get_width(spr_door_overlay);
        var _door_sprite_height = sprite_get_height(spr_door_overlay);
        var _door_inner_width = _door_sprite_width - 160;
        var _door_inner_height = _door_sprite_height - 160;
        var _door_scale_x = (raid_room_x2 - raid_room_x1) / _door_inner_width;
        var _door_scale_y = (raid_room_y2 - raid_room_y1) / _door_inner_height;
        var _door_draw_y = raid_room_y1 - ((_door_sprite_height - _door_inner_height) * 0.5 * _door_scale_y);
        var _door_sprite_top = floor(_door_draw_y + sprite_get_bbox_top(spr_door_overlay) * _door_scale_y - _camera_y);
        var _door_visible_width = (sprite_get_bbox_right(spr_door_overlay) - sprite_get_bbox_left(spr_door_overlay) + 1)
            * _door_scale_x / array_length(_lighting_door_positions);

        _extended_clip_top = clamp(_door_sprite_top, 0, _clip_top);
        for (var _door_index = 0; _door_index < array_length(_lighting_door_positions); _door_index++)
        {
            var _door_x = _lighting_door_positions[_door_index];
            array_push(_top_door_clips, {
                left: clamp(floor(_door_x - _door_visible_width * 0.5 - _camera_x), _clip_left, _clip_right),
                right: clamp(ceil(_door_x + _door_visible_width * 0.5 - _camera_x), _clip_left, _clip_right)
            });
        }

        array_sort(_top_door_clips, function(_a, _b) { return _a.left - _b.left; });
        var _merged_door_clips = [];
        for (var _merge_index = 0; _merge_index < array_length(_top_door_clips); _merge_index++)
        {
            var _merge_clip = _top_door_clips[_merge_index];
            var _merged_count = array_length(_merged_door_clips);
            if (_merged_count > 0 && _merge_clip.left <= _merged_door_clips[_merged_count - 1].right)
            {
                _merged_door_clips[_merged_count - 1].right = max(_merged_door_clips[_merged_count - 1].right, _merge_clip.right);
            }
            else array_push(_merged_door_clips, _merge_clip);
        }
        _top_door_clips = _merged_door_clips;
    }

    if (_need_darkness_surface)
    {
        surface_set_target(raid_lighting_surface);
        draw_clear_alpha(c_black, _use_darkness ? clamp(raid_lighting_ambient_alpha, 0, 1) : 0);
        gpu_set_scissor(_clip_left, _clip_top, max(0, _clip_right - _clip_left), max(0, _clip_bottom - _clip_top));

        // Remove darkness through alpha. Shared shadow draws also accumulate
        // their colored illumination in RGB for reuse by the final composite.
        gpu_set_blendmode_ext_sepalpha(bm_zero, bm_one, bm_zero, bm_inv_src_alpha);
        if (_use_darkness) draw_raid_darkness_lights(_camera_x, _camera_y, _surface_width, _surface_height,
            _projectile_lights, _shadow_occluders, _share_shadow_pass);
        for (var _door_darkness_index = 0; _use_darkness && _door_darkness_index < array_length(_top_door_clips); _door_darkness_index++)
        {
            var _door_darkness_clip = _top_door_clips[_door_darkness_index];
            gpu_set_scissor(_door_darkness_clip.left, _extended_clip_top, _door_darkness_clip.right - _door_darkness_clip.left, _clip_top - _extended_clip_top);
            draw_raid_darkness_lights(_camera_x, _camera_y, _surface_width, _surface_height,
                _projectile_lights, _shadow_occluders, _share_shadow_pass);
        }

        gpu_set_scissor(_clip_left, _clip_top, max(0, _clip_right - _clip_left), max(0, _clip_bottom - _clip_top));
        if (_use_darkness) draw_raid_character_light_masks(_camera_x, _camera_y);

        gpu_set_scissor(_previous_scissor.x, _previous_scissor.y, _previous_scissor.w, _previous_scissor.h);
        surface_reset_target();
    }

    if (_need_colored_surface)
    {
        surface_set_target(raid_colored_lighting_surface);
        draw_clear_alpha(c_black, 0);
        gpu_set_scissor(_clip_left, _clip_top, max(0, _clip_right - _clip_left), max(0, _clip_bottom - _clip_top));

        // Store only premultiplied light RGB so the color pass remains independent of the darkness mask.
        gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_one, bm_zero, bm_one);
        if (_use_colored_lighting) draw_raid_colored_lights(_camera_x, _camera_y, _surface_width, _surface_height,
            _projectile_lights, _shadow_occluders, _share_shadow_pass);
        for (var _door_color_index = 0; _use_colored_lighting && _door_color_index < array_length(_top_door_clips); _door_color_index++)
        {
            var _door_color_clip = _top_door_clips[_door_color_index];
            gpu_set_scissor(_door_color_clip.left, _extended_clip_top, _door_color_clip.right - _door_color_clip.left, _clip_top - _extended_clip_top);
            draw_raid_colored_lights(_camera_x, _camera_y, _surface_width, _surface_height,
                _projectile_lights, _shadow_occluders, _share_shadow_pass);
        }

        gpu_set_scissor(_previous_scissor.x, _previous_scissor.y, _previous_scissor.w, _previous_scissor.h);
        surface_reset_target();
    }

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
            raid_bloom_explosion_source_scale,
            false
        );
        surface_reset_target();

        surface_set_target(raid_projectile_emissive_surface);
        draw_clear_alpha(c_black, 0);
        gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
        draw_raid_projectile_emissives(
            _camera_x,
            _camera_y,
            _bloom_scale_x,
            _bloom_scale_y,
            raid_bloom_projectile_source_scale
        );
        surface_reset_target();

        raid_bloom_process_surface(raid_emissive_surface, raid_bloom_surface, raid_bloom_blur_surface,
            raid_bloom_blur_radius, raid_bloom_blur_passes);
        raid_bloom_process_surface(raid_projectile_emissive_surface, raid_projectile_bloom_surface, raid_bloom_blur_surface,
            raid_bloom_projectile_blur_radius, raid_bloom_blur_passes);
    }

    draw_set_color(c_white);
    draw_set_alpha(1);
    if (_use_darkness)
    {
        if (_share_shadow_pass) gpu_set_blendmode_ext_sepalpha(bm_one, bm_inv_src_alpha, bm_zero, bm_one);
        else gpu_set_blendmode(bm_normal);
        draw_surface(raid_lighting_surface, _camera_x, _camera_y);
    }

    // Add the subtle colored illumination without re-drawing the darkness surface.
    gpu_set_blendmode_ext_sepalpha(bm_one, bm_one, bm_zero, bm_one);
    if (_use_colored_lighting) draw_surface(raid_colored_lighting_surface, _camera_x, _camera_y);

    // Light smoke separately so it remains readable in darkness without making it emissive.
    gpu_set_blendmode(bm_normal);
    if (_use_smoke_lighting)
    {
        shader_set(shd_raid_smoke_lighting);
        var _smoke_darkness_sampler = shader_get_sampler_index(shd_raid_smoke_lighting, "u_darkness_texture");
        var _smoke_colored_sampler = shader_get_sampler_index(shd_raid_smoke_lighting, "u_colored_light_texture");
        var _smoke_min_light = shader_get_uniform(shd_raid_smoke_lighting, "u_min_light");
        var _smoke_ambient_darkness = shader_get_uniform(shd_raid_smoke_lighting, "u_ambient_darkness");
        var _smoke_light_response = shader_get_uniform(shd_raid_smoke_lighting, "u_light_response");
        var _smoke_color_strength = shader_get_uniform(shd_raid_smoke_lighting, "u_colored_light_strength");
        var _smoke_alpha_scale = shader_get_uniform(shd_raid_smoke_lighting, "u_alpha_scale");
        texture_set_stage(_smoke_darkness_sampler, surface_get_texture(raid_lighting_surface));
        texture_set_stage(_smoke_colored_sampler, surface_get_texture(raid_colored_lighting_surface));
        shader_set_uniform_f(_smoke_min_light, raid_smoke_min_light);
        shader_set_uniform_f(_smoke_ambient_darkness, _use_darkness ? raid_lighting_ambient_alpha : 0);
        shader_set_uniform_f(_smoke_light_response, raid_smoke_light_response);
        shader_set_uniform_f(_smoke_color_strength, _use_colored_lighting ? raid_smoke_colored_light_strength : 0);
        shader_set_uniform_f(_smoke_alpha_scale, raid_smoke_alpha_scale);
        smoke_draw();
        shader_reset();
    }
    else smoke_draw();

    // Emissives and projectile cores stay above the lit smoke.
    // Keep the original sharp emissive sprites beneath the soft bloom.
    draw_raid_emissives(0, 0, 1, 1, false);

    if (raid_bloom_enabled)
    {
        var _previous_bloom_texfilter = gpu_get_texfilter();
        gpu_set_texfilter(true);
        gpu_set_blendmode_ext_sepalpha(bm_one, bm_one, bm_zero, bm_one);
        draw_raid_bloom_surface(raid_bloom_surface, _camera_x, _camera_y, _surface_width, _surface_height,
            raid_bloom_intensity);
        draw_raid_bloom_surface(raid_projectile_bloom_surface, _camera_x, _camera_y, _surface_width, _surface_height,
            raid_bloom_projectile_intensity);
        gpu_set_texfilter(_previous_bloom_texfilter);
    }

    gpu_set_blendmode(bm_normal);

    // Draw the sharp projectile core normally above its emissive glow.
    if (raid.state != RaidState.DEATH)
    {
        draw_raid_bullets();
        draw_raid_enemy_bullets();
    }

    if (raid_shadow_debug) draw_raid_shadow_debug(_shadow_occluders);

    shader_reset();
    gpu_set_scissor(_previous_scissor.x, _previous_scissor.y, _previous_scissor.w, _previous_scissor.h);
    gpu_set_blendmode_ext_sepalpha(
        _previous_blend_mode[0],
        _previous_blend_mode[1],
        _previous_blend_mode[2],
        _previous_blend_mode[3]
    );
    draw_set_color(_previous_color);
    draw_set_alpha(_previous_alpha);
}

function raid_bloom_process_surface(_source_surface, _output_surface, _temporary_surface, _radius, _passes)
{
    var _blur_texel = shader_get_uniform(shd_raid_bloom_blur, "u_texel_size");
    var _blur_direction = shader_get_uniform(shd_raid_bloom_blur, "u_direction");
    var _blur_radius = shader_get_uniform(shd_raid_bloom_blur, "u_radius");
    var _texel_x = 1 / surface_get_width(_source_surface);
    var _texel_y = 1 / surface_get_height(_source_surface);
    var _previous_texfilter = gpu_get_texfilter();
    gpu_set_texfilter(true);

    for (var _blur_pass = 0; _blur_pass < clamp(_passes, 1, 4); _blur_pass++)
    {
        surface_set_target(_temporary_surface);
        draw_clear_alpha(c_black, 0);
        gpu_set_blendmode_ext_sepalpha(bm_one, bm_zero, bm_one, bm_zero);
        shader_set(shd_raid_bloom_blur);
        shader_set_uniform_f(_blur_texel, _texel_x, _texel_y);
        shader_set_uniform_f(_blur_direction, 1, 0);
        shader_set_uniform_f(_blur_radius, clamp(_radius, 0, 16));
        draw_surface(_blur_pass == 0 ? _source_surface : _output_surface, 0, 0);
        shader_reset();
        surface_reset_target();

        surface_set_target(_output_surface);
        draw_clear_alpha(c_black, 0);
        gpu_set_blendmode_ext_sepalpha(bm_one, bm_zero, bm_one, bm_zero);
        shader_set(shd_raid_bloom_blur);
        shader_set_uniform_f(_blur_texel, _texel_x, _texel_y);
        shader_set_uniform_f(_blur_direction, 0, 1);
        shader_set_uniform_f(_blur_radius, clamp(_radius, 0, 16));
        draw_surface(_temporary_surface, 0, 0);
        shader_reset();
        surface_reset_target();
    }

    gpu_set_texfilter(_previous_texfilter);
}

function draw_raid_bloom_surface(_surface, _x, _y, _width, _height, _intensity)
{
    var _remaining_intensity = clamp(_intensity, 0, 3);
    while (_remaining_intensity > 0)
    {
        var _draw_strength = min(1, _remaining_intensity);
        var _tint = make_color_rgb(255 * _draw_strength, 255 * _draw_strength, 255 * _draw_strength);
        draw_surface_stretched_ext(_surface, _x, _y, _width, _height, _tint, 1);
        _remaining_intensity -= _draw_strength;
    }
}
