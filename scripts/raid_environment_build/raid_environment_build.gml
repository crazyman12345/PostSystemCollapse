function raid_environment_build()
{
    if (!variable_instance_exists(id, "raid_room_x1")) return;

    var _settings = raid_environment;
    var _height = max(1, _settings.wall_height);
    var _thickness = max(1, _settings.wall_thickness);
    var _projection_depth = _height * max(0, _settings.vertical_projection);
    var _openings = raid_environment_get_door_openings();
    var _geometry = {
        room_x1: raid_room_x1,
        room_y1: raid_room_y1,
        room_x2: raid_room_x2,
        room_y2: raid_room_y2,
        wall_height: _height,
        wall_thickness: _thickness,
        vertical_projection: _settings.vertical_projection,
        tile_width: _settings.tile_width,
        tile_height: _settings.tile_height,
        openings: _openings,
        back_inner_faces: [],
        back_caps: [],
        front_inner_faces: [],
        front_caps: []
    };
    var _inner_face_color = make_color_rgb(190, 194, 198);
    var _cap_color = make_color_rgb(190, 194, 198);

    // North wall: anchor every face base to the room boundary and leave the
    // existing door spans open. Caps remain rectangular at arena corners.
    var _segment_start = raid_room_x1;
    for (var _opening_index = 0; _opening_index <= array_length(_openings); _opening_index++)
    {
        var _segment_end = _opening_index < array_length(_openings)
            ? _openings[_opening_index].left
            : raid_room_x2;
        if (_segment_end > _segment_start)
        {
            var _at_left_corner = _segment_start == raid_room_x1;
            var _at_right_corner = _segment_end == raid_room_x2;
            var _top_start = _segment_start - (_at_left_corner ? _projection_depth : 0);
            var _top_end = _segment_end + (_at_right_corner ? _projection_depth : 0);
            raid_environment_add_inner_face_tiles(_geometry.back_inner_faces,
                _top_start, raid_room_y1, _top_end, raid_room_y1,
                _segment_start, raid_room_y1, _segment_end, raid_room_y1,
                _height, _inner_face_color, 0, -1);
            raid_environment_add_cap_rectangle(
                _geometry,
                false,
                _top_start - (_at_left_corner ? _thickness : 0),
                raid_room_y1 - _projection_depth - _thickness,
                _top_end + (_at_right_corner ? _thickness : 0),
                raid_room_y1 - _projection_depth,
                _height, _cap_color
            );
        }

        if (_opening_index < array_length(_openings))
            _segment_start = _openings[_opening_index].right;
    }

    // South remains in the foreground pass so the inward-facing wall can
    // overlap actors at the southern boundary.
    raid_environment_add_inner_face_tiles(_geometry.front_inner_faces,
        raid_room_x1 - _projection_depth, raid_room_y2,
        raid_room_x2 + _projection_depth, raid_room_y2,
        raid_room_x1, raid_room_y2, raid_room_x2, raid_room_y2,
        _height, _inner_face_color, 0, 1);
    raid_environment_add_cap_rectangle(_geometry, true,
        raid_room_x1 - _projection_depth - _thickness,
        raid_room_y2 + _projection_depth,
        raid_room_x2 + _projection_depth + _thickness,
        raid_room_y2 + _projection_depth + _thickness,
        _height, _cap_color);

    raid_environment_add_inner_face_tiles(_geometry.back_inner_faces,
        raid_room_x1, raid_room_y1 - _projection_depth,
        raid_room_x1, raid_room_y2 + _projection_depth,
        raid_room_x1, raid_room_y1, raid_room_x1, raid_room_y2,
        _height, _inner_face_color, -1, 0);
    raid_environment_add_cap_rectangle(_geometry, false,
        raid_room_x1 - _projection_depth - _thickness,
        raid_room_y1 - _projection_depth,
        raid_room_x1 - _projection_depth,
        raid_room_y2 + _projection_depth,
        _height, _cap_color);

    raid_environment_add_inner_face_tiles(_geometry.back_inner_faces,
        raid_room_x2, raid_room_y1 - _projection_depth,
        raid_room_x2, raid_room_y2 + _projection_depth,
        raid_room_x2, raid_room_y1, raid_room_x2, raid_room_y2,
        _height, _inner_face_color, 1, 0);
    raid_environment_add_cap_rectangle(_geometry, false,
        raid_room_x2 + _projection_depth,
        raid_room_y1 - _projection_depth,
        raid_room_x2 + _projection_depth + _thickness,
        raid_room_y2 + _projection_depth,
        _height, _cap_color);

    raid_environment.geometry = _geometry;
    raid_environment_project_geometry();
}


function raid_environment_get_door_openings()
{
    var _openings = [];
    var _doors_visible = raid.doors_active || raid.state == RaidState.EXITING;
    if (!_doors_visible) return _openings;

    for (var _door_index = 0; _door_index < array_length(raid_doors); _door_index++)
    {
        var _door = raid_doors[_door_index];
        var _left = clamp(_door.door_x - _door.door_w * 0.5, raid_room_x1, raid_room_x2);
        var _right = clamp(_door.door_x + _door.door_w * 0.5, raid_room_x1, raid_room_x2);
        if (_right > _left) array_push(_openings, {left: _left, right: _right});
    }
    array_sort(_openings, function(_a, _b) { return _a.left - _b.left; });
    return _openings;
}


function raid_environment_add_inner_face_tiles(_batch,
    _top_ax, _top_ay, _top_bx, _top_by,
    _base_ax, _base_ay, _base_bx, _base_by,
    _height, _color, _projection_x, _projection_y)
{
    var _length = point_distance(_top_ax, _top_ay, _top_bx, _top_by);
    if (_length <= 0 || _height <= 0) return;

    var _tile_width = max(1, raid_environment.tile_width);
    var _material_sprite = raid_environment.inner_face_material.sprite;
    var _tile_height = _tile_width * sprite_get_height(_material_sprite) / max(1, sprite_get_width(_material_sprite));
    _tile_height = max(1, _tile_height);
    var _length_tiles = max(1, ceil(_length / _tile_width));
    var _height_tiles = max(1, ceil(_height / _tile_height));

    for (var _length_index = 0; _length_index < _length_tiles; _length_index++)
    {
        var _distance_start = _length_index * _tile_width;
        var _distance_end = min(_length, _distance_start + _tile_width);
        var _length_start = _distance_start / _length;
        var _length_end = _distance_end / _length;
        var _u_end = (_distance_end - _distance_start) / _tile_width;

        for (var _height_index = 0; _height_index < _height_tiles; _height_index++)
        {
            var _distance_from_top = _height_index * _tile_height;
            var _distance_from_top_end = min(_height, _distance_from_top + _tile_height);
            var _top_height = _height - _distance_from_top;
            var _bottom_height = _height - _distance_from_top_end;
            var _top_amount = _top_height / _height;
            var _bottom_amount = _bottom_height / _height;
            var _v_end = (_distance_from_top_end - _distance_from_top) / _tile_height;

            var _top_x1 = lerp(lerp(_base_ax, _base_bx, _length_start), lerp(_top_ax, _top_bx, _length_start), _top_amount);
            var _top_y1 = lerp(lerp(_base_ay, _base_by, _length_start), lerp(_top_ay, _top_by, _length_start), _top_amount);
            var _top_x2 = lerp(lerp(_base_ax, _base_bx, _length_end), lerp(_top_ax, _top_bx, _length_end), _top_amount);
            var _top_y2 = lerp(lerp(_base_ay, _base_by, _length_end), lerp(_top_ay, _top_by, _length_end), _top_amount);
            var _bottom_x1 = lerp(lerp(_base_ax, _base_bx, _length_start), lerp(_top_ax, _top_bx, _length_start), _bottom_amount);
            var _bottom_y1 = lerp(lerp(_base_ay, _base_by, _length_start), lerp(_top_ay, _top_by, _length_start), _bottom_amount);
            var _bottom_x2 = lerp(lerp(_base_ax, _base_bx, _length_end), lerp(_top_ax, _top_bx, _length_end), _bottom_amount);
            var _bottom_y2 = lerp(lerp(_base_ay, _base_by, _length_end), lerp(_top_ay, _top_by, _length_end), _bottom_amount);
            array_push(_batch, {
                color: _color,
                vertices: [
                    raid_environment_vertex(_top_x1, _top_y1, _top_height, 0, 0, _projection_x, _projection_y),
                    raid_environment_vertex(_top_x2, _top_y2, _top_height, _u_end, 0, _projection_x, _projection_y),
                    raid_environment_vertex(_bottom_x2, _bottom_y2, _bottom_height, _u_end, _v_end, _projection_x, _projection_y),
                    raid_environment_vertex(_bottom_x1, _bottom_y1, _bottom_height, 0, _v_end, _projection_x, _projection_y)
                ]
            });
        }
    }
}


function raid_environment_add_cap_rectangle(_geometry, _foreground,
    _left, _top, _right, _bottom, _height, _cap_color)
{
    var _tile_width = max(1, raid_environment.tile_width);
    var _tile_height = max(1, raid_environment.tile_height);
    var _caps = _foreground ? _geometry.front_caps : _geometry.back_caps;
    var _first_column = floor(_left / _tile_width);
    var _last_column = ceil(_right / _tile_width) - 1;
    var _first_row = floor(_top / _tile_height);
    var _last_row = ceil(_bottom / _tile_height) - 1;

    for (var _column = _first_column; _column <= _last_column; _column++)
    {
        var _tile_left = _column * _tile_width;
        var _x1 = max(_left, _tile_left);
        var _x2 = min(_right, _tile_left + _tile_width);
        var _u1 = (_x1 - _tile_left) / _tile_width;
        var _u2 = (_x2 - _tile_left) / _tile_width;

        for (var _row = _first_row; _row <= _last_row; _row++)
        {
            var _tile_top = _row * _tile_height;
            var _y1 = max(_top, _tile_top);
            var _y2 = min(_bottom, _tile_top + _tile_height);
            var _v1 = (_y1 - _tile_top) / _tile_height;
            var _v2 = (_y2 - _tile_top) / _tile_height;
            array_push(_caps, {
                color: _cap_color,
                vertices: [
                    raid_environment_vertex(_x1, _y1, _height, _u1, _v1, 0, 0),
                    raid_environment_vertex(_x2, _y1, _height, _u2, _v1, 0, 0),
                    raid_environment_vertex(_x2, _y2, _height, _u2, _v2, 0, 0),
                    raid_environment_vertex(_x1, _y2, _height, _u1, _v2, 0, 0)
                ]
            });
        }
    }
}


function raid_environment_vertex(_x, _y, _height, _u, _v, _projection_x = 0, _projection_y = -1)
{
    return {
        world_x: _x,
        world_y: _y,
        height: _height,
        projection_x: _projection_x,
        projection_y: _projection_y,
        u: _u,
        v: _v,
        draw_x: _x,
        draw_y: _y
    };
}
