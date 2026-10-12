function raid_create_enemy_death_effect(_enemy)
{
    var _sprite = _enemy.enemy_sprite;
    var _bbox_left = sprite_get_bbox_left(_sprite);
    var _bbox_top = sprite_get_bbox_top(_sprite);
    var _bbox_width = sprite_get_bbox_right(_sprite) - _bbox_left + 1;
    var _bbox_height = sprite_get_bbox_bottom(_sprite) - _bbox_top + 1;
    var _draw_scale = 0.75 * (40 / _bbox_height) * _enemy.size_multiplier;
    var _x_origin = sprite_get_xoffset(_sprite);
    var _y_origin = sprite_get_yoffset(_sprite);
    var _columns = _enemy.enemy_boss ? 5 : 4;
    var _rows = _enemy.enemy_boss ? 6 : 5;
    var _chunk_count = _columns * _rows;
    var _max_chunks = 200;
    var _remove_count = array_length(raid_enemy_death_effects) + _chunk_count - _max_chunks;
    var _has_hit_direction = variable_struct_exists(_enemy, "enemy_last_hit_direction")
        && !is_undefined(_enemy.enemy_last_hit_direction);

    if (_remove_count > 0)
        array_delete(raid_enemy_death_effects, 0, min(_remove_count, array_length(raid_enemy_death_effects)));

    var _chunk_index = 0;

    for (var _row = 0; _row < _rows; _row++)
    {
        var _source_top = _bbox_top + floor((_row * _bbox_height) / _rows);
        var _source_bottom = _bbox_top + floor(((_row + 1) * _bbox_height) / _rows);
        var _source_height = _source_bottom - _source_top;

        for (var _column = 0; _column < _columns; _column++)
        {
            var _source_left = _bbox_left + floor((_column * _bbox_width) / _columns);
            var _source_right = _bbox_left + floor(((_column + 1) * _bbox_width) / _columns);
            var _source_width = _source_right - _source_left;
            var _source_center_x = _source_left + (_source_width * 0.5);
            var _source_center_y = _source_top + (_source_height * 0.5);
            var _direction = _has_hit_direction
                ? _enemy.enemy_last_hit_direction + random_range(-50, 50)
                : ((_chunk_index / _chunk_count) * 360) + random_range(-12, 12);
            var _speed = random_range(1.4, 3.4) * sqrt(_enemy.size_multiplier);

            array_push(raid_enemy_death_effects, {
                effect_x: _enemy.enemy_x + ((_source_center_x - _x_origin) * _enemy.enemy_facing * _draw_scale),
                effect_y: _enemy.enemy_y + ((_source_center_y - _y_origin) * _draw_scale),
                effect_velocity_x: lengthdir_x(_speed, _direction),
                effect_velocity_y: lengthdir_y(_speed, _direction),

                effect_sprite: _sprite,
                effect_frame: floor(_enemy.enemy_frame),
                effect_source_left: _source_left,
                effect_source_top: _source_top,
                effect_source_width: _source_width,
                effect_source_height: _source_height,

                effect_facing: _enemy.enemy_facing,
                effect_scale: _draw_scale,
                effect_angle: random(360),
                effect_spin: random_range(-12, 12),
                effect_color: random(1) < 0.25 ? merge_colour(c_white, c_red, 0.7) : c_white,
                effect_alpha: 1,

                chunk_leaves_blood: random(1) < (_enemy.enemy_boss ? 0.45 : 0.35),
                chunk_blood_trail_timer: random_range(4, 8),
                chunk_final_blood_done: false
            });

            _chunk_index++;
        }
    }
}
