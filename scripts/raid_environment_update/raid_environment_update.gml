function raid_environment_update()
{
    if (!raid_environment_geometry_is_current()) raid_environment_build();

    var _center_x = (raid_room_x1 + raid_room_x2) * 0.5;
    var _center_y = (raid_room_y1 + raid_room_y2) * 0.5;
    var _half_width = max(1, (raid_room_x2 - raid_room_x1) * 0.5);
    var _half_height = max(1, (raid_room_y2 - raid_room_y1) * 0.5);
    var _normalized_x = clamp((raid_player_x - _center_x) / _half_width, -1, 1);
    var _normalized_y = clamp((raid_player_y - _center_y) / _half_height, -1, 1);
    var _wall_height = max(1, raid_environment.wall_height);
    var _target_x = _normalized_x * raid_environment.perspective_strength_x / _wall_height;
    var _target_y = _normalized_y * raid_environment.perspective_strength_y / _wall_height;
    var _smoothing = clamp(raid_environment.perspective_smoothing, 0, 1);
    var _smooth_amount = 1 - power(1 - _smoothing, frame_scale);

    raid_environment.perspective_x = lerp(raid_environment.perspective_x, _target_x, _smooth_amount);
    raid_environment.perspective_y = lerp(raid_environment.perspective_y, _target_y, _smooth_amount);
    raid_environment_project_geometry();
}


function raid_environment_geometry_is_current()
{
    if (is_undefined(raid_environment.geometry)) return false;
    var _geometry = raid_environment.geometry;
    if (_geometry.room_x1 != raid_room_x1 || _geometry.room_y1 != raid_room_y1
    || _geometry.room_x2 != raid_room_x2 || _geometry.room_y2 != raid_room_y2
    || _geometry.wall_height != max(1, raid_environment.wall_height)
    || _geometry.wall_thickness != max(1, raid_environment.wall_thickness)
    || _geometry.vertical_projection != raid_environment.vertical_projection
    || _geometry.tile_width != raid_environment.tile_width
    || _geometry.tile_height != raid_environment.tile_height) return false;

    var _doors_visible = raid.doors_active || raid.state == RaidState.EXITING;
    var _expected_count = _doors_visible ? array_length(raid_doors) : 0;
    if (array_length(_geometry.openings) != _expected_count) return false;
    for (var _door_index = 0; _door_index < _expected_count; _door_index++)
    {
        var _door = raid_doors[_door_index];
        var _left = clamp(_door.door_x - _door.door_w * 0.5, raid_room_x1, raid_room_x2);
        var _right = clamp(_door.door_x + _door.door_w * 0.5, raid_room_x1, raid_room_x2);
        if (_geometry.openings[_door_index].left != _left || _geometry.openings[_door_index].right != _right) return false;
    }
    return true;
}


function raid_environment_project_geometry()
{
    if (is_undefined(raid_environment.geometry)) return;
    var _geometry = raid_environment.geometry;
    raid_environment_project_batch(_geometry.back_inner_faces);
    raid_environment_project_batch(_geometry.back_caps);
    raid_environment_project_batch(_geometry.front_inner_faces);
    raid_environment_project_batch(_geometry.front_caps);
}


function raid_environment_project_batch(_batch)
{
    for (var _quad_index = 0; _quad_index < array_length(_batch); _quad_index++)
    {
        var _vertices = _batch[_quad_index].vertices;
        for (var _vertex_index = 0; _vertex_index < 4; _vertex_index++)
            raid_environment_project(_vertices[_vertex_index]);
    }
}
