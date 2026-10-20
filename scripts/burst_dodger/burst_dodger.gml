function burst_dodger(_enemy)
{
    var e = _enemy;
    var _bullet_speed = 2.75;
    var _predicted_direction = raid_predict_player_aim(
        e.enemy_x,
        e.enemy_y - 10,
        _bullet_speed * 1.15,
        e.lead_strength
    );
    e.enemy_gun_angle = raid_smooth_aim_direction(e.enemy_gun_angle, _predicted_direction);

    if (e.shot_timer > 0)
        e.shot_timer -= frame_scale;

    if (e.dash_cooldown > 0)
        e.dash_cooldown -= frame_scale;

    if (e.shot_timer <= 0)
    {
        e = raid_enemy_fire_gun(e, e.enemy_gun_angle, _bullet_speed, 8);
        e.shots_fired++;

        if (e.shots_fired < 3)
        {
            e.shot_timer += 6;
        }
        else
        {
            e.shots_fired = 0;
            e.shot_timer += randomize_enemy_timer(200, 0.1);
        }
    }

    if (e.enemy_state != RaidEnemyState.DASH && e.dash_cooldown <= 0)
    {
        for (var i = 0; i < array_length(raid_bullets); i++)
        {
            var _bullet = raid_bullets[i];
            var _bullet_dir_x = lengthdir_x(1, _bullet.bdirection);
            var _bullet_dir_y = lengthdir_y(1, _bullet.bdirection);
            var _to_enemy_x = e.enemy_x - _bullet.bx;
            var _to_enemy_y = e.enemy_y - _bullet.by;
            var _forward_distance = _to_enemy_x * _bullet_dir_x + _to_enemy_y * _bullet_dir_y;
            var _path_distance = abs(_to_enemy_x * _bullet_dir_y - _to_enemy_y * _bullet_dir_x);

            if (_forward_distance > 0 && _forward_distance <= 220 && _path_distance <= 24)
            {
                var _dash_distance = e.dash_speed * e.dash_duration;
                var _left_dir = _bullet.bdirection + 90;
                var _right_dir = _bullet.bdirection - 90;
                var _left_x = e.enemy_x + lengthdir_x(_dash_distance, _left_dir);
                var _left_y = e.enemy_y + lengthdir_y(_dash_distance, _left_dir);
                var _right_x = e.enemy_x + lengthdir_x(_dash_distance, _right_dir);
                var _right_y = e.enemy_y + lengthdir_y(_dash_distance, _right_dir);
                var _left_space = point_distance(
                    e.enemy_x,
                    e.enemy_y,
                    clamp(_left_x, raid_room_x1 + 30, raid_room_x2 - 30),
                    clamp(_left_y, raid_room_y1 + 30, raid_room_y2 - 30)
                );
                var _right_space = point_distance(
                    e.enemy_x,
                    e.enemy_y,
                    clamp(_right_x, raid_room_x1 + 30, raid_room_x2 - 30),
                    clamp(_right_y, raid_room_y1 + 30, raid_room_y2 - 30)
                );

                e.dash_dir = _left_space >= _right_space ? _left_dir : _right_dir;
                e.enemy_state = RaidEnemyState.DASH;
                e.state_timer = e.dash_duration;
                e.dash_cooldown = 270;
                break;
            }
        }
    }

    if (e.enemy_state == RaidEnemyState.DASH)
    {
        var _dash_step = min(frame_scale, e.state_timer);
        e.enemy_x += lengthdir_x(e.dash_speed * _dash_step, e.dash_dir);
        e.enemy_y += lengthdir_y(e.dash_speed * _dash_step, e.dash_dir);
        e.state_timer -= frame_scale;

        if (e.state_timer <= 0)
        {
            e.enemy_state = RaidEnemyState.MOVE;
            e = raid_enemy_pick_random_position(e);
        }
    }
    else
    {
        var _target_distance = point_distance(e.enemy_x, e.enemy_y, e.target_x, e.target_y);

        if (_target_distance <= 4)
        {
            e = raid_enemy_pick_random_position(e);
        }
        else
        {
            var _move_direction = point_direction(e.enemy_x, e.enemy_y, e.target_x, e.target_y);
            e.enemy_x += lengthdir_x(e.enemy_speed * frame_scale, _move_direction);
            e.enemy_y += lengthdir_y(e.enemy_speed * frame_scale, _move_direction);
        }
    }

    return e;
}
