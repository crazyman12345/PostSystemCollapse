function raid_floor_generate()
{
    raid_floor_tiles = [];

    for (var _row = 0; _row < 7; _row++)
    {
        for (var _column = 0; _column < 7; _column++)
        {
            array_push(raid_floor_tiles, {
                sprite: choose(tile1, tile2, tile3, tile4),
                rotation: (_row == 0 || _row == 6 || _column == 0 || _column == 6) ? 0 : irandom(3) * 90
            });
        }
    }
}

function raid_floor_draw()
{
    var _tile_size = 80;
    var _grid_size = 7;
    var _source_inner_left = 80;
    var _source_inner_top = 80;
    var _source_inner_width = 467;
    var _source_inner_height = 467;
    var _source_outer_left = 37;
    var _source_outer_top = 72;
    var _source_outer_right = 590;
    var _source_outer_bottom = 594;
    var _scale_x = (raid_room_x2 - raid_room_x1) / _source_inner_width;
    var _scale_y = (raid_room_y2 - raid_room_y1) / _source_inner_height;
    var _left_edge_width = clamp((_source_inner_left - _source_outer_left) * _scale_x, 0, _tile_size);
    var _top_edge_height = clamp((_source_inner_top - _source_outer_top) * _scale_y, 0, _tile_size);
    var _right_edge_width = clamp((_source_outer_right - (_source_inner_left + _source_inner_width)) * _scale_x, 0, _tile_size);
    var _bottom_edge_height = clamp((_source_outer_bottom - (_source_inner_top + _source_inner_height)) * _scale_y, 0, _tile_size);

    for (var _index = 0; _index < array_length(raid_floor_tiles); _index++)
    {
        var _tile = raid_floor_tiles[_index];
        var _column = _index mod _grid_size;
        var _row = _index div _grid_size;
        var _tile_x = raid_room_x1 + ((_column - 1) * _tile_size);
        var _tile_y = raid_room_y1 + ((_row - 1) * _tile_size);

        if (_column == 0 || _column == _grid_size - 1 || _row == 0 || _row == _grid_size - 1)
        {
            var _part_left = _column == 0 ? _tile_size - _left_edge_width : 0;
            var _part_top = _row == 0 ? _tile_size - _top_edge_height : 0;
            var _part_width = _column == 0 ? _left_edge_width : (_column == _grid_size - 1 ? _right_edge_width : _tile_size);
            var _part_height = _row == 0 ? _top_edge_height : (_row == _grid_size - 1 ? _bottom_edge_height : _tile_size);

            if (_column == 0) _tile_x = raid_room_x1 - _left_edge_width;
            if (_row == 0) _tile_y = raid_room_y1 - _top_edge_height;

            draw_sprite_part_ext(
                _tile.sprite,
                0,
                _part_left,
                _part_top,
                _part_width,
                _part_height,
                _tile_x,
                _tile_y,
                1,
                1,
                make_color_rgb(192, 192, 192),
                1
            );
            continue;
        }

        var _center_x = _tile_x + (_tile_size * 0.5);
        var _center_y = _tile_y + (_tile_size * 0.5);
        var _offset_x = (sprite_get_width(_tile.sprite) * 0.5) - sprite_get_xoffset(_tile.sprite);
        var _offset_y = (sprite_get_height(_tile.sprite) * 0.5) - sprite_get_yoffset(_tile.sprite);
        var _offset_distance = point_distance(0, 0, _offset_x, _offset_y);
        var _offset_direction = point_direction(0, 0, _offset_x, _offset_y) + _tile.rotation;

        draw_sprite_ext(
            _tile.sprite,
            0,
            _center_x - lengthdir_x(_offset_distance, _offset_direction),
            _center_y - lengthdir_y(_offset_distance, _offset_direction),
            1,
            1,
            _tile.rotation,
            make_color_rgb(192, 192, 192),
            1
        );
    }
}
