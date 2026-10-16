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
