function raid_shadow_get_silhouette_data(_sprite, _subimage)
{
    var _frame_count = max(1, sprite_get_number(_sprite));
    var _frame = floor(_subimage) mod _frame_count;
    if (_frame < 0) _frame += _frame_count;
    var _cache_key = "sprite_" + string(_sprite) + "_frame_" + string(_frame);
    if (variable_struct_exists(raid_shadow_silhouette_cache, _cache_key))
        return variable_struct_get(raid_shadow_silhouette_cache, _cache_key);

    var _uvs = sprite_get_uvs(_sprite, _frame);
    var _sprite_width = max(1, sprite_get_width(_sprite));
    var _sprite_height = max(1, sprite_get_height(_sprite));
    // Texture-page UVs already describe the alpha-trimmed frame. The remaining
    // values locate that crop in the original sprite canvas without involving
    // the sprite's collision mask.
    var _crop_left = _uvs[4];
    var _crop_top = _uvs[5];
    var _crop_width = max(1, round(_sprite_width * _uvs[6]));
    var _crop_height = max(1, round(_sprite_height * _uvs[7]));
    var _data = {
        sprite_index: _sprite,
        image_index: _frame,
        crop_left: _crop_left,
        crop_top: _crop_top,
        crop_right: _crop_left + _crop_width,
        crop_bottom: _crop_top + _crop_height,
        crop_width: _crop_width,
        crop_height: _crop_height,
        uv_left: _uvs[0],
        uv_top: _uvs[1],
        uv_right: _uvs[2],
        uv_bottom: _uvs[3],
        texture: sprite_get_texture(_sprite, _frame)
    };
    variable_struct_set(raid_shadow_silhouette_cache, _cache_key, _data);
    return _data;
}
