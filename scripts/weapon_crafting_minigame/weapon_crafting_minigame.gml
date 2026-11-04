function weapon_crafting_minigame_init()
{
    crafting_minigame_state = {
        active: false,
        phase: 0,
        skill_key: "",
        recipe: undefined,
        outline: undefined,
        checkpoint_hits: [],
        checkpoint_completed: 0,
        cut_trail: [],
        cut_active: false,
        plate_chunks: [],
        accuracy_total: 0,
        accuracy_samples: 0,
        drift_penalties: 0,
        hammer_hits: [],
        hammer_hit_count: 0,
        hammer_misses: 0,
        transition_timer: 0,
        impact_timer: 0,
        shake: 0,
        sparks: [],
        spark_emit_timer: 0,
        final_score: 0,
        crafted_item: undefined
    };
}

function weapon_crafting_outline_get(_outline_key)
{
    var _sprite = -1;
    var _shape = "pistol";
    var _process = "metal";
    switch (_outline_key)
    {
        case "pipe_pistol": _sprite = spr_pipe_pistol; break;
        case "m1911": _sprite = spr_1911; break;
        case "glock17": _sprite = spr_glock17; break;
        case "double_barrel_shotgun": _sprite = spr_double_barrel; _shape = "long_gun"; break;
        case "pump_shotgun": _sprite = spr_pump_shotgun; _shape = "long_gun"; break;
        case "mosin_nagant": _sprite = spr_mosin_nagant; _shape = "long_gun"; break;
        case "akm": _sprite = spr_akm; _shape = "rifle"; break;
        case "g3": _sprite = spr_g3; _shape = "rifle"; break;
        case "ppsh_41": _sprite = spr_ppsh; _shape = "smg"; break;
        case "uzi": _sprite = spr_uzi; _shape = "smg"; break;
        case "paca": _sprite = spr_PACA; _shape = "vest"; _process = "fabric"; break;
        case "police_soft_armor": _sprite = spr_policevest; _shape = "vest"; _process = "fabric"; break;
        case "construction_helmet": _sprite = spr_conshelmet; _shape = "helmet"; _process = "armor"; break;
        case "riot_helmet": _sprite = spr_riothelmet; _shape = "helmet"; _process = "armor"; break;
        case "improvised_steel_helmet": _shape = "helmet"; _process = "armor"; break;
        case "sling_bag": _sprite = spr_sling_bag; _shape = "bag"; _process = "fabric"; break;
        case "school_backpack": _sprite = spr_schoolbag; _shape = "bag"; _process = "fabric"; break;
        case "small_hiking_pack": _sprite = spr_hikingbag; _shape = "bag"; _process = "fabric"; break;
        default: return undefined;
    }

    var _vertices = _process == "metal"
        ? weapon_crafting_gun_vertices(_outline_key)
        : weapon_crafting_shape_vertices(_shape);
    var _checkpoints = [];
    for (var _i = 0; _i < array_length(_vertices) - 1; _i++)
    {
        var _from = _vertices[_i];
        var _to = _vertices[_i + 1];
        var _steps = max(1, ceil(point_distance(_from.x, _from.y, _to.x, _to.y) / 24));
        for (var _step = 0; _step < _steps; _step++)
        {
            var _amount = _step / _steps;
            array_push(_checkpoints, { x: lerp(_from.x, _to.x, _amount), y: lerp(_from.y, _to.y, _amount) });
        }
    }
    return {
        key: _outline_key,
        result_sprite: _sprite,
        shape: _shape,
        process: _process,
        vertices: _vertices,
        checkpoints: _checkpoints,
        hammer_markers: _process == "metal"
            ? weapon_crafting_gun_markers(_shape, _vertices)
            : weapon_crafting_shape_markers(_shape),
        tolerance: _process == "fabric" ? 52 : 46
    };
}

function weapon_crafting_gun_vertices(_outline_key)
{
    switch (_outline_key)
    {
        case "pipe_pistol": return [
            { x: 265, y: -150 }, { x: 292, y: -144 }, { x: 292, y: -110 }, { x: 324, y: -98 },
            { x: 313, y: -37 }, { x: 236, y: -37 }, { x: 229, y: -24 }, { x: 204, y: -24 },
            { x: 204, y: -37 }, { x: 139, y: -37 }, { x: 128, y: 5 }, { x: 77, y: 5 },
            { x: 77, y: -24 }, { x: 5, y: -37 }, { x: 5, y: -23 }, { x: -37, y: -17 },
            { x: -37, y: 43 }, { x: -57, y: 63 }, { x: -133, y: 63 }, { x: -154, y: 22 },
            { x: -168, y: 22 }, { x: -217, y: 150 }, { x: -250, y: 150 }, { x: -324, y: 117 },
            { x: -238, y: -64 }, { x: -217, y: -77 }, { x: -222, y: -102 }, { x: -238, y: -109 },
            { x: -237, y: -136 }, { x: -210, y: -136 }, { x: -202, y: -118 }, { x: -125, y: -136 },
            { x: -125, y: -123 }, { x: -30, y: -123 }, { x: -3, y: -111 }, { x: 123, y: -122 },
            { x: 129, y: -110 }, { x: 261, y: -110 }, { x: 265, y: -150 }
        ];
        case "m1911": return [
            { x: -196, y: -203 }, { x: -174, y: -183 }, { x: -27, y: -175 }, { x: 273, y: -183 },
            { x: 273, y: -194 }, { x: 298, y: -194 }, { x: 323, y: -168 }, { x: 323, y: -80 },
            { x: 306, y: -68 }, { x: 60, y: -57 }, { x: 28, y: 17 }, { x: -94, y: 23 },
            { x: -139, y: 165 }, { x: -130, y: 203 }, { x: -246, y: 193 }, { x: -324, y: 165 },
            { x: -273, y: 50 }, { x: -281, y: 26 }, { x: -266, y: 1 }, { x: -272, y: -38 },
            { x: -308, y: -50 }, { x: -321, y: -80 }, { x: -261, y: -103 }, { x: -268, y: -132 },
            { x: -294, y: -150 }, { x: -289, y: -162 }, { x: -248, y: -151 }, { x: -237, y: -177 },
            { x: -196, y: -203 }
        ];
        case "glock17": return [
            { x: -191, y: -161 }, { x: -167, y: -160 }, { x: -157, y: -141 }, { x: 159, y: -141 },
            { x: 165, y: -155 }, { x: 195, y: -155 }, { x: 230, y: -121 }, { x: 230, y: -78 },
            { x: 217, y: -78 }, { x: 208, y: -34 }, { x: 88, y: -28 }, { x: 69, y: 49 },
            { x: -63, y: 42 }, { x: -114, y: 171 }, { x: -210, y: 171 }, { x: -235, y: 144 },
            { x: -235, y: 110 }, { x: -180, y: -21 }, { x: -234, y: -51 }, { x: -235, y: -75 },
            { x: -231, y: -133 }, { x: -203, y: -140 }, { x: -203, y: -160 }, { x: -191, y: -161 }
        ];
        case "double_barrel_shotgun": return [
            { x: -84, y: -71 }, { x: -59, y: -57 }, { x: 315, y: -61 }, { x: 323, y: -6 },
            { x: 215, y: 0 }, { x: 171, y: 16 }, { x: -30, y: 1 }, { x: -49, y: 33 },
            { x: -91, y: 33 }, { x: -116, y: 11 }, { x: -142, y: 43 }, { x: -190, y: 29 },
            { x: -218, y: 53 }, { x: -310, y: 71 }, { x: -324, y: 15 }, { x: -314, y: -21 },
            { x: -171, y: -38 }, { x: -143, y: -18 }, { x: -77, y: -44 }, { x: -84, y: -71 }
        ];
        case "pump_shotgun": return [
            { x: 297, y: -68 }, { x: 323, y: -53 }, { x: 323, y: -30 }, { x: 269, y: -28 },
            { x: 294, y: -21 }, { x: 290, y: -1 }, { x: 178, y: 10 }, { x: -57, y: -1 },
            { x: -73, y: 19 }, { x: -109, y: 19 }, { x: -125, y: -3 }, { x: -158, y: 33 },
            { x: -193, y: 24 }, { x: -288, y: 65 }, { x: -320, y: 61 }, { x: -323, y: -12 },
            { x: -289, y: -25 }, { x: -190, y: -33 }, { x: -173, y: -21 }, { x: -78, y: -61 },
            { x: 292, y: -56 }, { x: 297, y: -68 }
        ];
        case "mosin_nagant": return [
            { x: -1, y: -58 }, { x: 53, y: -43 }, { x: 268, y: -40 }, { x: 294, y: -41 },
            { x: 294, y: -57 }, { x: 310, y: -58 }, { x: 321, y: -24 }, { x: 274, y: -24 },
            { x: 250, y: -8 }, { x: -37, y: -2 }, { x: -115, y: 30 }, { x: -149, y: 30 },
            { x: -159, y: 4 }, { x: -196, y: 31 }, { x: -299, y: 57 }, { x: -323, y: 52 },
            { x: -323, y: -8 }, { x: -304, y: -19 }, { x: -186, y: -15 }, { x: -142, y: -51 },
            { x: -2, y: -47 }, { x: -1, y: -58 }
        ];
        case "ppsh_41": return [
            { x: 249, y: -87 }, { x: 272, y: -82 }, { x: 272, y: -61 }, { x: 315, y: -61 },
            { x: 309, y: -27 }, { x: 87, y: -12 }, { x: 87, y: 68 }, { x: 70, y: 94 },
            { x: 30, y: 89 }, { x: 15, y: 5 }, { x: -24, y: 14 }, { x: -35, y: 45 },
            { x: -84, y: 45 }, { x: -102, y: 14 }, { x: -131, y: 51 }, { x: -171, y: 45 },
            { x: -275, y: 91 }, { x: -308, y: 84 }, { x: -313, y: 7 }, { x: -303, y: -5 },
            { x: -202, y: -25 }, { x: -145, y: -14 }, { x: -105, y: -38 }, { x: -100, y: -56 },
            { x: -30, y: -62 }, { x: -13, y: -79 }, { x: 4, y: -79 }, { x: 25, y: -56 },
            { x: 235, y: -61 }, { x: 249, y: -87 }
        ];
        case "uzi": return [
            { x: -262, y: -214 }, { x: -234, y: -214 }, { x: -199, y: -151 }, { x: -128, y: -162 },
            { x: -120, y: -151 }, { x: 70, y: -150 }, { x: 81, y: -177 }, { x: 111, y: -177 },
            { x: 122, y: -170 }, { x: 115, y: -151 }, { x: 156, y: -151 }, { x: 164, y: -138 },
            { x: 214, y: -143 }, { x: 221, y: -199 }, { x: 236, y: -199 }, { x: 251, y: -183 },
            { x: 256, y: -130 }, { x: 308, y: -122 }, { x: 315, y: -90 }, { x: 256, y: -82 },
            { x: 248, y: -67 }, { x: 207, y: -59 }, { x: 164, y: -62 }, { x: 164, y: -41 },
            { x: 135, y: -32 }, { x: 23, y: -40 }, { x: 22, y: 2 }, { x: 4, y: 20 },
            { x: -38, y: 20 }, { x: -55, y: 3 }, { x: -79, y: 89 }, { x: -73, y: 212 },
            { x: -146, y: 213 }, { x: -142, y: 89 }, { x: -158, y: 76 }, { x: -158, y: 46 },
            { x: -129, y: -38 }, { x: -151, y: -60 }, { x: -285, y: -60 }, { x: -299, y: -42 },
            { x: -315, y: -49 }, { x: -307, y: -137 }, { x: -286, y: -151 }, { x: -286, y: -190 },
            { x: -262, y: -214 }
        ];
        case "akm": return [
            { x: 9, y: -45 }, { x: 136, y: -34 }, { x: 151, y: -16 }, { x: 178, y: -16 },
            { x: 183, y: -41 }, { x: 198, y: -45 }, { x: 198, y: -20 }, { x: 215, y: -16 },
            { x: 195, y: 1 }, { x: 12, y: 8 }, { x: 48, y: 59 }, { x: 31, y: 89 },
            { x: -13, y: 54 }, { x: -21, y: 22 }, { x: -67, y: 29 }, { x: -80, y: 66 },
            { x: -105, y: 62 }, { x: -95, y: 10 }, { x: -206, y: 42 }, { x: -210, y: -11 },
            { x: -197, y: -18 }, { x: -111, y: -15 }, { x: -89, y: -34 }, { x: 3, y: -34 },
            { x: 9, y: -45 }
        ];
        case "g3": return [
            { x: 216, y: -69 }, { x: 236, y: -63 }, { x: 236, y: -26 }, { x: 316, y: -31 },
            { x: 316, y: -5 }, { x: 12, y: 3 }, { x: 8, y: 68 }, { x: -18, y: 76 },
            { x: -51, y: 78 }, { x: -52, y: 22 }, { x: -65, y: 43 }, { x: -113, y: 37 },
            { x: -129, y: 80 }, { x: -163, y: 75 }, { x: -169, y: 59 }, { x: -144, y: 8 },
            { x: -217, y: 15 }, { x: -292, y: 57 }, { x: -317, y: 50 }, { x: -312, y: -27 },
            { x: -208, y: -23 }, { x: -134, y: -64 }, { x: -97, y: -49 }, { x: 215, y: -44 },
            { x: 216, y: -69 }
        ];
    }
    return weapon_crafting_shape_vertices("pistol");
}

function weapon_crafting_shape_vertices(_shape)
{
    switch (_shape)
    {
        case "long_gun": return [
            { x: -330, y: -55 }, { x: 265, y: -55 }, { x: 330, y: -35 }, { x: 330, y: -5 },
            { x: 90, y: 8 }, { x: 55, y: 36 }, { x: 34, y: 118 }, { x: -35, y: 112 },
            { x: -45, y: 28 }, { x: -210, y: 30 }, { x: -330, y: 5 }, { x: -330, y: -55 }
        ];
        case "rifle": return [
            { x: -330, y: -62 }, { x: 260, y: -62 }, { x: 330, y: -35 }, { x: 325, y: -2 },
            { x: 95, y: 10 }, { x: 60, y: 42 }, { x: 74, y: 118 }, { x: 0, y: 128 },
            { x: -42, y: 36 }, { x: -190, y: 34 }, { x: -330, y: 12 }, { x: -330, y: -62 }
        ];
        case "smg": return [
            { x: -260, y: -72 }, { x: 235, y: -72 }, { x: 290, y: -38 }, { x: 282, y: 0 },
            { x: 95, y: 18 }, { x: 102, y: 142 }, { x: 24, y: 150 }, { x: -8, y: 32 },
            { x: -180, y: 30 }, { x: -260, y: 2 }, { x: -260, y: -72 }
        ];
        case "vest": return [
            { x: -150, y: -205 }, { x: -58, y: -225 }, { x: -28, y: -155 }, { x: 28, y: -155 },
            { x: 58, y: -225 }, { x: 150, y: -205 }, { x: 205, y: 190 }, { x: 72, y: 220 },
            { x: 0, y: 185 }, { x: -72, y: 220 }, { x: -205, y: 190 }, { x: -150, y: -205 }
        ];
        case "helmet": return [
            { x: -220, y: 70 }, { x: -195, y: -65 }, { x: -125, y: -160 }, { x: 0, y: -205 },
            { x: 125, y: -160 }, { x: 195, y: -65 }, { x: 220, y: 70 }, { x: 145, y: 105 },
            { x: 98, y: 175 }, { x: 35, y: 175 }, { x: 18, y: 80 }, { x: -220, y: 70 }
        ];
        case "bag": return [
            { x: -155, y: -190 }, { x: -92, y: -230 }, { x: 92, y: -230 }, { x: 155, y: -190 },
            { x: 185, y: 210 }, { x: 95, y: 235 }, { x: -95, y: 235 }, { x: -185, y: 210 },
            { x: -155, y: -190 }
        ];
    }
    return [
        { x: -310, y: -88 }, { x: 220, y: -88 }, { x: 300, y: -55 }, { x: 315, y: -12 },
        { x: 250, y: 12 }, { x: 112, y: 18 }, { x: 92, y: 52 }, { x: 72, y: 88 },
        { x: 104, y: 174 }, { x: 18, y: 184 }, { x: -34, y: 66 }, { x: -82, y: 22 },
        { x: -258, y: 22 }, { x: -310, y: -12 }, { x: -310, y: -88 }
    ];
}

function weapon_crafting_shape_markers(_shape)
{
    switch (_shape)
    {
        case "vest": return [{ x: -105, y: -105 }, { x: 105, y: -105 }, { x: -105, y: 120 }, { x: 105, y: 120 }];
        case "helmet": return [{ x: -125, y: -70 }, { x: 0, y: -135 }, { x: 125, y: -70 }, { x: 75, y: 75 }];
        case "bag": return [{ x: -105, y: -120 }, { x: 105, y: -120 }, { x: -105, y: 130 }, { x: 105, y: 130 }];
        case "long_gun": return [{ x: -230, y: -25 }, { x: -60, y: -20 }, { x: 110, y: -25 }, { x: 255, y: -25 }];
        case "rifle": return [{ x: -230, y: -25 }, { x: -60, y: -20 }, { x: 110, y: -25 }, { x: 255, y: -25 }];
        case "smg": return [{ x: -170, y: -30 }, { x: -20, y: -25 }, { x: 145, y: -25 }, { x: 62, y: 92 }];
    }
    return [{ x: -190, y: -32 }, { x: 42, y: -34 }, { x: 220, y: -30 }, { x: 48, y: 116 }];
}

function weapon_crafting_gun_markers(_shape, _vertices)
{
    var _target_count = 3;
    if (_shape == "smg") _target_count = 4;
    else if (_shape == "long_gun" || _shape == "rifle") _target_count = 5;

    var _left = 100000;
    var _right = -100000;
    var _top = 100000;
    var _bottom = -100000;
    for (var _i = 0; _i < array_length(_vertices); _i++)
    {
        _left = min(_left, _vertices[_i].x);
        _right = max(_right, _vertices[_i].x);
        _top = min(_top, _vertices[_i].y);
        _bottom = max(_bottom, _vertices[_i].y);
    }

    var _candidates = [];
    var _marker_inset = 14;
    for (var _y = _top + _marker_inset; _y <= _bottom - _marker_inset; _y += 18)
    {
        for (var _x = _left + _marker_inset; _x <= _right - _marker_inset; _x += 18)
        {
            if (!weapon_crafting_point_in_outline(_x, _y, _vertices)
            || !weapon_crafting_point_in_outline(_x - _marker_inset, _y, _vertices)
            || !weapon_crafting_point_in_outline(_x + _marker_inset, _y, _vertices)
            || !weapon_crafting_point_in_outline(_x, _y - _marker_inset, _vertices)
            || !weapon_crafting_point_in_outline(_x, _y + _marker_inset, _vertices)) continue;
            array_push(_candidates, { x: _x, y: _y });
        }
    }

    var _markers = [];
    var _center_x = (_left + _right) * 0.5;
    var _center_y = (_top + _bottom) * 0.5;
    while (array_length(_markers) < _target_count && array_length(_candidates) > 0)
    {
        var _best_index = -1;
        var _best_score = -100000;
        for (var _candidate_index = 0; _candidate_index < array_length(_candidates); _candidate_index++)
        {
            var _candidate = _candidates[_candidate_index];
            var _score = -point_distance(_candidate.x, _candidate.y, _center_x, _center_y);
            if (array_length(_markers) > 0)
            {
                _score = 100000;
                for (var _marker_index = 0; _marker_index < array_length(_markers); _marker_index++)
                    _score = min(_score, point_distance(_candidate.x, _candidate.y,
                        _markers[_marker_index].x, _markers[_marker_index].y));
                if (_score < 72) continue;
            }
            if (_score > _best_score)
            {
                _best_score = _score;
                _best_index = _candidate_index;
            }
        }

        if (_best_index < 0) break;
        array_push(_markers, _candidates[_best_index]);
        array_delete(_candidates, _best_index, 1);
    }
    return _markers;
}

function weapon_crafting_point_in_outline(_x, _y, _vertices)
{
    var _inside = false;
    var _previous = array_length(_vertices) - 1;
    for (var _i = 0; _i < array_length(_vertices); _i++)
    {
        var _a = _vertices[_i];
        var _b = _vertices[_previous];
        if (((_a.y > _y) != (_b.y > _y))
        && (_x < (_b.x - _a.x) * (_y - _a.y) / (_b.y - _a.y) + _a.x))
            _inside = !_inside;
        _previous = _i;
    }
    return _inside;
}

function weapon_crafting_distance_to_outline(_x, _y, _vertices)
{
    var _closest_distance = 100000;
    for (var _i = 0; _i < array_length(_vertices) - 1; _i++)
    {
        var _from = _vertices[_i];
        var _to = _vertices[_i + 1];
        _closest_distance = min(_closest_distance, weapon_crafting_distance_to_segment(
            _x, _y, _from.x, _from.y, _to.x, _to.y));
    }
    return _closest_distance;
}

function weapon_crafting_distance_to_segment(_x, _y, _from_x, _from_y, _to_x, _to_y)
{
    var _segment_x = _to_x - _from_x;
    var _segment_y = _to_y - _from_y;
    var _segment_length_squared = _segment_x * _segment_x + _segment_y * _segment_y;
    var _amount = _segment_length_squared > 0
        ? clamp(((_x - _from_x) * _segment_x + (_y - _from_y) * _segment_y)
            / _segment_length_squared, 0, 1)
        : 0;
    return point_distance(_x, _y,
        _from_x + _segment_x * _amount, _from_y + _segment_y * _amount);
}

function weapon_crafting_plate_chunks_create(_layout, _outline)
{
    var _chunks = [];
    var _columns = 10;
    var _rows = 7;
    var _chunk_width = (_layout.plate_right - _layout.plate_left) / _columns;
    var _chunk_height = (_layout.plate_bottom - _layout.plate_top) / _rows;
    for (var _row = 0; _row < _rows; _row++)
    {
        for (var _column = 0; _column < _columns; _column++)
        {
            var _left = _layout.plate_left + _column * _chunk_width;
            var _top = _layout.plate_top + _row * _chunk_height;
            var _center_x = _left + _chunk_width * 0.5;
            var _center_y = _top + _chunk_height * 0.5;
            if (weapon_crafting_point_in_outline(_center_x - _layout.center_x,
                _center_y - _layout.center_y, _outline.vertices)) continue;

            var _direction = point_direction(_layout.center_x, _layout.center_y, _center_x, _center_y)
                + random_range(-18, 18);
            var _speed = random_range(4.5, 9.5);
            array_push(_chunks, {
                x: _center_x,
                y: _center_y,
                width: _chunk_width + 1,
                height: _chunk_height + 1,
                dx: lengthdir_x(_speed, _direction),
                dy: lengthdir_y(_speed, _direction),
                rotation: 0,
                rotation_speed: random_range(-7, 7),
                life: random_range(48, 78),
                max_life: 78
            });
        }
    }
    return _chunks;
}

function weapon_crafting_layout()
{
    var _left = 340;
    var _right = display_get_gui_width() - 20;
    var _top = 82;
    var _bottom = display_get_gui_height() - 20;
    return {
        left: _left,
        right: _right,
        top: _top,
        bottom: _bottom,
        center_x: (_left + _right) * 0.5,
        center_y: (_top + _bottom) * 0.5 + 20,
        plate_left: _left + 90,
        plate_right: _right - 90,
        plate_top: _top + 105,
        plate_bottom: _bottom - 105
    };
}

function weapon_crafting_output_fits(_item_key)
{
    for (var _y = 0; _y < stash.grid_height; _y++)
    {
        for (var _x = 0; _x < stash.grid_width; _x++)
        {
            if (stash_item_fits(_item_key, _x, _y, 0, stash)
            || stash_item_fits(_item_key, _x, _y, 90, stash)) return true;
        }
    }
    return false;
}

function weapon_crafting_minigame_start(_skill_key, _recipe)
{
    if (!variable_struct_exists(_recipe, "crafting_minigame")) return false;
    var _outline = weapon_crafting_outline_get(_recipe.crafting_minigame);
    if (is_undefined(_outline) || !recipe_can_craft(_skill_key, _recipe)) return false;
    if (!weapon_crafting_output_fits(_recipe.output.item_key)) return false;

    for (var _i = 0; _i < array_length(_recipe.ingredients); _i++)
    {
        var _ingredient = _recipe.ingredients[_i];
        stash_remove(_ingredient.item_key, _ingredient.quantity);
    }

    weapon_crafting_minigame_init();
    crafting_minigame_state.active = true;
    crafting_minigame_state.phase = 1;
    crafting_minigame_state.skill_key = _skill_key;
    crafting_minigame_state.recipe = _recipe;
    crafting_minigame_state.outline = _outline;
    for (var _marker = 0; _marker < array_length(_outline.hammer_markers); _marker++)
        array_push(crafting_minigame_state.hammer_hits, false);
    for (var _checkpoint = 0; _checkpoint < array_length(_outline.checkpoints); _checkpoint++)
        array_push(crafting_minigame_state.checkpoint_hits, false);
    crafting_message = "";
    audio_play_sound(snd_interact, 0, false);
    save_mark_dirty();
    return true;
}

function weapon_crafting_minigame_cancel()
{
    var _recipe = crafting_minigame_state.recipe;
    if (is_struct(_recipe))
    {
        for (var _i = 0; _i < array_length(_recipe.ingredients); _i++)
        {
            var _ingredient = _recipe.ingredients[_i];
            stash_add(_ingredient.item_key, _ingredient.quantity);
        }
    }
    weapon_crafting_minigame_init();
    crafting_message = "CRAFTING CANCELLED - MATERIALS RETURNED";
}

function weapon_crafting_minigame_finish()
{
    var _game = crafting_minigame_state;
    var _accuracy = _game.accuracy_samples > 0
        ? (_game.accuracy_total / _game.accuracy_samples) * 100
        : 0;
    var _completion = array_length(_game.outline.checkpoints) > 0
        ? (_game.checkpoint_completed / array_length(_game.outline.checkpoints)) * 100
        : 0;
    var _hammer = (_game.hammer_hit_count / array_length(_game.hammer_hits)) * 100;
    _game.final_score = clamp(round(_accuracy * 0.65 + _completion * 0.20 + _hammer * 0.15), 0, 100);

    var _quality = _game.final_score / 100;
    var _crafted_chances = [
        { rarity: "common", chance: lerp(88, 25, _quality) },
        { rarity: "rare", chance: lerp(10, 35, _quality) },
        { rarity: "very_rare", chance: lerp(1.5, 22, _quality) },
        { rarity: "epic", chance: lerp(0.4, 13, _quality) },
        { rarity: "legendary", chance: lerp(0.1, 5, _quality) }
    ];

    var _definition = item_get(_game.recipe.output.item_key);
    var _rarity_source = "crafted_weapon";
    if (_definition.category == ItemCategory.WEAPON)
        variable_struct_set(global.weapon_rarity_chances, _rarity_source, _crafted_chances);
    else
    {
        _rarity_source = "crafted_armor";
        variable_struct_set(global.armor_rarity_chances, _rarity_source, _crafted_chances);
    }

    var _item = stash_place_item(_game.recipe.output.item_key, -1, -1, 0, stash, _rarity_source);
    if (is_undefined(_item))
        _item = stash_place_item(_game.recipe.output.item_key, -1, -1, 90, stash, _rarity_source);

    _game.crafted_item = _item;
    _game.phase = 3;
    if (variable_struct_exists(_game.recipe, "xp") && _game.recipe.xp > 0)
        player_skill_add_xp(_game.skill_key, _game.recipe.xp);
    save_mark_dirty();
}
