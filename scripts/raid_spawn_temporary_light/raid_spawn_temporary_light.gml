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
