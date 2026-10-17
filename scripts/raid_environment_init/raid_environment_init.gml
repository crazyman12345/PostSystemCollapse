function raid_environment_init()
{
    var _inner_face_material = raid_environment_material(spr_shelf_texture);
    _inner_face_material.offset_x = 33;
    _inner_face_material.offset_y = -17;
    _inner_face_material.uv_offset_v = 97;
    _inner_face_material.scale_x = 20;
    _inner_face_material.scale_y = 49;

    raid_environment = {
        enabled: true,
        debug: false,
        wall_height: 48,
        wall_thickness: 28,
        vertical_projection: 0.75,
        perspective_strength_x: 4,
        perspective_strength_y: 3,
        perspective_smoothing: 0.12,
        tile_width: 32,
        tile_height: 16,
        wall_segments: {north: 5, south: 5, east: 5, west: 5},
        cap_material: raid_environment_material(tile1),
        inner_face_material: _inner_face_material,
        perspective_x: 0,
        perspective_y: 0,
        geometry: undefined
    };
    raid_texture_crop_debug_init();
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
