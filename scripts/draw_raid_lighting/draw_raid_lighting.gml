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
    var _projectile_lists = [raid_bullets, raid_enemy_bullets];
    var _projectile_light_count = 0;
    var _shadow_occluders = _dynamic_lighting && _use_projected_shadows ? raid_shadow_get_active_occluders() : [];

    // Count only visible lights and limit their combined contribution when projectile counts spike.
    if (_dynamic_lighting) for (var _count_list_index = 0; _count_list_index < array_length(_projectile_lists); _count_list_index++)
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

    if (!_need_darkness_surface) raid_lighting_surface = graphics_settings_release_surface(raid_lighting_surface);
    if (!_need_colored_surface) raid_colored_lighting_surface = graphics_settings_release_surface(raid_colored_lighting_surface);
    if (!raid_bloom_enabled)
    {
        raid_emissive_surface = graphics_settings_release_surface(raid_emissive_surface);
        raid_bloom_blur_surface = graphics_settings_release_surface(raid_bloom_blur_surface);
        raid_bloom_surface = graphics_settings_release_surface(raid_bloom_surface);
    }

    if ((_need_darkness_surface && !surface_exists(raid_lighting_surface))
    || (_need_colored_surface && !surface_exists(raid_colored_lighting_surface))
    || (raid_bloom_enabled && (!surface_exists(raid_emissive_surface)
    || !surface_exists(raid_bloom_blur_surface)
    || !surface_exists(raid_bloom_surface)))) return;

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

        // Keep the darkness color and remove only its alpha beneath each light.
        gpu_set_blendmode_ext_sepalpha(bm_zero, bm_one, bm_zero, bm_inv_src_alpha);
        if (_use_darkness) draw_raid_darkness_lights(_camera_x, _camera_y, _surface_width, _surface_height, _projectile_lists, _projectile_light_scale, _shadow_occluders);
        for (var _door_darkness_index = 0; _use_darkness && _door_darkness_index < array_length(_top_door_clips); _door_darkness_index++)
        {
            var _door_darkness_clip = _top_door_clips[_door_darkness_index];
            gpu_set_scissor(_door_darkness_clip.left, _extended_clip_top, _door_darkness_clip.right - _door_darkness_clip.left, _clip_top - _extended_clip_top);
            draw_raid_darkness_lights(_camera_x, _camera_y, _surface_width, _surface_height, _projectile_lists, _projectile_light_scale, _shadow_occluders);
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
        if (_use_colored_lighting) draw_raid_colored_lights(_camera_x, _camera_y, _surface_width, _surface_height, _projectile_lists, _projectile_light_scale, _shadow_occluders);
        for (var _door_color_index = 0; _use_colored_lighting && _door_color_index < array_length(_top_door_clips); _door_color_index++)
        {
            var _door_color_clip = _top_door_clips[_door_color_index];
            gpu_set_scissor(_door_color_clip.left, _extended_clip_top, _door_color_clip.right - _door_color_clip.left, _clip_top - _extended_clip_top);
            draw_raid_colored_lights(_camera_x, _camera_y, _surface_width, _surface_height, _projectile_lists, _projectile_light_scale, _shadow_occluders);
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
    if (_use_darkness) draw_surface(raid_lighting_surface, _camera_x, _camera_y);

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

function draw_raid_character_light_masks(_camera_x, _camera_y)
{
    var _settings = global.graphics_settings;
    var _player_minimum = clamp(_settings.player_minimum_brightness, 0, 1);
    var _enemy_minimum = clamp(_settings.enemy_minimum_brightness, 0, 1);
    var _ambient_illumination = 1 - clamp(raid_lighting_ambient_alpha, 0, 1);
    if (_player_minimum <= _ambient_illumination && _enemy_minimum <= _ambient_illumination) return;

    var _previous_world_matrix = matrix_get(matrix_world);
    matrix_set(matrix_world, matrix_build(-_camera_x, -_camera_y, 0, 0, 0, 0, 1, 1, 1));
    gpu_set_blendmode_ext_sepalpha(bm_zero, bm_one, bm_one, bm_one);
    gpu_set_blendequation_sepalpha(bm_eq_add, bm_eq_min);
    shader_set(shd_raid_character_light_mask);
    var _minimum_uniform = shader_get_uniform(shd_raid_character_light_mask, "u_minimum_brightness");

    if (_player_minimum > _ambient_illumination)
    {
        shader_set_uniform_f(_minimum_uniform, _player_minimum);
        draw_raid_player(true, 1);
        if (raid.state != RaidState.DEATH) draw_raid_gun(true, 1);
    }

    if (raid.state != RaidState.DEATH && _enemy_minimum > _ambient_illumination)
    {
        shader_set_uniform_f(_minimum_uniform, _enemy_minimum);
        draw_raid_enemies(true, 1);
    }

    shader_reset();
    gpu_set_blendequation_sepalpha(bm_eq_add, bm_eq_add);
    matrix_set(matrix_world, _previous_world_matrix);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

function draw_raid_character_shadows()
{
    if (!global.graphics_settings.contact_shadows || !raid_character_shadows_enabled) return;

    // These are contact shadows only. Projected character shadows are produced
    // by the same light-occlusion renderer used for environmental casters.
    if (raid.state == RaidState.DEATH)
    {
        if (raid_player_death_phase <= 1)
        {
            var _death_sprite = raid_player_death_sprite;
            var _death_scale = raid_player_death_scale;
            var _death_feet_x = raid_player_death_x + (
                (sprite_get_bbox_left(_death_sprite) + sprite_get_bbox_right(_death_sprite)) * 0.5
                - sprite_get_xoffset(_death_sprite)
            ) * raid_player_death_facing * _death_scale;
            var _death_feet_y = raid_player_death_y + (
                sprite_get_bbox_bottom(_death_sprite) - sprite_get_yoffset(_death_sprite)
            ) * _death_scale;
            draw_raid_character_shadow(
                _death_feet_x,
                _death_feet_y,
                _death_scale,
                1.5
            );
        }
        return;
    }

    var _player_sprite = raid_player_moving ? spr_player_run : spr_player_idle;
    var _player_shadow_x = round(raid_player_x + (
        (sprite_get_bbox_left(_player_sprite) + sprite_get_bbox_right(_player_sprite)) * 0.5
        - sprite_get_xoffset(_player_sprite)
    ) * raid_player_facing);
    draw_raid_character_shadow(
        _player_shadow_x,
        round(raid_player_y) - 1,
        1,
        1.5
    );

    for (var _enemy_index = 0; _enemy_index < array_length(raid_enemies); _enemy_index++)
    {
        var _enemy = raid_enemies[_enemy_index];
        var _enemy_bbox = raid_enemy_get_collision_bbox(_enemy);
            draw_raid_character_shadow(
                (_enemy_bbox.left + _enemy_bbox.right) * 0.5,
                _enemy_bbox.bottom,
                _enemy.size_multiplier,
                1.5
            );
    }
}

function draw_raid_character_shadow(_feet_x, _feet_y, _size_scale = 1, _opacity_scale = 1)
{
    var _shadow_sprite = spr_character_shadow;
    var _size = max(0, raid_character_shadow_size * _size_scale);
    var _opacity = clamp(raid_character_shadow_opacity * _opacity_scale, 0, 1);
    if (_size <= 0 || _opacity <= 0) return;

    gpu_set_blendmode(bm_normal);
    draw_sprite_ext(
        _shadow_sprite,
        0,
        _feet_x,
        _feet_y,
        _size / sprite_get_width(_shadow_sprite),
        (_size * 0.3) / sprite_get_height(_shadow_sprite),
        0,
        c_black,
        _opacity
    );
}

function draw_raid_darkness_lights(_camera_x, _camera_y, _surface_width, _surface_height, _projectile_lists, _projectile_light_scale, _shadow_occluders)
{
    draw_raid_radial_light(
        raid_player_x - _camera_x,
        raid_player_y + raid_player_light_offset_y - _camera_y,
        raid_player_light_radius,
        raid_player_light_strength,
        raid_player_light_color
    );

    draw_raid_loot_halos(_camera_x, _camera_y, _surface_width, _surface_height);

    for (var _enemy_light_index = 0; _enemy_light_index < array_length(raid_enemies); _enemy_light_index++)
    {
        var _enemy_light = raid_enemies[_enemy_light_index];
        var _enemy_light_scale = _enemy_light.size_multiplier;
        draw_raid_radial_light(
            _enemy_light.enemy_x - _camera_x,
            _enemy_light.enemy_y + raid_player_light_offset_y * _enemy_light_scale - _camera_y,
            raid_player_light_radius * _enemy_light_scale,
            raid_enemy_light_strength,
            raid_player_light_color
        );
    }

    for (var _light_index = 0; _light_index < array_length(raid_light_sources); _light_index++)
    {
        var _light = raid_light_sources[_light_index];
        if (variable_struct_exists(_light, "enabled") && !_light.enabled) continue;

        var _intensity = variable_struct_exists(_light, "intensity") ? _light.intensity : _light.strength;
        var _color = variable_struct_exists(_light, "color") ? _light.color : c_white;
        var _falloff_rotation = variable_struct_exists(_light, "falloff_rotation") ? _light.falloff_rotation : 0;
        var _falloff_x_scale = variable_struct_exists(_light, "falloff_x_scale") ? _light.falloff_x_scale : 1;
        var _falloff_y_scale = variable_struct_exists(_light, "falloff_y_scale") ? _light.falloff_y_scale : 1;
        var _falloff_offset = variable_struct_exists(_light, "falloff_offset") ? _light.falloff_offset : 0;
        var _inward_reach_multiplier = variable_struct_exists(_light, "inward_reach_multiplier") ? _light.inward_reach_multiplier : 1;
        var _inward_center_offset = _falloff_offset + _falloff_x_scale * (_inward_reach_multiplier - 1);
        if (variable_struct_exists(_light, "casts_shadows") && _light.casts_shadows
        && array_length(_shadow_occluders) > 0)
        {
            draw_raid_shadowed_radial_light(_light, _shadow_occluders, _camera_x, _camera_y, _intensity, _color);
        }
        else draw_raid_radial_light(
            _light.x + lengthdir_x(_light.radius * _inward_center_offset, _falloff_rotation) - _camera_x,
            _light.y + lengthdir_y(_light.radius * _inward_center_offset, _falloff_rotation) - _camera_y,
            _light.radius, _intensity, _color, _falloff_rotation, _falloff_x_scale * _inward_reach_multiplier, _falloff_y_scale,
            32, variable_struct_exists(_light, "soft_falloff") && _light.soft_falloff
        );
        draw_raid_light_core(_light, _camera_x, _camera_y);
    }

    for (var _temporary_index = 0; _temporary_index < array_length(raid_temporary_lights); _temporary_index++)
    {
        var _temporary_light = raid_temporary_lights[_temporary_index];
        draw_raid_temporary_light(_temporary_light, _shadow_occluders, _camera_x, _camera_y);
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
}

function draw_raid_colored_lights(_camera_x, _camera_y, _surface_width, _surface_height, _projectile_lists, _projectile_light_scale, _shadow_occluders)
{
    draw_raid_radial_light(
        raid_player_x - _camera_x,
        raid_player_y + raid_player_light_offset_y - _camera_y,
        raid_player_light_radius,
        raid_player_light_strength * raid_colored_light_strength,
        raid_player_light_color
    );

    draw_raid_loot_halos(_camera_x, _camera_y, _surface_width, _surface_height, raid_colored_light_strength);

    for (var _enemy_color_light_index = 0; _enemy_color_light_index < array_length(raid_enemies); _enemy_color_light_index++)
    {
        var _enemy_color_light = raid_enemies[_enemy_color_light_index];
        var _enemy_color_light_scale = _enemy_color_light.size_multiplier;
        draw_raid_radial_light(
            _enemy_color_light.enemy_x - _camera_x,
            _enemy_color_light.enemy_y + raid_player_light_offset_y * _enemy_color_light_scale - _camera_y,
            raid_player_light_radius * _enemy_color_light_scale,
            raid_enemy_light_strength * raid_colored_light_strength,
            raid_player_light_color
        );
    }

    for (var _color_index = 0; _color_index < array_length(raid_light_sources); _color_index++)
    {
        var _color_light = raid_light_sources[_color_index];
        if (variable_struct_exists(_color_light, "enabled") && !_color_light.enabled) continue;

        var _color_intensity = variable_struct_exists(_color_light, "intensity") ? _color_light.intensity : _color_light.strength;
        var _light_color = variable_struct_exists(_color_light, "color") ? _color_light.color : c_white;
        var _color_falloff_rotation = variable_struct_exists(_color_light, "falloff_rotation") ? _color_light.falloff_rotation : 0;
        var _color_falloff_x_scale = variable_struct_exists(_color_light, "falloff_x_scale") ? _color_light.falloff_x_scale : 1;
        var _color_falloff_y_scale = variable_struct_exists(_color_light, "falloff_y_scale") ? _color_light.falloff_y_scale : 1;
        var _color_falloff_offset = variable_struct_exists(_color_light, "falloff_offset") ? _color_light.falloff_offset : 0;
        var _color_inward_reach_multiplier = variable_struct_exists(_color_light, "inward_reach_multiplier") ? _color_light.inward_reach_multiplier : 1;
        var _color_inward_center_offset = _color_falloff_offset + _color_falloff_x_scale * (_color_inward_reach_multiplier - 1);
        if (variable_struct_exists(_color_light, "casts_shadows") && _color_light.casts_shadows
        && array_length(_shadow_occluders) > 0)
        {
            draw_raid_shadowed_radial_light(
                _color_light,
                _shadow_occluders,
                _camera_x,
                _camera_y,
                _color_intensity * raid_colored_light_strength,
                _light_color
            );
        }
        else draw_raid_radial_light(
            _color_light.x + lengthdir_x(_color_light.radius * _color_inward_center_offset, _color_falloff_rotation) - _camera_x,
            _color_light.y + lengthdir_y(_color_light.radius * _color_inward_center_offset, _color_falloff_rotation) - _camera_y,
            _color_light.radius, _color_intensity * raid_colored_light_strength, _light_color,
            _color_falloff_rotation, _color_falloff_x_scale * _color_inward_reach_multiplier, _color_falloff_y_scale,
            32, variable_struct_exists(_color_light, "soft_falloff") && _color_light.soft_falloff
        );
        draw_raid_light_core(_color_light, _camera_x, _camera_y, raid_colored_light_strength);
    }

    for (var _temporary_color_index = 0; _temporary_color_index < array_length(raid_temporary_lights); _temporary_color_index++)
    {
        var _temporary_color_light = raid_temporary_lights[_temporary_color_index];
        draw_raid_temporary_light(_temporary_color_light, _shadow_occluders, _camera_x, _camera_y, raid_colored_light_strength);
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
}

function draw_raid_emissives(_camera_x, _camera_y, _scale_x, _scale_y, _include_explosions = true, _wall_light_source_scale = 1, _projectile_source_scale = 1, _muzzle_flash_source_scale = 1, _explosion_source_scale = 1)
{
    draw_raid_wall_lights(true, _camera_x, _camera_y, _scale_x, _scale_y, _wall_light_source_scale);

    if (raid.state == RaidState.DEATH) return;

    var _projectile_lists = [raid_bullets, raid_enemy_bullets];
    if (!_include_explosions) gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_one, bm_zero, bm_one);

    if (global.graphics_settings.projectile_glow) for (var _list_index = 0; _list_index < array_length(_projectile_lists); _list_index++)
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

function raid_shadow_occluder_rectangle(_x, _y, _width, _depth, _height, _rotation = 0, _enabled = true)
{
    return {
        geometry: {
            type: "rectangle",
            width: max(0, _width),
            depth: max(0, _depth)
        },
        position: {x: _x, y: _y},
        height: max(0, _height),
        rotation: _rotation,
        enabled: _enabled
    };
}

function raid_shadow_get_silhouette_data(_sprite, _subimage)
{
    var _frame_count = max(1, sprite_get_number(_sprite));
    var _frame = floor(_subimage) mod _frame_count;
    if (_frame < 0) _frame += _frame_count;
    var _cache_key = "sprite_" + string(_sprite) + "_frame_" + string(_frame);
    if (variable_struct_exists(raid_shadow_silhouette_cache, _cache_key))
        return variable_struct_get(raid_shadow_silhouette_cache, _cache_key);

    var _uvs = sprite_get_uvs(_sprite, _frame);
    var _sprite_width = max(1, sprite_get_width(_sprite));
    var _sprite_height = max(1, sprite_get_height(_sprite));
    // Texture-page UVs already describe the alpha-trimmed frame. The remaining
    // values locate that crop in the original sprite canvas without involving
    // the sprite's collision mask.
    var _crop_left = _uvs[4];
    var _crop_top = _uvs[5];
    var _crop_width = max(1, round(_sprite_width * _uvs[6]));
    var _crop_height = max(1, round(_sprite_height * _uvs[7]));
    var _data = {
        sprite_index: _sprite,
        image_index: _frame,
        crop_left: _crop_left,
        crop_top: _crop_top,
        crop_right: _crop_left + _crop_width,
        crop_bottom: _crop_top + _crop_height,
        crop_width: _crop_width,
        crop_height: _crop_height,
        uv_left: _uvs[0],
        uv_top: _uvs[1],
        uv_right: _uvs[2],
        uv_bottom: _uvs[3],
        texture: sprite_get_texture(_sprite, _frame)
    };
    variable_struct_set(raid_shadow_silhouette_cache, _cache_key, _data);
    return _data;
}

function raid_shadow_occluder_sprite(_sprite, _subimage, _x, _y, _xscale = 1, _yscale = 1, _rotation = 0, _height_override = undefined, _ground_x_override = undefined, _ground_y_override = undefined, _ground_offset_x = 0, _ground_offset_y = 0, _enabled = true)
{
    var _silhouette = raid_shadow_get_silhouette_data(_sprite, _subimage);
    var _visible_width = max(0.001, _silhouette.crop_width * abs(_xscale));
    var _visible_height = max(0.001, _silhouette.crop_height * abs(_yscale));
    var _local_ground_x = ((_silhouette.crop_left + _silhouette.crop_right) * 0.5 - sprite_get_xoffset(_sprite)) * _xscale;
    var _ground_source_y = _yscale < 0 ? _silhouette.crop_top : _silhouette.crop_bottom;
    var _local_ground_y = (_ground_source_y - sprite_get_yoffset(_sprite)) * _yscale;
    var _ground_distance = point_distance(0, 0, _local_ground_x, _local_ground_y);
    var _ground_direction = point_direction(0, 0, _local_ground_x, _local_ground_y) + _rotation;
    var _ground_x = (is_undefined(_ground_x_override) ? _x + lengthdir_x(_ground_distance, _ground_direction) : _ground_x_override) + _ground_offset_x;
    var _ground_y = (is_undefined(_ground_y_override) ? _y + lengthdir_y(_ground_distance, _ground_direction) : _ground_y_override) + _ground_offset_y;

    return {
        geometry: {
            type: "sprite",
            width: _visible_width,
            silhouette: _silhouette
        },
        position: {x: _ground_x, y: _ground_y},
        height: is_undefined(_height_override) ? _visible_height : max(0.001, _height_override),
        rotation: _rotation,
        flip_x: _xscale < 0,
        flip_y: _yscale < 0,
        enabled: _enabled,
        draw_sprite: _sprite,
        draw_subimage: _subimage,
        draw_x: _x,
        draw_y: _y,
        draw_xscale: _xscale,
        draw_yscale: _yscale,
        source_position: {
            x: _x
                + lengthdir_x(((_silhouette.crop_left + _silhouette.crop_right) * 0.5 - sprite_get_xoffset(_sprite)) * _xscale, _rotation)
                + lengthdir_x(((_silhouette.crop_top + _silhouette.crop_bottom) * 0.5 - sprite_get_yoffset(_sprite)) * _yscale, _rotation - 90),
            y: _y
                + lengthdir_y(((_silhouette.crop_left + _silhouette.crop_right) * 0.5 - sprite_get_xoffset(_sprite)) * _xscale, _rotation)
                + lengthdir_y(((_silhouette.crop_top + _silhouette.crop_bottom) * 0.5 - sprite_get_yoffset(_sprite)) * _yscale, _rotation - 90)
        },
        source_size: {width: _visible_width, height: _visible_height},
        exclude_source_from_shadow: false
    };
}

function raid_shadow_get_active_occluders()
{
    var _active = [];
    var _character_accessories = [];
    if (global.graphics_settings.environment_shadows)
    {
        _active = raid_shadow_get_arena_wall_occluders();
        for (var _static_index = 0; _static_index < array_length(raid_shadow_occluders); _static_index++)
            array_push(_active, raid_shadow_occluders[_static_index]);
    }

    // Character arrays are the dynamic registration source. Their current body
    // sprite, frame, position, scale, and facing are rebuilt for every draw;
    // deleting an enemy from raid_enemies unregisters it immediately.
    if (global.graphics_settings.character_shadows && raid.state == RaidState.DEATH)
    {
        if (raid_player_death_phase <= 1 && raid_player_death_sprite >= 0 && sprite_exists(raid_player_death_sprite))
        {
            var _death_caster = raid_shadow_occluder_sprite(
                raid_player_death_sprite,
                raid_player_death_frame,
                raid_player_death_x,
                raid_player_death_y,
                raid_player_death_facing * raid_player_death_scale,
                raid_player_death_scale
            );
            _death_caster.character_caster = true;
            _death_caster.exclude_source_from_shadow = true;
            array_push(_active, _death_caster);
        }
    }
    else if (global.graphics_settings.character_shadows)
    {
        var _player_sprite = raid_player_moving ? spr_player_run : spr_player_idle;
        var _player_caster = raid_shadow_occluder_sprite(
            _player_sprite,
            floor(raid_player_anim_frame),
            raid_player_x,
            raid_player_y,
            raid_player_facing,
            1
        );
        _player_caster.character_caster = true;
        _player_caster.player_shadow_body = true;
        _player_caster.exclude_source_from_shadow = true;
        array_push(_active, _player_caster);
        _character_accessories = raid_shadow_get_player_accessory_occluders(
            _player_caster.position.x,
            _player_caster.position.y
        );

        for (var _enemy_index = 0; _enemy_index < array_length(raid_enemies); _enemy_index++)
        {
            var _enemy = raid_enemies[_enemy_index];
            if (!is_struct(_enemy) || _enemy.enemy_sprite < 0 || !sprite_exists(_enemy.enemy_sprite)) continue;

            var _enemy_bbox_height = sprite_get_bbox_bottom(_enemy.enemy_sprite)
                - sprite_get_bbox_top(_enemy.enemy_sprite) + 1;
            var _enemy_draw_scale = 0.75 * (40 / max(1, _enemy_bbox_height)) * _enemy.size_multiplier;
            var _enemy_caster = raid_shadow_occluder_sprite(
                _enemy.enemy_sprite,
                floor(_enemy.enemy_frame),
                _enemy.enemy_x,
                _enemy.enemy_y,
                _enemy.enemy_facing * _enemy_draw_scale,
                _enemy_draw_scale
            );
            _enemy_caster.character_caster = true;
            _enemy_caster.exclude_source_from_shadow = true;
            array_push(_active, _enemy_caster);

            var _enemy_accessories = raid_shadow_get_enemy_accessory_occluders(_enemy);
            for (var _accessory_index = 0; _accessory_index < array_length(_enemy_accessories); _accessory_index++)
                array_push(_character_accessories, _enemy_accessories[_accessory_index]);
        }

        // Bodies stay ahead of accessories so a crowded room never loses its
        // existing body shadows when the shader reaches its caster limit.
        for (var _character_accessory_index = 0; _character_accessory_index < array_length(_character_accessories); _character_accessory_index++)
            array_push(_active, _character_accessories[_character_accessory_index]);
    }

    // Loot structs are the registration source, so clearing or replacing the
    // active room's loot array also unregisters its casters immediately.
    if (global.graphics_settings.environment_shadows) for (var _loot_index = 0; _loot_index < array_length(raid_lootables); _loot_index++)
    {
        var _lootable = raid_lootables[_loot_index];
        if (!variable_struct_exists(_lootable, "sprite_index") || _lootable.sprite_index < 0) continue;
        if (variable_struct_exists(_lootable, "shadow_enabled") && !_lootable.shadow_enabled) continue;

        var _lootable_caster = raid_shadow_occluder_sprite(
            _lootable.sprite_index,
            variable_struct_exists(_lootable, "image_index") ? _lootable.image_index : 0,
            variable_struct_exists(_lootable, "sprite_x") ? _lootable.sprite_x : _lootable.lootable_x,
            variable_struct_exists(_lootable, "sprite_y") ? _lootable.sprite_y : _lootable.lootable_y,
            variable_struct_exists(_lootable, "image_xscale") ? _lootable.image_xscale : 1,
            variable_struct_exists(_lootable, "image_yscale") ? _lootable.image_yscale : 1,
            variable_struct_exists(_lootable, "image_angle") ? _lootable.image_angle : 0,
            variable_struct_exists(_lootable, "shadow_height") ? _lootable.shadow_height : undefined,
            variable_struct_exists(_lootable, "shadow_ground_x") ? _lootable.shadow_ground_x : undefined,
            variable_struct_exists(_lootable, "shadow_ground_y") ? _lootable.shadow_ground_y : undefined,
            variable_struct_exists(_lootable, "shadow_offset_x") ? _lootable.shadow_offset_x : 0,
            variable_struct_exists(_lootable, "shadow_offset_y") ? _lootable.shadow_offset_y : 0
        );
        _lootable_caster.exclude_source_from_shadow = true;
        array_push(_active, _lootable_caster);
    }
    return _active;
}

function raid_shadow_character_accessory(_sprite, _x, _y, _xscale, _yscale, _rotation, _feet_x = undefined, _feet_y = undefined, _extra_offset_scale = 1)
{
    var _caster = raid_shadow_occluder_sprite(_sprite, 0, round(_x), round(_y), _xscale, _yscale, _rotation);
    if (!is_undefined(_feet_x) && !is_undefined(_feet_y))
    {
        var _height_scale = clamp(_extra_offset_scale, 0.001, 1);
        var _source_axis_y = lengthdir_y(1, _rotation);
        var _source_normal_y = lengthdir_y(1, _rotation + 90);
        var _source_top_y = _caster.source_position.y
            - abs(_source_axis_y) * _caster.source_size.width * 0.5
            - abs(_source_normal_y) * _caster.source_size.height * 0.5;
        _caster.position.x = _feet_x;
        _caster.position.y = _feet_y;
        _caster.height = max(0.001, (_feet_y - _source_top_y) * _height_scale);
        _caster.projection_rotation = 0;
        _caster.shared_anchor_projection = true;
        _caster.projection_height_scale = _height_scale;
    }
    _caster.character_caster = true;
    _caster.exclude_source_from_shadow = true;
    return _caster;
}

function raid_shadow_get_player_accessory_occluders(_feet_x, _feet_y)
{
    var _accessories = [];
    var _weapon = raid_update_active_weapon();
    if (raid_gun_tuning_active) _weapon = item_get(raid_gun_tuning_weapon_key);

    if (!is_struct(_weapon))
    {
        var _knife_raise = 90 * raid_player_facing;
        var _knife_dir = raid_aim_dir + _knife_raise;
        var _hand_dir = raid_aim_dir;
        var _stab_distance = 0;
        if (raid_knife_attack_timer > 0)
        {
            var _progress = 1 - (raid_knife_attack_timer / raid_knife_attack_time);
            _hand_dir = raid_knife_attack_dir;
            if (_progress < 0.5) _stab_distance = clamp((_progress - 0.25) / 0.25, 0, 1) * 42;
            else if (_progress < 0.625) _stab_distance = 42;
            else _stab_distance = clamp(1 - ((_progress - 0.625) / 0.375), 0, 1) * 42;

            if (_progress < 0.625) _knife_dir = raid_knife_attack_dir + _knife_raise - (_knife_raise * min(1, _progress / 0.25));
            else _knife_dir = raid_knife_attack_dir + (_knife_raise * ((_progress - 0.625) / 0.375));
        }

        var _hand_x = raid_player_x + lengthdir_x(12, _hand_dir) + lengthdir_x(_stab_distance, _knife_dir);
        var _hand_y = raid_player_y - 10 + lengthdir_y(12, _hand_dir) + lengthdir_y(_stab_distance, _knife_dir);
        array_push(_accessories, raid_shadow_character_accessory(
            spr_hand, _hand_x, _hand_y, 1, 1, _knife_dir,
            _feet_x, _feet_y, raid_shadow_hand_extra_offset_scale
        ));
        return _accessories;
    }

    if (_weapon.weapon_sprite < 0 || !sprite_exists(_weapon.weapon_sprite)) return _accessories;
    var _tuning = raid_gun_tuning_get(raid_gun_tuning_weapon_key, _weapon);
    var _dir = raid_aim_dir + _tuning.weapon_angle_offset;
    var _flip_y = (_dir > 90 && _dir < 270) ? -1 : 1;
    var _weapon_offset_x = variable_struct_exists(_weapon, "weapon_offset_x") ? _weapon.weapon_offset_x : _tuning.weapon_offset_x;
    var _gun_x = raid_player_x
        + lengthdir_x(_weapon_offset_x - raid_gun_recoil, _dir)
        + lengthdir_x(_tuning.weapon_offset_y, _dir + 90);
    var _gun_y = raid_player_y - 10
        + lengthdir_y(_weapon_offset_x - raid_gun_recoil, _dir)
        + lengthdir_y(_tuning.weapon_offset_y, _dir + 90);
    var _visible_width = max(1, sprite_get_bbox_right(_weapon.weapon_sprite) - sprite_get_bbox_left(_weapon.weapon_sprite) + 1);
    var _weapon_scale = _tuning.weapon_draw_width / _visible_width;
    array_push(_accessories, raid_shadow_character_accessory(
        _weapon.weapon_sprite, _gun_x, _gun_y, _weapon_scale, _weapon_scale * _flip_y, _dir,
        _feet_x, _feet_y, raid_shadow_gun_extra_offset_scale
    ));

    var _hand1_x = _gun_x + lengthdir_x(_tuning.hand1_offset_x, _dir) + lengthdir_x(_tuning.hand1_offset_y * _flip_y, _dir + 90);
    var _hand1_y = _gun_y + lengthdir_y(_tuning.hand1_offset_x, _dir) + lengthdir_y(_tuning.hand1_offset_y * _flip_y, _dir + 90);
    array_push(_accessories, raid_shadow_character_accessory(
        spr_hand, _hand1_x, _hand1_y, 1, _flip_y, _dir,
        _feet_x, _feet_y, raid_shadow_hand_extra_offset_scale
    ));

    if (_weapon.has_second_hand)
    {
        var _hand2_x = _gun_x + lengthdir_x(_tuning.hand2_offset_x, _dir) + lengthdir_x(_tuning.hand2_offset_y * _flip_y, _dir + 90);
        var _hand2_y = _gun_y + lengthdir_y(_tuning.hand2_offset_x, _dir) + lengthdir_y(_tuning.hand2_offset_y * _flip_y, _dir + 90);
        array_push(_accessories, raid_shadow_character_accessory(
            spr_hand, _hand2_x, _hand2_y, 1, _flip_y, _dir,
            _feet_x, _feet_y, raid_shadow_hand_extra_offset_scale
        ));
    }
    return _accessories;
}

function raid_shadow_get_enemy_accessory_occluders(_enemy)
{
    var _accessories = [];
    if (_enemy.weapon == -1 || is_undefined(_enemy.weapon) || !is_struct(_enemy.weapon)) return _accessories;
    var _weapon = _enemy.weapon;
    if (_weapon.weapon_sprite < 0 || !sprite_exists(_weapon.weapon_sprite)) return _accessories;

    var _scale = variable_struct_exists(_enemy, "size_multiplier") ? _enemy.size_multiplier : 1;
    var _dir = _enemy.enemy_gun_angle;
    var _flip = (_dir > 90 && _dir < 270) ? -1 : 1;
    var _weapon_offset_y = variable_struct_exists(_weapon, "weapon_offset_y") ? _weapon.weapon_offset_y * _scale * _flip : 0;
    var _offset = _enemy.enemy_gun_recoil + (_weapon.weapon_offset_x * _scale);
    var _gun_x = _enemy.enemy_x + lengthdir_x(_offset, _dir) + lengthdir_x(_weapon_offset_y, _dir + 90);
    var _gun_y = _enemy.enemy_y - (18 * _scale) + lengthdir_y(_offset, _dir);
    var _visible_width = max(1, sprite_get_bbox_right(_weapon.weapon_sprite) - sprite_get_bbox_left(_weapon.weapon_sprite) + 1);
    var _weapon_scale = (_weapon.weapon_draw_width / _visible_width) * 0.75 * _scale;
    array_push(_accessories, raid_shadow_character_accessory(
        _weapon.weapon_sprite, _gun_x, _gun_y, _weapon_scale, _weapon_scale * _flip, _dir
    ));

    if (_enemy.enemy_hand_sprite != -1 && sprite_exists(_enemy.enemy_hand_sprite))
    {
        var _hand1_x = _gun_x + lengthdir_x(_weapon.hand1_x * _scale, _dir) + lengthdir_x(_weapon.hand1_y * _scale * _flip, _dir + 90);
        var _hand1_y = _gun_y + lengthdir_y(_weapon.hand1_x * _scale, _dir) + lengthdir_y(_weapon.hand1_y * _scale * _flip, _dir + 90);
        array_push(_accessories, raid_shadow_character_accessory(_enemy.enemy_hand_sprite, _hand1_x, _hand1_y, _scale, _scale * _flip, _dir));

        if (_weapon.has_second_hand)
        {
            var _hand2_x = _gun_x + lengthdir_x(_weapon.hand2_x * _scale, _dir) + lengthdir_x(_weapon.hand2_y * _scale * _flip, _dir + 90);
            var _hand2_y = _gun_y + lengthdir_y(_weapon.hand2_x * _scale, _dir) + lengthdir_y(_weapon.hand2_y * _scale * _flip, _dir + 90);
            array_push(_accessories, raid_shadow_character_accessory(_enemy.enemy_hand_sprite, _hand2_x, _hand2_y, _scale, _scale * _flip, _dir));
        }
    }
    return _accessories;
}

function draw_raid_shadowed_radial_light(_light, _occluders, _camera_x, _camera_y, _strength, _color, _debug_visibility = false)
{
    var _falloff_rotation = variable_struct_exists(_light, "falloff_rotation") ? _light.falloff_rotation : 0;
    var _falloff_x_scale = variable_struct_exists(_light, "falloff_x_scale") ? _light.falloff_x_scale : 1;
    var _falloff_y_scale = variable_struct_exists(_light, "falloff_y_scale") ? _light.falloff_y_scale : 1;
    var _falloff_offset = variable_struct_exists(_light, "falloff_offset") ? _light.falloff_offset : 0;
    var _inward_reach_multiplier = variable_struct_exists(_light, "inward_reach_multiplier") ? _light.inward_reach_multiplier : 1;
    var _inward_center_offset = _falloff_offset + _falloff_x_scale * (_inward_reach_multiplier - 1);
    var _draw_x = _light.x + lengthdir_x(_light.radius * _inward_center_offset, _falloff_rotation) - _camera_x;
    var _draw_y = _light.y + lengthdir_y(_light.radius * _inward_center_offset, _falloff_rotation) - _camera_y;
    _falloff_x_scale *= _inward_reach_multiplier;

    // Avoid all occluder packing, uniform uploads, and shader work when this
    // light cannot touch the current surface/scissor region.
    if (!raid_radial_light_is_visible(_draw_x, _draw_y, _light.radius, _falloff_x_scale, _falloff_y_scale)) return;

    var _rectangle_positions = array_create(32, 0);
    var _rectangle_half_sizes = array_create(32, 0);
    var _rectangle_heights = array_create(16, 0);
    var _rectangle_rotations = array_create(16, 0);
    var _sprite_ground_positions = array_create(48, 0);
    var _sprite_axes = array_create(48, 0);
    var _sprite_sizes = array_create(48, 1);
    var _sprite_source_positions = array_create(48, 0);
    var _sprite_source_sizes = array_create(48, 1);
    var _sprite_source_exclusions = array_create(24, 0);
    var _sprite_uvs = array_create(96, 0);
    var _sprite_flips = array_create(24, 0);
    var _sprite_flip_ys = array_create(24, 0);
    var _sprite_source_axes = array_create(48, 0);
    var _sprite_shared_anchor_projections = array_create(24, 0);
    var _sprite_projection_height_scales = array_create(24, 1);
    var _sprite_texture_indices = array_create(24, 0);
    var _sprite_textures = [];
    var _rectangle_count = 0;
    var _sprite_count = 0;
    var _cull_occluders = variable_struct_exists(_light, "muzzle_flash") && _light.muzzle_flash;

    for (var _occluder_index = 0; _occluder_index < array_length(_occluders); _occluder_index++)
    {
        var _occluder = _occluders[_occluder_index];
        if (!_occluder.enabled) continue;

        if (_cull_occluders)
        {
            var _occluder_reach = _occluder.geometry.type == "rectangle"
                ? point_distance(0, 0, _occluder.geometry.width * 0.5, _occluder.geometry.depth * 0.5)
                : _occluder.geometry.width * 0.5;
            if (point_distance(_light.x, _light.y, _occluder.position.x, _occluder.position.y) > _light.radius + _occluder_reach) continue;
        }

        if (_occluder.geometry.type == "rectangle" && _rectangle_count < 16)
        {
            var _rectangle_offset = _rectangle_count * 2;
            _rectangle_positions[_rectangle_offset] = _occluder.position.x - _camera_x;
            _rectangle_positions[_rectangle_offset + 1] = _occluder.position.y - _camera_y;
            _rectangle_half_sizes[_rectangle_offset] = _occluder.geometry.width * 0.5;
            _rectangle_half_sizes[_rectangle_offset + 1] = _occluder.geometry.depth * 0.5;
            _rectangle_heights[_rectangle_count] = _occluder.height;
            _rectangle_rotations[_rectangle_count] = degtorad(_occluder.rotation);
            _rectangle_count++;
        }
        else if (_occluder.geometry.type == "sprite" && _sprite_count < 24)
        {
            var _silhouette = _occluder.geometry.silhouette;
            var _texture_slot = -1;
            for (var _existing_texture_index = 0; _existing_texture_index < array_length(_sprite_textures); _existing_texture_index++)
            {
                if (_sprite_textures[_existing_texture_index] == _silhouette.texture)
                {
                    _texture_slot = _existing_texture_index;
                    break;
                }
            }
            if (_texture_slot < 0)
            {
                if (array_length(_sprite_textures) >= 8) continue;
                _texture_slot = array_length(_sprite_textures);
                array_push(_sprite_textures, _silhouette.texture);
            }

            var _sprite_offset = _sprite_count * 2;
            var _uv_offset = _sprite_count * 4;
            _sprite_ground_positions[_sprite_offset] = _occluder.position.x - _camera_x;
            _sprite_ground_positions[_sprite_offset + 1] = _occluder.position.y - _camera_y;
            var _projection_rotation = variable_struct_exists(_occluder, "projection_rotation") ? _occluder.projection_rotation : _occluder.rotation;
            _sprite_axes[_sprite_offset] = lengthdir_x(1, _projection_rotation);
            _sprite_axes[_sprite_offset + 1] = lengthdir_y(1, _projection_rotation);
            _sprite_sizes[_sprite_offset] = _occluder.geometry.width;
            _sprite_sizes[_sprite_offset + 1] = _occluder.height;
            _sprite_source_positions[_sprite_offset] = _occluder.source_position.x - _camera_x;
            _sprite_source_positions[_sprite_offset + 1] = _occluder.source_position.y - _camera_y;
            _sprite_source_sizes[_sprite_offset] = _occluder.source_size.width;
            _sprite_source_sizes[_sprite_offset + 1] = _occluder.source_size.height;
            _sprite_source_exclusions[_sprite_count] = _occluder.exclude_source_from_shadow;
            _sprite_uvs[_uv_offset] = _silhouette.uv_left;
            _sprite_uvs[_uv_offset + 1] = _silhouette.uv_top;
            _sprite_uvs[_uv_offset + 2] = _silhouette.uv_right;
            _sprite_uvs[_uv_offset + 3] = _silhouette.uv_bottom;
            _sprite_flips[_sprite_count] = _occluder.flip_x;
            _sprite_flip_ys[_sprite_count] = _occluder.flip_y;
            _sprite_source_axes[_sprite_offset] = lengthdir_x(1, _occluder.rotation);
            _sprite_source_axes[_sprite_offset + 1] = lengthdir_y(1, _occluder.rotation);
            _sprite_shared_anchor_projections[_sprite_count] = variable_struct_exists(_occluder, "shared_anchor_projection") && _occluder.shared_anchor_projection;
            _sprite_projection_height_scales[_sprite_count] = variable_struct_exists(_occluder, "projection_height_scale") ? _occluder.projection_height_scale : 1;
            _sprite_texture_indices[_sprite_count] = _texture_slot;
            _sprite_count++;
        }
    }

    if (_rectangle_count <= 0 && _sprite_count <= 0)
    {
        draw_raid_radial_light(_draw_x, _draw_y, _light.radius, _strength, _color, _falloff_rotation, _falloff_x_scale, _falloff_y_scale,
            32, variable_struct_exists(_light, "soft_falloff") && _light.soft_falloff);
        return;
    }

    shader_set(shd_raid_shadow_visibility);
    shader_set_uniform_f(shader_get_uniform(shd_raid_shadow_visibility, "u_light_position"), _light.x - _camera_x, _light.y - _camera_y);
    shader_set_uniform_f(shader_get_uniform(shd_raid_shadow_visibility, "u_light_height"), raid_light_get_shadow_height(_light));
    shader_set_uniform_f(shader_get_uniform(shd_raid_shadow_visibility, "u_rectangle_count"), _rectangle_count);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_rectangle_position"), _rectangle_positions);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_rectangle_half_size"), _rectangle_half_sizes);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_rectangle_height"), _rectangle_heights);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_rectangle_rotation"), _rectangle_rotations);
    shader_set_uniform_f(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_count"), _sprite_count);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_ground_position"), _sprite_ground_positions);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_axis"), _sprite_axes);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_size"), _sprite_sizes);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_source_position"), _sprite_source_positions);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_source_size"), _sprite_source_sizes);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_exclude_source"), _sprite_source_exclusions);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_uv"), _sprite_uvs);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_flip"), _sprite_flips);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_flip_y"), _sprite_flip_ys);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_source_axis"), _sprite_source_axes);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_shared_anchor_projection"), _sprite_shared_anchor_projections);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_projection_height_scale"), _sprite_projection_height_scales);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_texture_index"), _sprite_texture_indices);
    for (var _texture_index = 0; _texture_index < array_length(_sprite_textures); _texture_index++)
    {
        var _sampler = shader_get_sampler_index(shd_raid_shadow_visibility, "u_sprite_texture_" + string(_texture_index));
        texture_set_stage(_sampler, _sprite_textures[_texture_index]);
    }
    shader_set_uniform_f(shader_get_uniform(shd_raid_shadow_visibility, "u_debug_visibility"), _debug_visibility);
    draw_raid_radial_light(_draw_x, _draw_y, _light.radius, _strength, _color, _falloff_rotation, _falloff_x_scale, _falloff_y_scale,
        32, variable_struct_exists(_light, "soft_falloff") && _light.soft_falloff);
    shader_reset();
}

function draw_raid_shadow_debug(_occluders)
{
    if (array_length(_occluders) <= 0 || array_length(raid_wall_lights) <= 0) return;

    var _light = raid_wall_lights[0];
    gpu_set_blendmode(bm_normal);
    draw_raid_shadowed_radial_light(_light, _occluders, 0, 0, 0.85, c_white, true);

    for (var _occluder_index = 0; _occluder_index < array_length(_occluders); _occluder_index++)
    {
        var _occluder = _occluders[_occluder_index];
        if (_occluder.geometry.type == "sprite")
        {
            var _debug_color = variable_struct_exists(_occluder, "character_caster") ? c_fuchsia : c_aqua;
            var _silhouette = _occluder.geometry.silhouette;
            draw_sprite_ext(_occluder.draw_sprite, _occluder.draw_subimage, _occluder.draw_x, _occluder.draw_y,
                _occluder.draw_xscale, _occluder.draw_yscale, _occluder.rotation, _debug_color, 0.45);

            // Yellow is the alpha crop's rectangular projection domain; the
            // tinted sprite shows the actual alpha silhouette sampled inside it.
            var _origin_x = sprite_get_xoffset(_occluder.draw_sprite);
            var _origin_y = sprite_get_yoffset(_occluder.draw_sprite);
            var _source_x = [_silhouette.crop_left, _silhouette.crop_right, _silhouette.crop_right, _silhouette.crop_left];
            var _source_y = [_silhouette.crop_top, _silhouette.crop_top, _silhouette.crop_bottom, _silhouette.crop_bottom];
            var _bounds_x = [];
            var _bounds_y = [];
            for (var _bound_index = 0; _bound_index < 4; _bound_index++)
            {
                var _local_x = (_source_x[_bound_index] - _origin_x) * _occluder.draw_xscale;
                var _local_y = (_source_y[_bound_index] - _origin_y) * _occluder.draw_yscale;
                var _bound_distance = point_distance(0, 0, _local_x, _local_y);
                var _bound_direction = point_direction(0, 0, _local_x, _local_y) + _occluder.rotation;
                array_push(_bounds_x, _occluder.draw_x + lengthdir_x(_bound_distance, _bound_direction));
                array_push(_bounds_y, _occluder.draw_y + lengthdir_y(_bound_distance, _bound_direction));
            }
            draw_set_color(c_yellow);
            for (var _bound_edge = 0; _bound_edge < 4; _bound_edge++)
            {
                var _next_bound_edge = (_bound_edge + 1) mod 4;
                draw_line(_bounds_x[_bound_edge], _bounds_y[_bound_edge], _bounds_x[_next_bound_edge], _bounds_y[_next_bound_edge]);
            }
            draw_set_color(_debug_color);
            draw_circle(_occluder.position.x, _occluder.position.y, 3, false);
            draw_line(_occluder.position.x - 5, _occluder.position.y, _occluder.position.x + 5, _occluder.position.y);
            draw_line(_occluder.position.x, _occluder.position.y - 5, _occluder.position.x, _occluder.position.y + 5);
            continue;
        }

        var _half_width = _occluder.geometry.width * 0.5;
        var _half_depth = _occluder.geometry.depth * 0.5;
        var _corner_x = [-_half_width, _half_width, _half_width, -_half_width];
        var _corner_y = [-_half_depth, -_half_depth, _half_depth, _half_depth];
        var _world_x = [];
        var _world_y = [];
        for (var _corner_index = 0; _corner_index < 4; _corner_index++)
        {
            var _corner_distance = point_distance(0, 0, _corner_x[_corner_index], _corner_y[_corner_index]);
            var _corner_direction = point_direction(0, 0, _corner_x[_corner_index], _corner_y[_corner_index]) + _occluder.rotation;
            array_push(_world_x, _occluder.position.x + lengthdir_x(_corner_distance, _corner_direction));
            array_push(_world_y, _occluder.position.y + lengthdir_y(_corner_distance, _corner_direction));
        }
        draw_set_color(c_yellow);
        for (var _edge_index = 0; _edge_index < 4; _edge_index++)
        {
            var _next_edge_index = (_edge_index + 1) mod 4;
            draw_line(_world_x[_edge_index], _world_y[_edge_index], _world_x[_next_edge_index], _world_y[_next_edge_index]);
        }
    }
    for (var _light_index = 0; _light_index < array_length(raid_light_sources); _light_index++)
    {
        var _debug_light = raid_light_sources[_light_index];
        var _shadow_height = raid_light_get_shadow_height(_debug_light);
        draw_circle(_debug_light.x, _debug_light.y, 4, false);
        draw_text(_debug_light.x + 6, _debug_light.y - 14, "Shadow height: " + string(_shadow_height));
    }

    var _player_body_caster = undefined;
    var _weapon_rig_caster = undefined;
    for (var _player_caster_index = 0; _player_caster_index < array_length(_occluders); _player_caster_index++)
    {
        var _player_debug_caster = _occluders[_player_caster_index];
        if (variable_struct_exists(_player_debug_caster, "player_shadow_body") && _player_debug_caster.player_shadow_body)
            _player_body_caster = _player_debug_caster;
        if (variable_struct_exists(_player_debug_caster, "shared_anchor_projection") && _player_debug_caster.shared_anchor_projection
        && (is_undefined(_weapon_rig_caster) || _player_debug_caster.height > _weapon_rig_caster.height))
            _weapon_rig_caster = _player_debug_caster;
    }
    if (!is_undefined(_player_body_caster))
    {
        var _feet_x = _player_body_caster.position.x;
        var _feet_y = _player_body_caster.position.y;
        var _light_height = raid_light_get_shadow_height(_light);
        var _body_height = min(_player_body_caster.height, _light_height * 0.95);
        var _body_projection_scale = _body_height / max(0.001, _light_height - _body_height);
        var _body_projection_x = (_feet_x - _light.x) * _body_projection_scale;
        var _body_projection_y = (_feet_y - _light.y) * _body_projection_scale;
        draw_set_color(c_yellow);
        draw_line(_light.x, _light.y, _feet_x, _feet_y);
        draw_text((_light.x + _feet_x) * 0.5 + 5, (_light.y + _feet_y) * 0.5, "light direction");
        draw_set_color(c_lime);
        draw_circle(_feet_x, _feet_y, 4, false);
        draw_line(_feet_x, _feet_y, _feet_x + _body_projection_x, _feet_y + _body_projection_y);
        draw_text(_feet_x + 6, _feet_y + 5, "feet / body projection");

        if (!is_undefined(_weapon_rig_caster))
        {
            var _weapon_height = min(_weapon_rig_caster.height, _light_height * 0.95);
            var _weapon_projection_scale = _weapon_height / max(0.001, _light_height - _weapon_height);
            draw_set_color(c_fuchsia);
            draw_line(_feet_x, _feet_y,
                _feet_x + (_feet_x - _light.x) * _weapon_projection_scale,
                _feet_y + (_feet_y - _light.y) * _weapon_projection_scale);
            draw_text(_feet_x + 6, _feet_y + 17, "weapon projection (75% height)");
        }
    }
    draw_set_color(c_white);
}

function raid_light_get_shadow_height(_light)
{
    if (variable_struct_exists(_light, "shadow_height")) return max(0.001, _light.shadow_height);
    if (variable_struct_exists(_light, "height")) return max(0.001, _light.height);
    return 16;
}

function draw_raid_radial_light(_x, _y, _radius, _strength, _color = c_white, _rotation = 0, _x_scale = 1, _y_scale = 1, _segments = 32, _soft_falloff = false)
{
    if (_radius <= 0 || _strength <= 0) return;
    if (!raid_radial_light_is_visible(_x, _y, _radius, _x_scale, _y_scale)) return;

    var _alpha = clamp(_strength, 0, 1);
    var _ring_radius = global.graphics_settings.light_falloff ? [0, 0.10, 0.38, 0.72, 1] : [0, 1];
    var _ring_alpha = global.graphics_settings.light_falloff
        ? (_soft_falloff ? [1, 0.96, 0.68, 0.30, 0] : [1, 0.96, 0.58, 0.15, 0])
        : [1, 1];

    // Every light uses one of a few segment counts. Cache the unit circle so
    // the same trigonometry is not repeated for every ring, light, and pass.
    static _unit_circle_cache = {};
    var _cache_key = "segments_" + string(_segments);
    var _unit_circle;
    if (variable_struct_exists(_unit_circle_cache, _cache_key)) _unit_circle = variable_struct_get(_unit_circle_cache, _cache_key);
    else
    {
        var _unit_x = array_create(_segments + 1, 0);
        var _unit_y = array_create(_segments + 1, 0);
        var _angle_step = 360 / _segments;
        for (var _cache_point = 0; _cache_point <= _segments; _cache_point++)
        {
            var _cache_angle = _cache_point * _angle_step;
            _unit_x[_cache_point] = lengthdir_x(1, _cache_angle);
            _unit_y[_cache_point] = lengthdir_y(1, _cache_angle);
        }
        _unit_circle = {x: _unit_x, y: _unit_y};
        variable_struct_set(_unit_circle_cache, _cache_key, _unit_circle);
    }

    var _rotation_x = lengthdir_x(1, _rotation);
    var _rotation_y = lengthdir_y(1, _rotation);
    var _previous_x = 0;
    var _previous_y = 0;

    // Degenerate connector vertices keep all rings in one triangle strip,
    // preserving the existing piecewise-linear gradient with one submission.
    draw_primitive_begin(pr_trianglestrip);
    for (var _ring = 0; _ring < array_length(_ring_radius) - 1; _ring++)
    {
        var _inner_radius = _radius * _ring_radius[_ring];
        var _outer_radius = _radius * _ring_radius[_ring + 1];
        var _inner_alpha = _alpha * _ring_alpha[_ring];
        var _outer_alpha = _alpha * _ring_alpha[_ring + 1];

        if (_ring > 0)
        {
            var _bridge_outer_local_x = _unit_circle.x[0] * _outer_radius * _x_scale;
            var _bridge_outer_local_y = _unit_circle.y[0] * _outer_radius * _y_scale;
            var _bridge_outer_x = _x + _bridge_outer_local_x * _rotation_x - _bridge_outer_local_y * _rotation_y;
            var _bridge_outer_y = _y + _bridge_outer_local_x * _rotation_y + _bridge_outer_local_y * _rotation_x;
            draw_vertex_colour(_previous_x, _previous_y, _color, _inner_alpha);
            draw_vertex_colour(_bridge_outer_x, _bridge_outer_y, _color, _outer_alpha);
        }

        for (var _point = 0; _point <= _segments; _point++)
        {
            var _unit_x = _unit_circle.x[_point];
            var _unit_y = _unit_circle.y[_point];
            var _inner_x = _unit_x * _inner_radius * _x_scale;
            var _inner_y = _unit_y * _inner_radius * _y_scale;
            var _outer_x = _unit_x * _outer_radius * _x_scale;
            var _outer_y = _unit_y * _outer_radius * _y_scale;
            var _inner_draw_x = _x + _inner_x * _rotation_x - _inner_y * _rotation_y;
            var _inner_draw_y = _y + _inner_x * _rotation_y + _inner_y * _rotation_x;
            var _outer_draw_x = _x + _outer_x * _rotation_x - _outer_y * _rotation_y;
            var _outer_draw_y = _y + _outer_x * _rotation_y + _outer_y * _rotation_x;

            draw_vertex_colour(_outer_draw_x, _outer_draw_y, _color, _outer_alpha);
            draw_vertex_colour(_inner_draw_x, _inner_draw_y, _color, _inner_alpha);
            _previous_x = _inner_draw_x;
            _previous_y = _inner_draw_y;
        }
    }
    draw_primitive_end();
}

function raid_radial_light_is_visible(_x, _y, _radius, _x_scale = 1, _y_scale = 1)
{
    var _extent = _radius * max(abs(_x_scale), abs(_y_scale));
    var _scissor = gpu_get_scissor();
    return _x + _extent >= _scissor.x
        && _x - _extent <= _scissor.x + _scissor.w
        && _y + _extent >= _scissor.y
        && _y - _extent <= _scissor.y + _scissor.h;
}

function draw_raid_loot_halos(_camera_x, _camera_y, _surface_width, _surface_height, _intensity_scale = 1)
{
    for (var _loot_index = 0; _loot_index < array_length(raid_lootables); _loot_index++)
    {
        var _lootable = raid_lootables[_loot_index];
        if (variable_struct_exists(_lootable, "loot_halo_enabled") && !_lootable.loot_halo_enabled) continue;

        var _radius = variable_struct_exists(_lootable, "loot_halo_radius") ? _lootable.loot_halo_radius : loot_halo_radius;
        var _intensity = variable_struct_exists(_lootable, "loot_halo_intensity") ? _lootable.loot_halo_intensity : loot_halo_intensity;
        if (_radius <= 0 || _intensity <= 0) continue;

        var _halo_x = _lootable.lootable_x;
        var _halo_y = _lootable.lootable_y;
        var _x_scale = 1;
        var _y_scale = 1;
        if (variable_struct_exists(_lootable, "sprite_index") && _lootable.sprite_index >= 0)
        {
            var _sprite = _lootable.sprite_index;
            var _sprite_x = variable_struct_exists(_lootable, "sprite_x") ? _lootable.sprite_x : _lootable.lootable_x;
            var _sprite_y = variable_struct_exists(_lootable, "sprite_y") ? _lootable.sprite_y : _lootable.lootable_y;
            var _image_xscale = variable_struct_exists(_lootable, "image_xscale") ? _lootable.image_xscale : 1;
            var _image_yscale = variable_struct_exists(_lootable, "image_yscale") ? _lootable.image_yscale : 1;
            var _image_angle = variable_struct_exists(_lootable, "image_angle") ? _lootable.image_angle : 0;
            var _local_center_x = ((sprite_get_bbox_left(_sprite) + sprite_get_bbox_right(_sprite) + 1) * 0.5 - sprite_get_xoffset(_sprite)) * _image_xscale;
            var _local_center_y = ((sprite_get_bbox_top(_sprite) + sprite_get_bbox_bottom(_sprite) + 1) * 0.5 - sprite_get_yoffset(_sprite)) * _image_yscale;
            var _center_distance = point_distance(0, 0, _local_center_x, _local_center_y);
            var _center_direction = point_direction(0, 0, _local_center_x, _local_center_y) + _image_angle;
            _halo_x = _sprite_x + lengthdir_x(_center_distance, _center_direction);
            _halo_y = _sprite_y + lengthdir_y(_center_distance, _center_direction);

            var _visual_width = abs((sprite_get_bbox_right(_sprite) - sprite_get_bbox_left(_sprite) + 1) * _image_xscale);
            var _visual_height = abs((sprite_get_bbox_bottom(_sprite) - sprite_get_bbox_top(_sprite) + 1) * _image_yscale);
            _radius = max(_radius, max(_visual_width, _visual_height) * 0.5 + 12);
            _x_scale = max(0.72, _visual_width / max(1, _visual_height));
            _x_scale = clamp(_x_scale, 0.85, 1.35);
            _y_scale = clamp(_visual_height / max(1, _visual_width), 0.72, 1);
        }

        _halo_x += variable_struct_exists(_lootable, "loot_halo_offset_x") ? _lootable.loot_halo_offset_x : loot_halo_offset_x;
        _halo_y += variable_struct_exists(_lootable, "loot_halo_offset_y") ? _lootable.loot_halo_offset_y : loot_halo_offset_y;
        if (_halo_x + _radius * _x_scale < _camera_x || _halo_x - _radius * _x_scale > _camera_x + _surface_width
        || _halo_y + _radius * _y_scale < _camera_y || _halo_y - _radius * _y_scale > _camera_y + _surface_height) continue;

        var _color = variable_struct_exists(_lootable, "loot_halo_color") ? _lootable.loot_halo_color : loot_halo_color;
        draw_raid_radial_light(_halo_x - _camera_x, _halo_y - _camera_y, _radius, _intensity * _intensity_scale,
            _color, 0, _x_scale, _y_scale, 24, true);
    }

    if (!raid.doors_active && raid.state != RaidState.EXITING) return;
    for (var _door_index = 0; _door_index < array_length(raid_doors); _door_index++)
    {
        var _door = raid_doors[_door_index];
        if (variable_struct_exists(_door, "loot_halo_enabled") && !_door.loot_halo_enabled) continue;

        var _door_radius = variable_struct_exists(_door, "loot_halo_radius") ? _door.loot_halo_radius : loot_halo_radius;
        var _door_intensity = variable_struct_exists(_door, "loot_halo_intensity") ? _door.loot_halo_intensity : loot_door_halo_intensity;
        var _door_x = _door.door_x + (variable_struct_exists(_door, "loot_halo_offset_x") ? _door.loot_halo_offset_x : loot_halo_offset_x);
        var _door_y = _door.door_y + (variable_struct_exists(_door, "loot_halo_offset_y") ? _door.loot_halo_offset_y : loot_door_halo_offset_y);
        if (_door_radius <= 0 || _door_intensity <= 0
        || _door_x + _door_radius * loot_door_halo_xscale < _camera_x || _door_x - _door_radius * loot_door_halo_xscale > _camera_x + _surface_width
        || _door_y + _door_radius * loot_door_halo_yscale < _camera_y || _door_y - _door_radius * loot_door_halo_yscale > _camera_y + _surface_height) continue;

        var _door_color = variable_struct_exists(_door, "loot_halo_color") ? _door.loot_halo_color : loot_halo_color;
        draw_raid_radial_light(_door_x - _camera_x, _door_y - _camera_y, _door_radius, _door_intensity * _intensity_scale,
            _door_color, 0, loot_door_halo_xscale, loot_door_halo_yscale, 24, true);
    }
}

function draw_raid_light_core(_light, _camera_x, _camera_y, _strength_scale = 1)
{
    if (!variable_struct_exists(_light, "core_radius") || _light.core_radius <= 0) return;

    draw_raid_radial_light(
        _light.x - _camera_x,
        _light.y - _camera_y,
        _light.core_radius,
        _light.core_intensity * _strength_scale,
        _light.core_color,
        0,
        1,
        1,
        24
    );
}

function draw_raid_temporary_light(_light, _occluders, _camera_x, _camera_y, _strength_scale = 1)
{
    if (variable_struct_exists(_light, "muzzle_flash") && _light.muzzle_flash
    && !global.graphics_settings.muzzle_flash_lighting) return;

    var _strength = _light.intensity * _strength_scale;
    if (_light.casts_shadows && array_length(_occluders) > 0)
        draw_raid_shadowed_radial_light(_light, _occluders, _camera_x, _camera_y, _strength, _light.color);
    else
        draw_raid_radial_light(_light.x - _camera_x, _light.y - _camera_y, _light.radius, _strength, _light.color);

    var _decay_scale = variable_struct_exists(_light, "initial_intensity") && _light.initial_intensity > 0
        ? _light.intensity / _light.initial_intensity
        : 1;
    draw_raid_light_core(_light, _camera_x, _camera_y, _strength_scale * _decay_scale);
}

function raid_spawn_temporary_light(_x, _y, _radius, _color, _intensity, _lifetime, _height = 16, _casts_shadows = false, _shadow_height = undefined)
{
    if (_radius <= 0 || _intensity <= 0 || _lifetime <= 0) return undefined;

    var _light = {
        x: _x,
        y: _y,
        radius: _radius,
        color: _color,
        intensity: _intensity,
        initial_intensity: _intensity,
        lifetime: _lifetime,
        initial_lifetime: _lifetime,
        decay_power: 1,
        height: _height,
        shadow_height: is_undefined(_shadow_height) ? _height : _shadow_height,
        casts_shadows: _casts_shadows
    };

    array_push(raid_temporary_lights, _light);
    return _light;
}

function raid_refresh_muzzle_flash_light(_light, _x, _y, _radius, _lifetime)
{
    var _was_active = is_struct(_light) && _light.lifetime > 0;
    if (!_was_active)
    {
        _light = raid_spawn_temporary_light(
            _x, _y, _radius, raid_muzzle_flash_color, raid_muzzle_flash_intensity,
            _lifetime, raid_muzzle_flash_shadow_height, true, raid_muzzle_flash_shadow_height
        );
    }

    _light.x = _x;
    _light.y = _y;
    _light.radius = _radius;
    _light.color = raid_muzzle_flash_color;
    _light.intensity = raid_muzzle_flash_intensity;
    _light.initial_intensity = raid_muzzle_flash_intensity;
    _light.lifetime = _lifetime;
    _light.initial_lifetime = _lifetime;
    _light.decay_power = raid_muzzle_flash_decay_power;
    _light.height = raid_muzzle_flash_shadow_height;
    _light.shadow_height = raid_muzzle_flash_shadow_height;
    _light.casts_shadows = true;
    _light.muzzle_flash = true;
    _light.core_radius = raid_muzzle_flash_core_radius;
    _light.core_intensity = raid_muzzle_flash_core_intensity;
    _light.core_color = make_color_rgb(255, 248, 220);
    return _light;
}

function raid_spawn_wall_light(_x, _y, _rotation = 0, _enabled = true, _radius = 125, _color = c_orange, _intensity = 0.44, _height = 64, _casts_shadows = false, _shadow_occluder_index = -1, _inward_reach_multiplier = 1.15, _shadow_height = 80)
{
    var _fixture = {
        x: _x,
        y: _y,
        rotation: _rotation,
        enabled: _enabled,
        radius: _radius,
        color: _color,
        intensity: _intensity,
        height: _height,
        shadow_height: _shadow_height,
        casts_shadows: _casts_shadows,
        shadow_occluder_index: _shadow_occluder_index,
        falloff_rotation: _rotation,
        falloff_x_scale: 1.20,
        falloff_y_scale: 0.68,
        falloff_offset: 0.2,
        inward_reach_multiplier: _inward_reach_multiplier,
        soft_falloff: true,
        core_radius: 28,
        core_intensity: 0.85,
        core_color: make_color_rgb(255, 205, 90)
    };

    array_push(raid_wall_lights, _fixture);
    array_push(raid_light_sources, _fixture);
    return _fixture;
}

function raid_generate_room_wall_lights()
{
    raid_wall_lights = [];
    raid_light_sources = [];
    raid_shadow_occluders = [];
    var _warm_orange = make_color_rgb(255, 150, 55);

    //right
    raid_spawn_wall_light(1168, 397, 180, true, 125, _warm_orange, 0.42, 64, true);
    raid_spawn_wall_light(1168, 584, 180, true, 125, _warm_orange, 0.42, 64, true);
    //left
    raid_spawn_wall_light(752, 581, 0, true, 125, _warm_orange, 0.42, 64, true);
    raid_spawn_wall_light(752, 457, 0, true, 125, _warm_orange, 0.42, 64, true);
    //top
    raid_spawn_wall_light(1101, 335, 270, true, 125, _warm_orange, 0.42, 64, true);
    raid_spawn_wall_light(819, 335, 270, true, 125, _warm_orange, 0.42, 64, true);

    //bottom
    raid_spawn_wall_light(1018, 744, 90, true, 125, _warm_orange, 0.42, 64, true);
    raid_spawn_wall_light(801, 744, 90, true, 125, _warm_orange, 0.42, 64, true);
}

function raid_shadow_get_arena_wall_occluders()
{
    var _wall_occluders = [];
    var _shelf_depth = max(0, raid_lighting_clip_offset);
    var _wall_depth = max(1, _shelf_depth);
    var _wall_height = 64;
    var _outer_left = raid_room_x1 - _shelf_depth;
    var _outer_top = raid_room_y1 - _shelf_depth;
    var _outer_right = raid_room_x2 + _shelf_depth;
    var _outer_bottom = raid_room_y2 + _shelf_depth;
    var _outer_width = _outer_right - _outer_left;
    var _outer_height = _outer_bottom - _outer_top;
    array_push(_wall_occluders, raid_shadow_occluder_rectangle(_outer_left - _wall_depth * 0.5, (_outer_top + _outer_bottom) * 0.5, _wall_depth, _outer_height + _wall_depth * 2, _wall_height));
    array_push(_wall_occluders, raid_shadow_occluder_rectangle(_outer_right + _wall_depth * 0.5, (_outer_top + _outer_bottom) * 0.5, _wall_depth, _outer_height + _wall_depth * 2, _wall_height));
    array_push(_wall_occluders, raid_shadow_occluder_rectangle((_outer_left + _outer_right) * 0.5, _outer_bottom + _wall_depth * 0.5, _outer_width, _wall_depth, _wall_height));


	var door_padding = 15;
    var _openings = [];
    if (raid.doors_active || raid.state == RaidState.EXITING)
    {
        var _door_lintel_depth = _wall_depth * 0.58;
        for (var _door_index = 0; _door_index < array_length(raid_doors); _door_index++)
        {
            var _door = raid_doors[_door_index];
            var _opening_left = max(raid_room_x1, _door.door_x - _door.door_w * 0.5 - door_padding);
            var _opening_right = min(raid_room_x2, _door.door_x + _door.door_w * 0.5 + door_padding);
            array_push(_openings, {left: _opening_left, right: _opening_right});
            array_push(_wall_occluders, raid_shadow_occluder_rectangle(
                (_opening_left + _opening_right) * 0.5,
                _outer_top - _wall_depth + _door_lintel_depth * 0.5,
                _opening_right - _opening_left,
                _door_lintel_depth,
                _wall_height
            ));
        }
        array_sort(_openings, function(_a, _b) { return _a.left - _b.left; });
    }

    var _segment_start = _outer_left;
    for (var _opening_index = 0; _opening_index < array_length(_openings); _opening_index++)
    {
        var _opening = _openings[_opening_index];
        if (_opening.left > _segment_start)
        {
            var _segment_width = _opening.left - _segment_start;
            array_push(_wall_occluders, raid_shadow_occluder_rectangle(
                _segment_start + _segment_width * 0.5, _outer_top - _wall_depth * 0.5,
                _segment_width, _wall_depth, _wall_height
            ));
        }
        _segment_start = max(_segment_start, _opening.right);
    }

    if (_segment_start < _outer_right)
    {
        var _last_segment_width = _outer_right - _segment_start;
        array_push(_wall_occluders, raid_shadow_occluder_rectangle(
            _segment_start + _last_segment_width * 0.5, _outer_top - _wall_depth * 0.5,
            _last_segment_width, _wall_depth, _wall_height
        ));
    }
    return _wall_occluders;
}

function draw_raid_wall_lights(_glow_only = false, _camera_x = 0, _camera_y = 0, _draw_scale_x = 1, _draw_scale_y = 1, _emissive_scale = 1)
{
    var _scale = 0.64;

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
        draw_sprite_ext(
            _sprite,
            0,
            (_light.x - lengthdir_x(_offset_distance, _offset_direction) - _camera_x) * _draw_scale_x,
            (_light.y - lengthdir_y(_offset_distance, _offset_direction) - _camera_y) * _draw_scale_y,
            _sprite_scale * _draw_scale_x,
            _sprite_scale * _draw_scale_y,
            _light.rotation,
            _glow_only ? _light.color : c_white,
            1
        );
    }
}
