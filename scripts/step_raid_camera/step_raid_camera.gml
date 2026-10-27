function step_raid_camera()
{
    var _cam_w = camera_get_view_width(raid_camera);
    var _cam_h = camera_get_view_height(raid_camera);

    var _camera_target_x = raid_player_x;
    var _camera_target_y = raid_player_y;
    var _smooth_to_target = false;

    for (var i = 0; i < array_length(raid_enemies); i++)
    {
        var _enemy = raid_enemies[i];

        if (
            is_struct(_enemy)
            && _enemy.enemy_boss
            && variable_struct_exists(_enemy, "boss_intro_active")
            && _enemy.boss_intro_active
        )
        {
            _camera_target_x = (raid_room_x1 + raid_room_x2) * 0.5;
            _camera_target_y = (raid_room_y1 + raid_room_y2) * 0.5;
            _smooth_to_target = true;
            break;
        }

        if (
            is_struct(_enemy)
            && _enemy.enemy_boss
            && _enemy.enemy_state == RaidEnemyState.PHASE_TRANSITION
        )
        {
            _camera_target_x = _enemy.enemy_x;
            _camera_target_y = _enemy.enemy_y;
            break;
        }
    }

    var _cam_x = _camera_target_x - (_cam_w * 0.5);
    var _cam_y = _camera_target_y - (_cam_h * 0.5);

    if (_smooth_to_target)
    {
        var _current_camera_x = camera_get_view_x(raid_camera);
        var _current_camera_y = camera_get_view_y(raid_camera);

        if (point_distance(_current_camera_x, _current_camera_y, _cam_x, _cam_y) > 5)
        {
            var _camera_shift_amount = 1 - power(0.88, frame_scale);
            _cam_x = lerp(_current_camera_x, _cam_x, _camera_shift_amount);
            _cam_y = lerp(_current_camera_y, _cam_y, _camera_shift_amount);
        }
    }

    if (raid_camera_shake_timer > 0)
    {
        var _shake_strength = raid_camera_shake_strength * clamp(raid_camera_shake_timer / raid_camera_shake_duration, 0, 1);
        _cam_x += random_range(-_shake_strength, _shake_strength);
        _cam_y += random_range(-_shake_strength, _shake_strength);
        raid_camera_shake_timer = max(0, raid_camera_shake_timer - frame_scale);
    }

    _cam_x = round(_cam_x);
    _cam_y = round(_cam_y);

    camera_set_view_pos(
        raid_camera,
        _cam_x,
        _cam_y
    );
}
