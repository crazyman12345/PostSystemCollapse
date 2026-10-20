function raid_spawn_wall_light(_x, _y, _rotation = 0, _enabled = true, _radius = 125, _color = c_orange, _intensity = 0.44, _height = 64, _casts_shadows = false, _shadow_occluder_index = -1, _inward_reach_multiplier = 1.15, _shadow_height = 80)
{
    var _mode_roll = random(100);
    var _mode = RaidWallLightMode.STABLE;
    if (_mode_roll >= 95) _mode = RaidWallLightMode.DYING;
    else if (_mode_roll >= 80) _mode = RaidWallLightMode.FAULTY;

    var _fixture = {
        x: _x,
        y: _y,
        rotation: _rotation,
        enabled: _enabled,
        base_enabled: _enabled,
        brightness: _mode == RaidWallLightMode.DYING ? 0 : 1,
        mode: _mode,
        flicker_phase: random(360),
        flicker_event_timer: _mode == RaidWallLightMode.FAULTY ? random_range(120, 360) : random_range(60, 300),
        flicker_active_timer: 0,
        flicker_change_timer: 0,
        flicker_active: false,
        radius: _radius,
        color: _color,
        intensity: _intensity,
        base_intensity: _intensity,
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
        base_core_intensity: 0.85,
        core_color: _color
    };

    array_push(raid_wall_lights, _fixture);
    array_push(raid_light_sources, _fixture);
    return _fixture;
}
