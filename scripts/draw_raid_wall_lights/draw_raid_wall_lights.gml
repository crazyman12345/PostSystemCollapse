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
