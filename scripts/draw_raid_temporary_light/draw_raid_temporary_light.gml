function draw_raid_temporary_light(_light, _occluders, _camera_x, _camera_y, _strength_scale = 1,
    _share_shadow_color = false, _skip_shadowed_radial = false)
{
    if (variable_struct_exists(_light, "muzzle_flash") && _light.muzzle_flash
    && !global.graphics_settings.muzzle_flash_lighting) return;

    var _strength = _light.intensity * _strength_scale;
    if (_light.casts_shadows && array_length(_occluders) > 0)
    {
        if (!_skip_shadowed_radial)
        {
            if (_share_shadow_color) gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_one, bm_zero, bm_inv_src_alpha);
            draw_raid_shadowed_radial_light(_light, _occluders, _camera_x, _camera_y, _strength, _light.color, false,
                _share_shadow_color ? _strength * raid_colored_light_strength : undefined);
            if (_share_shadow_color) gpu_set_blendmode_ext_sepalpha(bm_zero, bm_one, bm_zero, bm_inv_src_alpha);
        }
    }
    else
        draw_raid_radial_light(_light.x - _camera_x, _light.y - _camera_y, _light.radius, _strength, _light.color);

    var _decay_scale = variable_struct_exists(_light, "initial_intensity") && _light.initial_intensity > 0
        ? _light.intensity / _light.initial_intensity
        : 1;
    draw_raid_light_core(_light, _camera_x, _camera_y, _strength_scale * _decay_scale);
}
