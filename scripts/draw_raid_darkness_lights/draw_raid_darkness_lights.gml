function draw_raid_darkness_lights(_camera_x, _camera_y, _surface_width, _surface_height, _projectile_lights, _shadow_occluders,
    _share_shadow_color = false)
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
            if (_share_shadow_color) gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_one, bm_zero, bm_inv_src_alpha);
            draw_raid_shadowed_radial_light(_light, _shadow_occluders, _camera_x, _camera_y, _intensity, _color, false,
                _share_shadow_color ? _intensity * raid_colored_light_strength : undefined);
            if (_share_shadow_color) gpu_set_blendmode_ext_sepalpha(bm_zero, bm_one, bm_zero, bm_inv_src_alpha);
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
        draw_raid_temporary_light(_temporary_light, _shadow_occluders, _camera_x, _camera_y, 1,
            _share_shadow_color, false);
    }

    // Projectile lights intentionally use the unshadowed radial path.
    for (var _projectile_index = 0; _projectile_index < array_length(_projectile_lights); _projectile_index++)
    {
        var _projectile_light = _projectile_lights[_projectile_index];
        var _projectile = _projectile_light.projectile;
        draw_raid_radial_light(
            _projectile.bx - _camera_x,
            _projectile.by - _camera_y,
            variable_struct_exists(_projectile, "light_radius") ? _projectile.light_radius : raid_projectile_light_radius,
            (variable_struct_exists(_projectile, "light_intensity") ? _projectile.light_intensity : raid_projectile_light_intensity)
                * (variable_struct_exists(_projectile, "alpha") ? _projectile.alpha : 1),
            _projectile_light.color,
            0, 1, 1, 16
        );
    }
}
