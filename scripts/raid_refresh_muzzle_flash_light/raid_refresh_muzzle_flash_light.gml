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
