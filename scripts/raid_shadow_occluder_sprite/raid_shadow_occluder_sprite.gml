function raid_shadow_occluder_sprite(_sprite, _subimage, _x, _y, _xscale = 1, _yscale = 1, _rotation = 0, _height_override = undefined, _ground_x_override = undefined, _ground_y_override = undefined, _ground_offset_x = 0, _ground_offset_y = 0, _enabled = true)
{
    var _silhouette = raid_shadow_get_silhouette_data(_sprite, _subimage);
    var _visible_width = max(0.001, _silhouette.crop_width * abs(_xscale));
    var _visible_height = max(0.001, _silhouette.crop_height * abs(_yscale));
    var _local_ground_x = ((_silhouette.crop_left + _silhouette.crop_right) * 0.5 - sprite_get_xoffset(_sprite)) * _xscale;
    var _ground_source_y = _yscale < 0 ? _silhouette.crop_top : _silhouette.crop_bottom;
    var _local_ground_y = (_ground_source_y - sprite_get_yoffset(_sprite)) * _yscale;
    var _ground_distance = point_distance(0, 0, _local_ground_x, _local_ground_y);
    var _ground_direction = point_direction(0, 0, _local_ground_x, _local_ground_y) + _rotation;
    var _ground_x = (is_undefined(_ground_x_override) ? _x + lengthdir_x(_ground_distance, _ground_direction) : _ground_x_override) + _ground_offset_x;
    var _ground_y = (is_undefined(_ground_y_override) ? _y + lengthdir_y(_ground_distance, _ground_direction) : _ground_y_override) + _ground_offset_y;

    return {
        geometry: {
            type: "sprite",
            width: _visible_width,
            silhouette: _silhouette
        },
        position: {x: _ground_x, y: _ground_y},
        height: is_undefined(_height_override) ? _visible_height : max(0.001, _height_override),
        rotation: _rotation,
        flip_x: _xscale < 0,
        flip_y: _yscale < 0,
        enabled: _enabled,
        draw_sprite: _sprite,
        draw_subimage: _subimage,
        draw_x: _x,
        draw_y: _y,
        draw_xscale: _xscale,
        draw_yscale: _yscale,
        source_position: {
            x: _x
                + lengthdir_x(((_silhouette.crop_left + _silhouette.crop_right) * 0.5 - sprite_get_xoffset(_sprite)) * _xscale, _rotation)
                + lengthdir_x(((_silhouette.crop_top + _silhouette.crop_bottom) * 0.5 - sprite_get_yoffset(_sprite)) * _yscale, _rotation - 90),
            y: _y
                + lengthdir_y(((_silhouette.crop_left + _silhouette.crop_right) * 0.5 - sprite_get_xoffset(_sprite)) * _xscale, _rotation)
                + lengthdir_y(((_silhouette.crop_top + _silhouette.crop_bottom) * 0.5 - sprite_get_yoffset(_sprite)) * _yscale, _rotation - 90)
        },
        source_size: {width: _visible_width, height: _visible_height},
        exclude_source_from_shadow: false
    };
}
