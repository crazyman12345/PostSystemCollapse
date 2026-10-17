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
        cap_material: raid_environment_material(tile1),
        inner_face_material: raid_environment_material(spr_shelf_tile),
        perspective_x: 0,
        perspective_y: 0,
        geometry: undefined
    };
}


function raid_environment_material(_sprite)
{
    var _uvs = sprite_get_uvs(_sprite, 0);
    return {
        sprite: _sprite,
        texture: sprite_get_texture(_sprite, 0),
        uv_left: _uvs[0],
        uv_top: _uvs[1],
        uv_right: _uvs[2],
        uv_bottom: _uvs[3]
    };
}
