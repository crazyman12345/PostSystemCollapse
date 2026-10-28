function raid_enemy_add_bullet_hole(_enemy, _hit_x, _hit_y, _hit_direction)
{
    var _sprite = _enemy.enemy_sprite;
    var _sprite_width = sprite_get_width(_sprite);
    var _sprite_height = sprite_get_height(_sprite);
    var _bbox_left = sprite_get_bbox_left(_sprite);
    var _bbox_top = sprite_get_bbox_top(_sprite);
    var _bbox_width = max(1, sprite_get_bbox_right(_sprite) - _bbox_left + 1);
    var _bbox_height = max(1, sprite_get_bbox_bottom(_sprite) - _bbox_top + 1);
    var _draw_scale = 0.75 * (40 / _bbox_height) * _enemy.size_multiplier;
    var _inward_distance = 10;
    _hit_x += lengthdir_x(_inward_distance, _hit_direction);
    _hit_y += lengthdir_y(_inward_distance, _hit_direction);

    var _local_x = sprite_get_xoffset(_sprite)
        + ((_hit_x - _enemy.enemy_x) / (_draw_scale * _enemy.enemy_facing));
    var _local_y = sprite_get_yoffset(_sprite)
        + ((_hit_y - _enemy.enemy_y) / _draw_scale);
    var _pixel_x = clamp(round(_local_x), 0, _sprite_width - 1);
    var _pixel_y = clamp(round(_local_y), 0, _sprite_height - 1);
    var _transparent_clearance = 4;
    var _local_direction_x = lengthdir_x(1, _hit_direction) * _enemy.enemy_facing;
    var _local_direction_y = lengthdir_y(1, _hit_direction);

    if (!surface_exists(raid_enemy_hit_mask_surface)
    || surface_get_width(raid_enemy_hit_mask_surface) != _sprite_width
    || surface_get_height(raid_enemy_hit_mask_surface) != _sprite_height)
    {
        if (surface_exists(raid_enemy_hit_mask_surface)) surface_free(raid_enemy_hit_mask_surface);
        raid_enemy_hit_mask_surface = surface_create(_sprite_width, _sprite_height);
    }

    if (!surface_exists(raid_enemy_hit_mask_surface)) return _enemy;

    surface_set_target(raid_enemy_hit_mask_surface);
    draw_clear_alpha(c_black, 0);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_sprite(_sprite, floor(_enemy.enemy_frame), sprite_get_xoffset(_sprite), sprite_get_yoffset(_sprite));
    surface_reset_target();

    var _opaque_found = raid_enemy_hit_mask_is_opaque(
        raid_enemy_hit_mask_surface, _pixel_x, _pixel_y, _sprite_width, _sprite_height,
        _transparent_clearance, _local_direction_x, _local_direction_y
    );

    if (!_opaque_found)
    {
        var _search_distance = min(24, ceil(8 / max(0.001, _draw_scale)));

        for (var _distance = 1; _distance <= _search_distance; _distance++)
        {
            var _candidate_x = round(_local_x + _local_direction_x * _distance);
            var _candidate_y = round(_local_y + _local_direction_y * _distance);

            if (raid_enemy_hit_mask_is_opaque(
                raid_enemy_hit_mask_surface, _candidate_x, _candidate_y, _sprite_width, _sprite_height,
                _transparent_clearance, _local_direction_x, _local_direction_y
            ))
            {
                _pixel_x = _candidate_x;
                _pixel_y = _candidate_y;
                _opaque_found = true;
                break;
            }
        }
    }

    if (!_opaque_found)
    {
        var _search_radius = min(8, ceil(3 / max(0.001, _draw_scale)));

        for (var _radius = 1; _radius <= _search_radius && !_opaque_found; _radius++)
        {
            for (var _offset = -_radius; _offset <= _radius && !_opaque_found; _offset++)
            {
                var _candidate_points = [
                    [_pixel_x + _offset, _pixel_y - _radius],
                    [_pixel_x + _offset, _pixel_y + _radius],
                    [_pixel_x - _radius, _pixel_y + _offset],
                    [_pixel_x + _radius, _pixel_y + _offset]
                ];

                for (var _point_index = 0; _point_index < array_length(_candidate_points); _point_index++)
                {
                    var _candidate = _candidate_points[_point_index];
                    if (!raid_enemy_hit_mask_is_opaque(
                        raid_enemy_hit_mask_surface, _candidate[0], _candidate[1], _sprite_width, _sprite_height,
                        _transparent_clearance, _local_direction_x, _local_direction_y
                    )) continue;

                    _pixel_x = _candidate[0];
                    _pixel_y = _candidate[1];
                    _opaque_found = true;
                    break;
                }
            }
        }
    }

    if (!_opaque_found) return _enemy;

    array_push(_enemy.enemy_bullet_holes, {
        x: clamp((_pixel_x - _bbox_left) / _bbox_width, 0, 1),
        y: clamp((_pixel_y - _bbox_top) / _bbox_height, 0, 1),
        angle: random(360),
        scale: random_range(0.8, 1.2)
    });

    var _max_bullet_holes = 8;
    if (array_length(_enemy.enemy_bullet_holes) > _max_bullet_holes)
        array_delete(_enemy.enemy_bullet_holes, 0, array_length(_enemy.enemy_bullet_holes) - _max_bullet_holes);

    return _enemy;
}

function raid_enemy_hit_mask_is_opaque(
    _surface, _x, _y, _width, _height, _clearance, _inward_direction_x, _inward_direction_y
)
{
    var _edge_x = round(_x - _inward_direction_x * _clearance);
    var _edge_y = round(_y - _inward_direction_y * _clearance);
    if (_edge_x < 0 || _edge_x >= _width || _edge_y < 0 || _edge_y >= _height) return false;

    return ((surface_getpixel_ext(_surface, _edge_x, _edge_y) >> 24) & 255) > 16;
}
