function draw_raid_loot_halos(_camera_x, _camera_y, _surface_width, _surface_height, _intensity_scale = 1)
{
    for (var _loot_index = 0; _loot_index < array_length(raid_lootables); _loot_index++)
    {
        var _lootable = raid_lootables[_loot_index];
        if (variable_struct_exists(_lootable, "loot_halo_enabled") && !_lootable.loot_halo_enabled) continue;

        var _radius = variable_struct_exists(_lootable, "loot_halo_radius") ? _lootable.loot_halo_radius : loot_halo_radius;
        var _intensity = variable_struct_exists(_lootable, "loot_halo_intensity") ? _lootable.loot_halo_intensity : loot_halo_intensity;
        if (_radius <= 0 || _intensity <= 0) continue;

        var _halo_x = _lootable.lootable_x;
        var _halo_y = _lootable.lootable_y;
        var _x_scale = 1;
        var _y_scale = 1;
        if (variable_struct_exists(_lootable, "sprite_index") && _lootable.sprite_index >= 0)
        {
            var _sprite = _lootable.sprite_index;
            var _sprite_x = variable_struct_exists(_lootable, "sprite_x") ? _lootable.sprite_x : _lootable.lootable_x;
            var _sprite_y = variable_struct_exists(_lootable, "sprite_y") ? _lootable.sprite_y : _lootable.lootable_y;
            var _image_xscale = variable_struct_exists(_lootable, "image_xscale") ? _lootable.image_xscale : 1;
            var _image_yscale = variable_struct_exists(_lootable, "image_yscale") ? _lootable.image_yscale : 1;
            var _image_angle = variable_struct_exists(_lootable, "image_angle") ? _lootable.image_angle : 0;
            var _local_center_x = ((sprite_get_bbox_left(_sprite) + sprite_get_bbox_right(_sprite) + 1) * 0.5 - sprite_get_xoffset(_sprite)) * _image_xscale;
            var _local_center_y = ((sprite_get_bbox_top(_sprite) + sprite_get_bbox_bottom(_sprite) + 1) * 0.5 - sprite_get_yoffset(_sprite)) * _image_yscale;
            var _center_distance = point_distance(0, 0, _local_center_x, _local_center_y);
            var _center_direction = point_direction(0, 0, _local_center_x, _local_center_y) + _image_angle;
            _halo_x = _sprite_x + lengthdir_x(_center_distance, _center_direction);
            _halo_y = _sprite_y + lengthdir_y(_center_distance, _center_direction);

            var _visual_width = abs((sprite_get_bbox_right(_sprite) - sprite_get_bbox_left(_sprite) + 1) * _image_xscale);
            var _visual_height = abs((sprite_get_bbox_bottom(_sprite) - sprite_get_bbox_top(_sprite) + 1) * _image_yscale);
            _radius = max(_radius, max(_visual_width, _visual_height) * 0.5 + 12);
            _x_scale = max(0.72, _visual_width / max(1, _visual_height));
            _x_scale = clamp(_x_scale, 0.85, 1.35);
            _y_scale = clamp(_visual_height / max(1, _visual_width), 0.72, 1);
        }

        _halo_x += variable_struct_exists(_lootable, "loot_halo_offset_x") ? _lootable.loot_halo_offset_x : loot_halo_offset_x;
        _halo_y += variable_struct_exists(_lootable, "loot_halo_offset_y") ? _lootable.loot_halo_offset_y : loot_halo_offset_y;
        if (_halo_x + _radius * _x_scale < _camera_x || _halo_x - _radius * _x_scale > _camera_x + _surface_width
        || _halo_y + _radius * _y_scale < _camera_y || _halo_y - _radius * _y_scale > _camera_y + _surface_height) continue;

        var _color = variable_struct_exists(_lootable, "loot_halo_color") ? _lootable.loot_halo_color : loot_halo_color;
        draw_raid_radial_light(_halo_x - _camera_x, _halo_y - _camera_y, _radius, _intensity * _intensity_scale,
            _color, 0, _x_scale, _y_scale, 24, true);
    }

    if (!raid.doors_active && raid.state != RaidState.EXITING) return;
    for (var _door_index = 0; _door_index < array_length(raid_doors); _door_index++)
    {
        var _door = raid_doors[_door_index];
        if (variable_struct_exists(_door, "loot_halo_enabled") && !_door.loot_halo_enabled) continue;

        var _door_radius = variable_struct_exists(_door, "loot_halo_radius") ? _door.loot_halo_radius : loot_halo_radius;
        var _door_intensity = variable_struct_exists(_door, "loot_halo_intensity") ? _door.loot_halo_intensity : loot_door_halo_intensity;
        var _door_x = _door.door_x + (variable_struct_exists(_door, "loot_halo_offset_x") ? _door.loot_halo_offset_x : loot_halo_offset_x);
        var _door_y = _door.door_y + (variable_struct_exists(_door, "loot_halo_offset_y") ? _door.loot_halo_offset_y : loot_door_halo_offset_y);
        if (_door_radius <= 0 || _door_intensity <= 0
        || _door_x + _door_radius * loot_door_halo_xscale < _camera_x || _door_x - _door_radius * loot_door_halo_xscale > _camera_x + _surface_width
        || _door_y + _door_radius * loot_door_halo_yscale < _camera_y || _door_y - _door_radius * loot_door_halo_yscale > _camera_y + _surface_height) continue;

        var _door_color = variable_struct_exists(_door, "loot_halo_color") ? _door.loot_halo_color : loot_halo_color;
        draw_raid_radial_light(_door_x - _camera_x, _door_y - _camera_y, _door_radius, _door_intensity * _intensity_scale,
            _door_color, 0, loot_door_halo_xscale, loot_door_halo_yscale, 24, true);
    }
}
