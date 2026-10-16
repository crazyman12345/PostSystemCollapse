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
