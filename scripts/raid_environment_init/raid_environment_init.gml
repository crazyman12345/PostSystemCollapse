function raid_environment_init()
{
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
        inner_face_material: raid_environment_material(spr_shelf_tile),
        perspective_x: 0,
        perspective_y: 0,
        geometry: undefined
    };
}


function raid_environment_material(_sprite, _crop_left = 0, _crop_right = 0)
{
    var _uvs = sprite_get_uvs(_sprite, 0);
    return {
        sprite: _sprite,
        texture: sprite_get_texture(_sprite, 0),
        uv_left: lerp(_uvs[0], _uvs[2], _crop_left),
        uv_top: _uvs[1],
        uv_right: lerp(_uvs[0], _uvs[2], 1 - _crop_right),
        uv_bottom: _uvs[3]
    };
}
