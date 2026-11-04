function draw_weapon_crafting_minigame()
{
    var _game = crafting_minigame_state;
    var _layout = weapon_crafting_layout();
    var _shake_x = _game.shake > 0.2 ? random_range(-_game.shake, _game.shake) : 0;
    var _shake_y = _game.shake > 0.2 ? random_range(-_game.shake, _game.shake) : 0;
    var _center_x = _layout.center_x + _shake_x;
    var _center_y = _layout.center_y + _shake_y;
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var _fabric = _game.outline.process == "fabric";
    var _armor_process = _game.outline.process == "armor";

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(54, 36, 24));
    draw_rectangle(_layout.left, _layout.top, _layout.right, _layout.bottom, false);
    draw_set_color(make_color_rgb(82, 55, 34));
    for (var _line_y = _layout.top + 24; _line_y < _layout.bottom; _line_y += 58)
        draw_line(_layout.left, _line_y, _layout.right, _line_y + 8);

    if (_game.phase == 1)
    {
        draw_set_color(_fabric ? make_color_rgb(78, 91, 86) : make_color_rgb(92, 99, 101));
        draw_rectangle(_layout.plate_left, _layout.plate_top,
            _layout.plate_right, _layout.plate_bottom, false);
    }
    else
    {
        draw_set_color(_fabric ? make_color_rgb(78, 91, 86) : make_color_rgb(92, 99, 101));
        for (var _chunk_index = 0; _chunk_index < array_length(_game.plate_chunks); _chunk_index++)
        {
            var _chunk = _game.plate_chunks[_chunk_index];
            draw_set_alpha(clamp(_chunk.life / 24, 0, 1));
            draw_crafting_plate_chunk(_chunk);
        }
        draw_set_alpha(1);
    }

    var _vertices = _game.outline.vertices;
    if (_game.phase == 1)
    {
        draw_crafting_result_shape(_game.outline, _center_x, _center_y,
            make_color_rgb(48, 53, 54), 0.72, undefined, true);

        draw_set_color(make_color_rgb(210, 180, 95));
        for (var _i = 0; _i < array_length(_vertices) - 1; _i++)
            draw_line(_center_x + _vertices[_i].x, _center_y + _vertices[_i].y,
                _center_x + _vertices[_i + 1].x, _center_y + _vertices[_i + 1].y);

        var _checkpoint_count = array_length(_game.outline.checkpoints);
        var _completion = _checkpoint_count > 0 ? _game.checkpoint_completed / _checkpoint_count : 0;
        if (array_length(_game.cut_trail) > 1)
        {
            for (var _trail = 1; _trail < array_length(_game.cut_trail); _trail++)
            {
                var _previous = _game.cut_trail[_trail - 1];
                var _current = _game.cut_trail[_trail];
                if (_current.start) continue;
                draw_set_color(_current.good
                    ? (_fabric ? make_color_rgb(225, 225, 190) : make_color_rgb(255, 118, 28))
                    : make_color_rgb(170, 40, 28));
                draw_line_width(_previous.x, _previous.y, _current.x, _current.y, 3);
            }
        }

        draw_set_font(fnt_terminal_small);
        draw_set_color(c_white);
        var _phase_one_name = _fabric ? "PATTERN CUTTING" : (_armor_process ? "PANEL CUTTING" : "TORCH CUTTING");
        draw_text(_layout.left + 28, _layout.top + 24, _phase_one_name);
        draw_text(_layout.left + 28, _layout.top + 58, "OUTLINE " + string(round(_completion * 100)) + "%");

        if (_fabric)
        {
            draw_set_color(c_silver);
            draw_line_width(_mouse_x - 20, _mouse_y - 12, _mouse_x + 16, _mouse_y + 14, 5);
            draw_line_width(_mouse_x - 20, _mouse_y + 12, _mouse_x + 16, _mouse_y - 14, 5);
            draw_circle(_mouse_x - 22, _mouse_y - 13, 8, true);
            draw_circle(_mouse_x - 22, _mouse_y + 13, 8, true);
        }
        else
        {
            draw_set_color(make_color_rgb(70, 70, 75));
            draw_line_width(_mouse_x + 10, _mouse_y - 12, _mouse_x + 36, _mouse_y - 38, 10);
            draw_set_color(mouse_check_button(mb_left) ? make_color_rgb(90, 190, 255) : c_silver);
            draw_circle(_mouse_x, _mouse_y, 7, false);
            if (mouse_check_button(mb_left))
            {
                draw_set_alpha(0.35);
                draw_set_color(c_aqua);
                draw_circle(_mouse_x, _mouse_y, 18, false);
                draw_set_alpha(1);
            }
        }
    }
    else
    {
        if (_game.hammer_hit_count < array_length(_game.hammer_hits))
            draw_crafting_rough_cut(_game, _layout, _center_x, _center_y);
        draw_crafting_result_shape(_game.outline, _center_x, _center_y, c_gray, 1, undefined, true);
        if (_game.hammer_hit_count >= array_length(_game.hammer_hits))
        {
            draw_crafting_result_shape(_game.outline, _center_x, _center_y, c_white, 1);
        }
        else
        {
            var _reveal_width = 210;
            var _reveal_height = 250;
            if (_game.outline.shape == "vest" || _game.outline.shape == "bag")
            {
                _reveal_width = 240;
                _reveal_height = 280;
            }
            else if (_game.outline.shape == "helmet")
            {
                _reveal_width = 220;
                _reveal_height = 230;
            }

            for (var _reveal_index = 0; _reveal_index < array_length(_game.outline.hammer_markers); _reveal_index++)
            {
                if (!_game.hammer_hits[_reveal_index]) continue;
                var _reveal_marker = _game.outline.hammer_markers[_reveal_index];
                draw_crafting_result_shape(_game.outline, _center_x, _center_y, c_white, 1, {
                    left: _center_x + _reveal_marker.x - _reveal_width * 0.5,
                    top: _center_y + _reveal_marker.y - _reveal_height * 0.5,
                    width: _reveal_width,
                    height: _reveal_height
                });
            }
        }

        if (_game.phase == 2 && _game.transition_timer <= 0)
        {
            for (var _marker_index = 0; _marker_index < array_length(_game.outline.hammer_markers); _marker_index++)
            {
                if (_game.hammer_hits[_marker_index]) continue;
                var _marker = _game.outline.hammer_markers[_marker_index];
                var _marker_x = _center_x + _marker.x;
                var _marker_y = _center_y + _marker.y;
                draw_set_color(c_red);
                draw_line_width(_marker_x - 12, _marker_y - 12, _marker_x + 12, _marker_y + 12, 4);
                draw_line_width(_marker_x + 12, _marker_y - 12, _marker_x - 12, _marker_y + 12, 4);
            }
        }

        draw_set_font(fnt_terminal_small);
        draw_set_color(c_white);
        var _phase_two_name = _fabric ? "STITCHING" : (_armor_process ? "FASTENING" : "HAMMER FINISHING");
        draw_text(_layout.left + 28, _layout.top + 24,
            _game.phase == 3 ? "CRAFT COMPLETE" : _phase_two_name);
        if (_game.phase != 3)
            draw_text(_layout.left + 28, _layout.top + 58,
                "REFINED " + string(_game.hammer_hit_count) + " / "
                + string(array_length(_game.hammer_hits)));

        if (_game.phase == 2 && _fabric)
        {
            draw_set_color(c_silver);
            draw_line_width(_mouse_x - 24, _mouse_y + 18, _mouse_x + 24, _mouse_y - 18, 2);
            draw_set_color(make_color_rgb(210, 60, 60));
            draw_line(_mouse_x - 25, _mouse_y + 19, _mouse_x - 48, _mouse_y + 35);
        }
        else if (_game.phase == 2)
        {
            draw_set_color(make_color_rgb(91, 58, 31));
            draw_line_width(_mouse_x + 6, _mouse_y + 8, _mouse_x + 34, _mouse_y + 42, 9);
            draw_set_color(c_silver);
            draw_rectangle(_mouse_x - 18, _mouse_y - 14, _mouse_x + 20, _mouse_y + 4, false);
        }
    }

    for (var _spark_index = 0; _spark_index < array_length(_game.sparks); _spark_index++)
    {
        var _spark = _game.sparks[_spark_index];
        draw_set_alpha(clamp(_spark.life / 10, 0, 1));
        draw_set_color(_fabric
            ? (_spark_index mod 2 == 0 ? c_white : make_color_rgb(210, 60, 60))
            : (_spark_index mod 2 == 0 ? c_yellow : make_color_rgb(255, 90, 20)));
        draw_line(_spark.x, _spark.y, _spark.x - _spark.dx * 2, _spark.y - _spark.dy * 2);
    }
    draw_set_alpha(1);

    if (_game.impact_timer > 0)
    {
        draw_set_alpha(_game.impact_timer / 20);
        draw_set_color(c_white);
        draw_rectangle(_layout.left, _layout.top, _layout.right, _layout.bottom, false);
        draw_set_alpha(1);
    }

    if (_game.phase == 3)
    {
        var _rarity = is_undefined(_game.crafted_item) ? "common" : _game.crafted_item.rarity;
        var _definition = item_get(_game.recipe.output.item_key);
        var _rarity_info = _definition.category == ItemCategory.WEAPON
            ? weapon_rarity_get(_rarity)
            : armor_rarity_get(_rarity);
        draw_set_halign(fa_center);
        draw_set_color(_rarity_info.color);
        draw_set_font(fnt_terminal);
        draw_text(_layout.center_x, _layout.bottom - 150,
            "SCORE " + string(_game.final_score) + " / 100");
        draw_text(_layout.center_x, _layout.bottom - 102,
            string_upper(_rarity_info.name) + " " + string_upper(_definition.name));
        draw_set_halign(fa_left);
    }
}

function draw_crafting_rough_cut(_game, _layout, _center_x, _center_y)
{
    if (array_length(_game.cut_trail) <= 1) return;

    var _offset_x = _center_x - _layout.center_x;
    var _offset_y = _center_y - _layout.center_y;
    draw_set_alpha(1);
    draw_set_color(c_gray);

    var _previous_point = undefined;
    for (var _trail_index = 0; _trail_index < array_length(_game.cut_trail); _trail_index++)
    {
        var _current = _game.cut_trail[_trail_index];
        var _current_point = crafting_cut_trail_smooth_point(_game.cut_trail, _trail_index);
        _current_point.x += _offset_x;
        _current_point.y += _offset_y;
        if (_current.start || is_undefined(_previous_point)) _previous_point = _current_point;

        var _distance = point_distance(_previous_point.x, _previous_point.y,
            _current_point.x, _current_point.y);
        var _steps = max(1, ceil(_distance / 5));
        for (var _step = 0; _step <= _steps; _step++)
        {
            var _amount = _step / _steps;
            var _point_x = lerp(_previous_point.x, _current_point.x, _amount);
            var _point_y = lerp(_previous_point.y, _current_point.y, _amount);
            if (!crafting_cut_point_is_refined(_game, _center_x, _center_y, _point_x, _point_y))
                draw_circle(_point_x, _point_y, 14, false);
        }
        _previous_point = _current_point;
    }
    draw_set_alpha(1);
}

function crafting_cut_trail_smooth_point(_trail, _index)
{
    var _stroke_start = _index;
    while (_stroke_start > 0 && !_trail[_stroke_start].start) _stroke_start--;
    var _stroke_end = _index;
    while (_stroke_end + 1 < array_length(_trail) && !_trail[_stroke_end + 1].start) _stroke_end++;

    var _first = max(_stroke_start, _index - 4);
    var _last = min(_stroke_end, _index + 4);
    var _x = 0;
    var _y = 0;
    var _count = 0;
    for (var _sample = _first; _sample <= _last; _sample++)
    {
        _x += _trail[_sample].x;
        _y += _trail[_sample].y;
        _count += 1;
    }
    return { x: _x / _count, y: _y / _count };
}

function crafting_cut_point_is_refined(_game, _center_x, _center_y, _point_x, _point_y)
{
    for (var _marker_index = 0; _marker_index < array_length(_game.outline.hammer_markers); _marker_index++)
    {
        if (!_game.hammer_hits[_marker_index]) continue;
        var _marker = _game.outline.hammer_markers[_marker_index];
        if (point_distance(_point_x, _point_y,
            _center_x + _marker.x, _center_y + _marker.y) <= 115) return true;
    }
    return false;
}

function draw_crafting_plate_chunk(_chunk)
{
    var _half_width = _chunk.width * 0.5;
    var _half_height = _chunk.height * 0.5;
    var _distance = point_distance(0, 0, _half_width, _half_height);
    var _corner_angle = point_direction(0, 0, _half_width, _half_height);
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(_chunk.x, _chunk.y);
    draw_vertex(_chunk.x + lengthdir_x(_distance, _corner_angle + _chunk.rotation),
        _chunk.y + lengthdir_y(_distance, _corner_angle + _chunk.rotation));
    draw_vertex(_chunk.x + lengthdir_x(_distance, 180 - _corner_angle + _chunk.rotation),
        _chunk.y + lengthdir_y(_distance, 180 - _corner_angle + _chunk.rotation));
    draw_vertex(_chunk.x + lengthdir_x(_distance, 180 + _corner_angle + _chunk.rotation),
        _chunk.y + lengthdir_y(_distance, 180 + _corner_angle + _chunk.rotation));
    draw_vertex(_chunk.x + lengthdir_x(_distance, 360 - _corner_angle + _chunk.rotation),
        _chunk.y + lengthdir_y(_distance, 360 - _corner_angle + _chunk.rotation));
    draw_vertex(_chunk.x + lengthdir_x(_distance, _corner_angle + _chunk.rotation),
        _chunk.y + lengthdir_y(_distance, _corner_angle + _chunk.rotation));
    draw_primitive_end();
}

function draw_crafting_result_shape(_outline, _center_x, _center_y, _color, _alpha,
    _clip = undefined, _solid_silhouette = false)
{
    if (_alpha <= 0) return;
    var _previous_scissor = undefined;
    if (is_struct(_clip))
    {
        _previous_scissor = gpu_get_scissor();
        gpu_set_scissor(_clip.left, _clip.top, _clip.width, _clip.height);
    }

    if (_outline.result_sprite != -1 && sprite_exists(_outline.result_sprite))
    {
        var _sprite = _outline.result_sprite;
        var _left = sprite_get_bbox_left(_sprite);
        var _top = sprite_get_bbox_top(_sprite);
        var _width = sprite_get_bbox_right(_sprite) - _left + 1;
        var _height = sprite_get_bbox_bottom(_sprite) - _top + 1;
        var _scale = min(650 / _width, 430 / _height);
        if (_solid_silhouette) shader_set(shd_crafting_silhouette);
        draw_sprite_part_ext(_sprite, 0, _left, _top, _width, _height,
            _center_x - _width * _scale * 0.5, _center_y - _height * _scale * 0.5,
            _scale, _scale, _color, _alpha);
        if (_solid_silhouette) shader_reset();
        if (is_struct(_previous_scissor))
            gpu_set_scissor(_previous_scissor.x, _previous_scissor.y, _previous_scissor.w, _previous_scissor.h);
        return;
    }

    draw_set_alpha(_alpha);
    draw_set_color(_color);
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(_center_x, _center_y);
    for (var _i = 0; _i < array_length(_outline.vertices); _i++)
        draw_vertex(_center_x + _outline.vertices[_i].x, _center_y + _outline.vertices[_i].y);
    draw_primitive_end();
    draw_set_alpha(1);
    if (is_struct(_previous_scissor))
        gpu_set_scissor(_previous_scissor.x, _previous_scissor.y, _previous_scissor.w, _previous_scissor.h);
}
