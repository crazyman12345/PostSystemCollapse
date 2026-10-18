function raid_environment_build()
{
    if (!variable_instance_exists(id, "raid_room_x1")) return;

    var _settings = raid_environment;
    var _height = max(1, _settings.wall_height);
    var _door_opening_height = clamp(_settings.door_opening_height, 0, _height);
    var _thickness = max(1, _settings.wall_thickness);
    var _projection_depth = _height * max(0, _settings.vertical_projection);
    var _openings = raid_environment_get_door_openings();
    var _segments = _settings.wall_segments;
    var _north_segments = max(1, floor(_segments.north));
    var _south_segments = max(1, floor(_segments.south));
    var _east_segments = max(1, floor(_segments.east));
    var _west_segments = max(1, floor(_segments.west));
    var _geometry = {
        room_x1: raid_room_x1,
        room_y1: raid_room_y1,
        room_x2: raid_room_x2,
        room_y2: raid_room_y2,
        wall_height: _height,
        door_opening_height: _door_opening_height,
        wall_thickness: _thickness,
        vertical_projection: _settings.vertical_projection,
        north_segments: _north_segments,
        south_segments: _south_segments,
        east_segments: _east_segments,
        west_segments: _west_segments,
        openings: _openings,
        back_inner_faces: [],
        back_caps: [],
        front_inner_faces: [],
        front_caps: []
    };
    var _inner_face_color = make_color_rgb(190, 194, 198);
    var _cap_color = make_color_rgb(190, 194, 198);
    var _room_width = raid_room_x2 - raid_room_x1;
    var _door_segments = array_create(_north_segments, false);
    for (var _opening_index = 0; _opening_index < array_length(_openings); _opening_index++)
    {
        var _opening = _openings[_opening_index];
        for (var _segment_index = 0; _segment_index < _north_segments; _segment_index++)
        {
            var _segment_left = raid_room_x1 + _room_width * _segment_index / _north_segments;
            var _segment_right = raid_room_x1 + _room_width * (_segment_index + 1) / _north_segments;
            if (_opening.right > _segment_left && _opening.left < _segment_right)
                _door_segments[_segment_index] = true;
        }
    }

    // Cut door openings from the north inner face while keeping the top caps continuous.
    var _span_start = raid_room_x1;
    for (var _opening_index = 0; _opening_index <= array_length(_openings); _opening_index++)
    {
        var _span_end = _opening_index < array_length(_openings)
            ? _openings[_opening_index].left
            : raid_room_x2;
        if (_span_end > _span_start)
        {
            var _at_left_corner = _span_start == raid_room_x1;
            var _at_right_corner = _span_end == raid_room_x2;
            var _top_start = _span_start - (_at_left_corner ? _projection_depth : 0);
            var _top_end = _span_end + (_at_right_corner ? _projection_depth : 0);
            var _fraction_start = (_span_start - raid_room_x1) / _room_width;
            var _fraction_end = (_span_end - raid_room_x1) / _room_width;
            raid_environment_add_inner_face_sections(_geometry.back_inner_faces,
                _top_start, raid_room_y1, _top_end, raid_room_y1,
                _span_start, raid_room_y1, _span_end, raid_room_y1,
                _height, _inner_face_color, 0, -1,
                _fraction_start, _fraction_end, _north_segments,
                0, 0, 1, _door_segments);
        }

        if (_opening_index < array_length(_openings))
            _span_start = _openings[_opening_index].right;
    }

    if (_door_opening_height < _height)
    {
        var _lintel_v = 1 - _door_opening_height / _height;
        for (var _opening_index = 0; _opening_index < array_length(_openings); _opening_index++)
        {
            var _opening = _openings[_opening_index];
            var _fraction_start = (_opening.left - raid_room_x1) / _room_width;
            var _fraction_end = (_opening.right - raid_room_x1) / _room_width;
            raid_environment_add_inner_face_sections(_geometry.back_inner_faces,
                _opening.left, raid_room_y1, _opening.right, raid_room_y1,
                _opening.left, raid_room_y1, _opening.right, raid_room_y1,
                _height, _inner_face_color, 0, -1,
                _fraction_start, _fraction_end, _north_segments,
                _door_opening_height, 0, _lintel_v, _door_segments);
        }
    }
    raid_environment_add_cap_sections(_geometry, false,
        raid_room_x1 - _projection_depth - _thickness,
        raid_room_y1 - _projection_depth - _thickness,
        raid_room_x2 + _projection_depth + _thickness,
        raid_room_y1 - _projection_depth,
        _height, _cap_color, true, 0, 1, _north_segments);

    // South remains in the foreground pass so the inward-facing wall can
    // overlap actors at the southern boundary.
    raid_environment_add_inner_face_sections(_geometry.front_inner_faces,
        raid_room_x1 - _projection_depth, raid_room_y2,
        raid_room_x2 + _projection_depth, raid_room_y2,
        raid_room_x1, raid_room_y2, raid_room_x2, raid_room_y2,
        _height, _inner_face_color, 0, 1, 0, 1, _south_segments);
    raid_environment_add_cap_sections(_geometry, true,
        raid_room_x1 - _projection_depth - _thickness,
        raid_room_y2 + _projection_depth,
        raid_room_x2 + _projection_depth + _thickness,
        raid_room_y2 + _projection_depth + _thickness,
        _height, _cap_color, true, 0, 1, _south_segments);

    raid_environment_add_inner_face_sections(_geometry.back_inner_faces,
        raid_room_x1, raid_room_y1 - _projection_depth,
        raid_room_x1, raid_room_y2 + _projection_depth,
        raid_room_x1, raid_room_y1, raid_room_x1, raid_room_y2,
        _height, _inner_face_color, -1, 0, 0, 1, _west_segments);
    raid_environment_add_cap_sections(_geometry, false,
        raid_room_x1 - _projection_depth - _thickness,
        raid_room_y1 - _projection_depth,
        raid_room_x1 - _projection_depth,
        raid_room_y2 + _projection_depth,
        _height, _cap_color, false, 0, 1, _west_segments);

    raid_environment_add_inner_face_sections(_geometry.back_inner_faces,
        raid_room_x2, raid_room_y1 - _projection_depth,
        raid_room_x2, raid_room_y2 + _projection_depth,
        raid_room_x2, raid_room_y1, raid_room_x2, raid_room_y2,
        _height, _inner_face_color, 1, 0, 0, 1, _east_segments);
    raid_environment_add_cap_sections(_geometry, false,
        raid_room_x2 + _projection_depth,
        raid_room_y1 - _projection_depth,
        raid_room_x2 + _projection_depth + _thickness,
        raid_room_y2 + _projection_depth,
        _height, _cap_color, false, 0, 1, _east_segments);

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


function raid_environment_add_inner_face_sections(_batch,
    _top_ax, _top_ay, _top_bx, _top_by,
    _base_ax, _base_ay, _base_bx, _base_by,
    _height, _color, _projection_x, _projection_y,
    _span_start, _span_end, _segment_count,
    _base_height = 0, _v_start = 0, _v_end = 1, _door_segments = undefined)
{
    if (_span_end <= _span_start || _height <= 0) return;

    for (var _segment_index = 0; _segment_index < _segment_count; _segment_index++)
    {
        var _segment_start = _segment_index / _segment_count;
        var _segment_end = (_segment_index + 1) / _segment_count;
        var _section_start = max(_span_start, _segment_start);
        var _section_end = min(_span_end, _segment_end);
        if (_section_end <= _section_start) continue;

        var _local_start = (_section_start - _span_start) / (_span_end - _span_start);
        var _local_end = (_section_end - _span_start) / (_span_end - _span_start);
        var _u_start = (_section_start - _segment_start) * _segment_count;
        var _u_end = (_section_end - _segment_start) * _segment_count;
        if (_projection_x < 0 || _projection_y < 0)
        {
            _u_start = 1 - _u_start;
            _u_end = 1 - _u_end;
        }
        var _section_top_ax = lerp(_top_ax, _top_bx, _local_start);
        var _section_top_ay = lerp(_top_ay, _top_by, _local_start);
        var _section_top_bx = lerp(_top_ax, _top_bx, _local_end);
        var _section_top_by = lerp(_top_ay, _top_by, _local_end);
        var _section_base_ax = lerp(_base_ax, _base_bx, _local_start);
        var _section_base_ay = lerp(_base_ay, _base_by, _local_start);
        var _section_base_bx = lerp(_base_ax, _base_bx, _local_end);
        var _section_base_by = lerp(_base_ay, _base_by, _local_end);

        array_push(_batch, {
            color: _color,
            door_segment: is_array(_door_segments) && _door_segments[_segment_index],
            material_index: irandom(array_length(raid_environment.inner_face_materials) - 1),
            vertices: [
                raid_environment_vertex(_section_top_ax, _section_top_ay, _height, _u_start, _v_start, _projection_x, _projection_y),
                raid_environment_vertex(_section_top_bx, _section_top_by, _height, _u_end, _v_start, _projection_x, _projection_y),
                raid_environment_vertex(_section_base_bx, _section_base_by, _base_height, _u_end, _v_end, _projection_x, _projection_y),
                raid_environment_vertex(_section_base_ax, _section_base_ay, _base_height, _u_start, _v_end, _projection_x, _projection_y)
            ]
        });
    }
}


function raid_environment_add_cap_sections(_geometry, _foreground,
    _left, _top, _right, _bottom, _height, _color, _horizontal,
    _span_start, _span_end, _segment_count)
{
    var _caps = _foreground ? _geometry.front_caps : _geometry.back_caps;
    for (var _segment_index = 0; _segment_index < _segment_count; _segment_index++)
    {
        var _segment_start = _segment_index / _segment_count;
        var _segment_end = (_segment_index + 1) / _segment_count;
        var _section_start = max(_span_start, _segment_start);
        var _section_end = min(_span_end, _segment_end);
        if (_section_end <= _section_start) continue;

        var _local_start = (_section_start - _span_start) / (_span_end - _span_start);
        var _local_end = (_section_end - _span_start) / (_span_end - _span_start);
        var _uv_start = (_section_start - _segment_start) * _segment_count;
        var _uv_end = (_section_end - _segment_start) * _segment_count;
        var _inner_left = _left + (_horizontal && _span_start == 0 ? _geometry.wall_thickness : 0);
        var _inner_right = _right - (_horizontal && _span_end == 1 ? _geometry.wall_thickness : 0);
        var _x1 = _horizontal ? lerp(_inner_left, _inner_right, _local_start) : _left;
        var _x2 = _horizontal ? lerp(_inner_left, _inner_right, _local_end) : _right;
        if (_horizontal && _section_start == 0) _x1 = _left;
        if (_horizontal && _section_end == 1) _x2 = _right;
        var _y1 = _horizontal ? _top : lerp(_top, _bottom, _local_start);
        var _y2 = _horizontal ? _bottom : lerp(_top, _bottom, _local_end);
        array_push(_caps, {
            color: _color,
            vertices: _horizontal
                ? [
                    raid_environment_vertex(_x1, _y1, _height, _uv_start, 0, 0, 0),
                    raid_environment_vertex(_x2, _y1, _height, _uv_end, 0, 0, 0),
                    raid_environment_vertex(_x2, _y2, _height, _uv_end, 1, 0, 0),
                    raid_environment_vertex(_x1, _y2, _height, _uv_start, 1, 0, 0)
                ]
                : [
                    raid_environment_vertex(_x1, _y1, _height, 0, _uv_start, 0, 0),
                    raid_environment_vertex(_x2, _y1, _height, 1, _uv_start, 0, 0),
                    raid_environment_vertex(_x2, _y2, _height, 1, _uv_end, 0, 0),
                    raid_environment_vertex(_x1, _y2, _height, 0, _uv_end, 0, 0)
                ]
        });
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
