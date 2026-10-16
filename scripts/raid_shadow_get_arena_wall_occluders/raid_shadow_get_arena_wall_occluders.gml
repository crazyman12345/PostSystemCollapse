function raid_shadow_get_arena_wall_occluders()
{
    var _wall_occluders = [];
    var _shelf_depth = max(0, raid_lighting_clip_offset);
    var _wall_depth = max(1, _shelf_depth);
    var _wall_height = 64;
    var _outer_left = raid_room_x1 - _shelf_depth;
    var _outer_top = raid_room_y1 - _shelf_depth;
    var _outer_right = raid_room_x2 + _shelf_depth;
    var _outer_bottom = raid_room_y2 + _shelf_depth;
    var _outer_width = _outer_right - _outer_left;
    var _outer_height = _outer_bottom - _outer_top;
    array_push(_wall_occluders, raid_shadow_occluder_rectangle(_outer_left - _wall_depth * 0.5, (_outer_top + _outer_bottom) * 0.5, _wall_depth, _outer_height + _wall_depth * 2, _wall_height));
    array_push(_wall_occluders, raid_shadow_occluder_rectangle(_outer_right + _wall_depth * 0.5, (_outer_top + _outer_bottom) * 0.5, _wall_depth, _outer_height + _wall_depth * 2, _wall_height));
    array_push(_wall_occluders, raid_shadow_occluder_rectangle((_outer_left + _outer_right) * 0.5, _outer_bottom + _wall_depth * 0.5, _outer_width, _wall_depth, _wall_height));


	var door_padding = 15;
    var _openings = [];
    if (raid.doors_active || raid.state == RaidState.EXITING)
    {
        var _door_lintel_depth = _wall_depth * 0.58;
        for (var _door_index = 0; _door_index < array_length(raid_doors); _door_index++)
        {
            var _door = raid_doors[_door_index];
            var _opening_left = max(raid_room_x1, _door.door_x - _door.door_w * 0.5 - door_padding);
            var _opening_right = min(raid_room_x2, _door.door_x + _door.door_w * 0.5 + door_padding);
            array_push(_openings, {left: _opening_left, right: _opening_right});
            array_push(_wall_occluders, raid_shadow_occluder_rectangle(
                (_opening_left + _opening_right) * 0.5,
                _outer_top - _wall_depth + _door_lintel_depth * 0.5,
                _opening_right - _opening_left,
                _door_lintel_depth,
                _wall_height
            ));
        }
        array_sort(_openings, function(_a, _b) { return _a.left - _b.left; });
    }

    var _segment_start = _outer_left;
    for (var _opening_index = 0; _opening_index < array_length(_openings); _opening_index++)
    {
        var _opening = _openings[_opening_index];
        if (_opening.left > _segment_start)
        {
            var _segment_width = _opening.left - _segment_start;
            array_push(_wall_occluders, raid_shadow_occluder_rectangle(
                _segment_start + _segment_width * 0.5, _outer_top - _wall_depth * 0.5,
                _segment_width, _wall_depth, _wall_height
            ));
        }
        _segment_start = max(_segment_start, _opening.right);
    }

    if (_segment_start < _outer_right)
    {
        var _last_segment_width = _outer_right - _segment_start;
        array_push(_wall_occluders, raid_shadow_occluder_rectangle(
            _segment_start + _last_segment_width * 0.5, _outer_top - _wall_depth * 0.5,
            _last_segment_width, _wall_depth, _wall_height
        ));
    }
    return _wall_occluders;
}
