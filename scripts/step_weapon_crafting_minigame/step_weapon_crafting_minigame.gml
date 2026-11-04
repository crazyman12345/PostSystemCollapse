function step_weapon_crafting_minigame()
{
    var _game = crafting_minigame_state;
    var _layout = weapon_crafting_layout();
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var _scale = frame_scale;

    _game.impact_timer = max(0, _game.impact_timer - _scale);
    _game.shake *= power(0.82, _scale);
    for (var _i = array_length(_game.sparks) - 1; _i >= 0; _i--)
    {
        var _spark = _game.sparks[_i];
        _spark.x += _spark.dx * _scale;
        _spark.y += _spark.dy * _scale;
        _spark.dy += 0.12 * _scale;
        _spark.life -= _scale;
        if (_spark.life <= 0) array_delete(_game.sparks, _i, 1);
    }
    for (var _chunk_index = array_length(_game.plate_chunks) - 1; _chunk_index >= 0; _chunk_index--)
    {
        var _chunk = _game.plate_chunks[_chunk_index];
        _chunk.x += _chunk.dx * _scale;
        _chunk.y += _chunk.dy * _scale;
        _chunk.dy += 0.035 * _scale;
        _chunk.rotation += _chunk.rotation_speed * _scale;
        _chunk.life -= _scale;
        if (_chunk.life <= 0) array_delete(_game.plate_chunks, _chunk_index, 1);
    }

    if (_game.phase == 3)
    {
        if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_escape))
        {
            crafting_message = "CRAFTED: " + _game.recipe.name
                + "  SCORE " + string(_game.final_score);
            weapon_crafting_minigame_init();
        }
        return;
    }

    if (keyboard_check_pressed(vk_escape))
    {
        weapon_crafting_minigame_cancel();
        return;
    }

    if (_game.phase == 1 && !mouse_check_button(mb_left)) _game.cut_active = false;

    if (_game.phase == 1 && mouse_check_button(mb_left))
    {
        var _new_cut_stroke = !_game.cut_active;
        var _count = array_length(_game.outline.checkpoints);
        if (_game.checkpoint_completed < _count)
        {
            var _distance = weapon_crafting_distance_to_outline(
                _mouse_x - _layout.center_x, _mouse_y - _layout.center_y,
                _game.outline.vertices);
            var _in_plate = point_in_rectangle(_mouse_x, _mouse_y, _layout.plate_left,
                _layout.plate_top, _layout.plate_right, _layout.plate_bottom);

            if (_in_plate)
            {
                _game.cut_active = true;
                var _trail_count = array_length(_game.cut_trail);
                var _stroke_from_x = _mouse_x;
                var _stroke_from_y = _mouse_y;
                if (!_new_cut_stroke && _trail_count > 0)
                {
                    _stroke_from_x = _game.cut_trail[_trail_count - 1].x;
                    _stroke_from_y = _game.cut_trail[_trail_count - 1].y;
                }
                if (_new_cut_stroke || _trail_count == 0)
                {
                    _game.accuracy_samples += 1;
                    _game.accuracy_total += clamp(1 - (_distance / (_game.outline.tolerance * 2)), 0, 1);
                    if (_distance > _game.outline.tolerance) _game.drift_penalties += 1;
                    array_push(_game.cut_trail, { x: _mouse_x, y: _mouse_y,
                        good: _distance <= _game.outline.tolerance, start: true });
                }
                else if (point_distance(_mouse_x, _mouse_y,
                    _game.cut_trail[_trail_count - 1].x, _game.cut_trail[_trail_count - 1].y) >= 4)
                {
                    var _previous_cut = _game.cut_trail[_trail_count - 1];
                    var _cut_distance = point_distance(_previous_cut.x, _previous_cut.y, _mouse_x, _mouse_y);
                    var _accuracy_steps = max(1, ceil(_cut_distance / 4));
                    for (var _accuracy_step = 1; _accuracy_step <= _accuracy_steps; _accuracy_step++)
                    {
                        var _accuracy_amount = _accuracy_step / _accuracy_steps;
                        var _accuracy_x = lerp(_previous_cut.x, _mouse_x, _accuracy_amount);
                        var _accuracy_y = lerp(_previous_cut.y, _mouse_y, _accuracy_amount);
                        var _accuracy_distance = weapon_crafting_distance_to_outline(
                            _accuracy_x - _layout.center_x, _accuracy_y - _layout.center_y,
                            _game.outline.vertices);
                        _game.accuracy_samples += 1;
                        _game.accuracy_total += clamp(1 - (_accuracy_distance
                            / (_game.outline.tolerance * 2)), 0, 1);
                        if (_accuracy_distance > _game.outline.tolerance)
                            _game.drift_penalties += 1;
                    }
                    array_push(_game.cut_trail, { x: _mouse_x, y: _mouse_y,
                        good: _distance <= _game.outline.tolerance, start: false });
                    if (array_length(_game.cut_trail) > 600) array_delete(_game.cut_trail, 0, 1);
                }
            }
            else _game.cut_active = false;

            if (_in_plate)
            {
                for (var _cut_index = 0; _cut_index < _count; _cut_index++)
                {
                    if (_game.checkpoint_hits[_cut_index]) continue;
                    var _cut_point = _game.outline.checkpoints[_cut_index];
                    if (weapon_crafting_distance_to_segment(
                        _layout.center_x + _cut_point.x, _layout.center_y + _cut_point.y,
                        _stroke_from_x, _stroke_from_y, _mouse_x, _mouse_y)
                        <= _game.outline.tolerance * 2)
                    {
                        _game.checkpoint_hits[_cut_index] = true;
                        _game.checkpoint_completed += 1;
                    }
                }
            }

            if (_in_plate && _distance <= _game.outline.tolerance)
            {
                _game.spark_emit_timer += _scale;
                if (_game.spark_emit_timer >= 2)
                {
                    _game.spark_emit_timer -= 2;
                    repeat (_game.outline.process == "fabric" ? 1 : 2)
                        array_push(_game.sparks, { x: _mouse_x, y: _mouse_y,
                            dx: random_range(-2.8, 2.8), dy: random_range(-3.6, -0.8), life: random_range(10, 22) });
                }
            }

            if (_game.checkpoint_completed >= _count)
            {
                _game.phase = 2;
                _game.transition_timer = 36;
                _game.shake = 5;
                _game.plate_chunks = weapon_crafting_plate_chunks_create(_layout, _game.outline);
            }
        }
    }
    else if (_game.phase == 2)
    {
        _game.transition_timer = max(0, _game.transition_timer - _scale);
        if (_game.transition_timer <= 0 && mouse_check_button_pressed(mb_left))
        {
            for (var _marker_index = 0; _marker_index < array_length(_game.outline.hammer_markers); _marker_index++)
            {
                if (_game.hammer_hits[_marker_index]) continue;
                var _marker = _game.outline.hammer_markers[_marker_index];
                var _hit_x = _layout.center_x + _marker.x;
                var _hit_y = _layout.center_y + _marker.y;
                var _hit_distance = point_distance(_mouse_x, _mouse_y, _hit_x, _hit_y);
                if (_hit_distance <= 34)
                {
                    _game.hammer_hits[_marker_index] = true;
                    _game.hammer_hit_count += 1;
                    _game.impact_timer = 10;
                    _game.shake = _game.outline.process == "fabric" ? 3 : 8;
                    repeat (_game.outline.process == "fabric" ? 5 : 12)
                        array_push(_game.sparks, { x: _hit_x, y: _hit_y,
                            dx: random_range(-4.5, 4.5), dy: random_range(-5, -1), life: random_range(12, 28) });
                    audio_play_sound(snd_interact, 0, false);
                    if (_game.hammer_hit_count >= array_length(_game.hammer_hits))
                        weapon_crafting_minigame_finish();
                    return;
                }
            }
            _game.hammer_misses += 1;
        }
    }
}
