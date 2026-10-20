function raid_environment_init()
{
    var _inner_face_sprites = [spr_shelf1, spr_shelf2, spr_shelf3, spr_shelf4, spr_shelf5];
    var _inner_face_materials = raid_environment_wall_materials(_inner_face_sprites);

    var _door_inner_face_material = raid_environment_door_material(spr_door1);

    var _cap_material = raid_environment_material(topcap1, -8, 14, -6, -24);
    _cap_material.offset_x = 35;
    _cap_material.offset_y = 45;
    _cap_material.scale_x = 10;
    _cap_material.scale_y = 14;

    raid_environment = {
        enabled: true,
        debug: false,
        wall_height: 48,
        door_opening_height: 33,
        door_opening_left_offset: 3,
        door_opening_right_offset: -2,
        wall_thickness: 28,
        vertical_projection: 0.75,
        perspective_strength_x: 4,
        perspective_strength_y: 3,
        perspective_smoothing: 0.12,
        tile_width: 32,
        tile_height: 16,
        wall_segments: {north: 5, south: 5, east: 5, west: 5},
        cap_material: _cap_material,
        inner_face_material: _inner_face_materials[0],
        inner_face_materials: _inner_face_materials,
        door_inner_face_material: _door_inner_face_material,
        perspective_x: 0,
        perspective_y: 0,
        geometry: undefined
    };
    raid_texture_crop_debug_init();
}


function raid_environment_door_material(_sprite, _settings = undefined)
{
    var _material = raid_environment_material(_sprite, 0, 3, -42, -29);
    _material.offset_x = -13;
    _material.offset_y = -32;
    _material.uv_offset_v = 4;
    _material.scale_x = 80;
    _material.scale_y = 171;

    if (!is_undefined(_settings))
    {
        _material.crop_left = _settings.crop_left;
        _material.crop_right = _settings.crop_right;
        _material.crop_top = _settings.crop_top;
        _material.crop_bottom = _settings.crop_bottom;
        _material.offset_x = _settings.offset_x;
        _material.offset_y = _settings.offset_y;
        _material.uv_offset_u = _settings.uv_offset_u;
        _material.uv_offset_v = _settings.uv_offset_v;
        _material.scale_x = _settings.scale_x;
        _material.scale_y = _settings.scale_y;
    }
    return _material;
}


function raid_environment_wall_materials(_sprites)
{
    var _materials = [];
    for (var _sprite_index = 0; _sprite_index < array_length(_sprites); _sprite_index++)
    {
        var _material = raid_environment_material(_sprites[_sprite_index], 0, 0, 45, -29);
        _material.offset_x = -10;
        _material.offset_y = 32;
        _material.uv_offset_v = 6;
        _material.scale_x = 84;
        _material.scale_y = 66;
        array_push(_materials, _material);
    }
    return _materials;
}


function raid_environment_material(_sprite, _crop_left = 0, _crop_right = 0, _crop_top = 0, _crop_bottom = 0)
{
    var _uvs = sprite_get_uvs(_sprite, 0);
    return {
        sprite: _sprite,
        texture: sprite_get_texture(_sprite, 0),
        uv_left: _uvs[0],
        uv_top: _uvs[1],
        uv_right: _uvs[2],
        uv_bottom: _uvs[3],
        crop_left: _crop_left,
        crop_right: _crop_right,
        crop_top: _crop_top,
        crop_bottom: _crop_bottom,
        offset_x: 0,
        offset_y: 0,
        uv_offset_u: 0,
        uv_offset_v: 0,
        scale_x: 100,
        scale_y: 100
    };
}
