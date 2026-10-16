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
