function draw_raid_colored_lights(_camera_x, _camera_y, _surface_width, _surface_height, _projectile_lights, _shadow_occluders,
    _skip_shared_shadows = false)
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
            if (!_skip_shared_shadows) draw_raid_shadowed_radial_light(
                _color_light, _shadow_occluders, _camera_x, _camera_y,
                _color_intensity * raid_colored_light_strength, _light_color);
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
        draw_raid_temporary_light(_temporary_color_light, _shadow_occluders, _camera_x, _camera_y,
            raid_colored_light_strength, false, _skip_shared_shadows);
    }

    // Projectile lights intentionally use the unshadowed radial path.
    for (var _projectile_color_index = 0; _projectile_color_index < array_length(_projectile_lights); _projectile_color_index++)
    {
        var _projectile_light = _projectile_lights[_projectile_color_index];
        var _color_projectile = _projectile_light.projectile;
        var _color_projectile_intensity = variable_struct_exists(_color_projectile, "light_intensity")
            ? _color_projectile.light_intensity : raid_projectile_light_intensity;
        draw_raid_radial_light(
            _color_projectile.bx - _camera_x,
            _color_projectile.by - _camera_y,
            variable_struct_exists(_color_projectile, "light_radius") ? _color_projectile.light_radius : raid_projectile_light_radius,
            _color_projectile_intensity * raid_colored_light_strength,
            _projectile_light.color,
            0, 1, 1, 16
        );
    }
}
