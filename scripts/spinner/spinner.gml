function spinner(_enemy)
{
    var e = _enemy;
    var _player_direction = point_direction(e.enemy_x, e.enemy_y - 18, raid_player_x, raid_player_y);

    switch (e.enemy_state)
    {
        case RaidEnemyState.MOVE:
        {
            e.enemy_gun_angle = raid_smooth_aim_direction(e.enemy_gun_angle, _player_direction, 0.45);

            if (e.enemy_sprite != e.enemy_sprite_active)
            {
                e.enemy_sprite = e.enemy_sprite_active;
                e.enemy_frame = 0;
            }

            var _dist = point_distance(
                e.enemy_x,
                e.enemy_y,
                e.target_x,
                e.target_y
            );

            if (_dist > 4)
            {
                var _dir = point_direction(
                    e.enemy_x,
                    e.enemy_y,
                    e.target_x,
                    e.target_y
                );

                e.enemy_x += lengthdir_x(e.enemy_speed * frame_scale, _dir);
                e.enemy_y += lengthdir_y(e.enemy_speed * frame_scale, _dir);
            }
            else
            {
                e.enemy_state = RaidEnemyState.ATTACK;
                e.spin_dir = e.enemy_gun_angle;
                e.spin_shots = 0;
                e.shot_timer = randomize_enemy_timer(4, 0.25);

                if (e.enemy_sprite != e.enemy_sprite_idle)
                {
                    e.enemy_sprite = e.enemy_sprite_idle;
                    e.enemy_frame = 0;
                }
            }
        }
        break;

        case RaidEnemyState.ATTACK:
        {
            if (e.enemy_sprite != e.enemy_sprite_idle)
            {
                e.enemy_sprite = e.enemy_sprite_idle;
                e.enemy_frame = 0;
            }

            e.spin_dir += 15 * frame_scale;

            e.spin_dir = e.spin_dir mod 360;

            e.enemy_gun_angle = e.spin_dir;

            if (e.shot_timer > 0)
                e.shot_timer -= frame_scale;

            if (e.shot_timer <= 0)
            {
                e = raid_enemy_fire_gun(
                    e,
                    e.spin_dir,
                    2,
                    8
                );

                e.spin_shots++;
                e.shot_timer += randomize_enemy_timer(4, 0.25);
            }

            if (e.spin_shots >= 6)
            {
                e.enemy_state = RaidEnemyState.PAUSE;
                e.state_timer = randomize_enemy_timer(50, 0.25);
            }
        }
        break;

        case RaidEnemyState.PAUSE:
        {
            e.enemy_gun_angle = raid_smooth_aim_direction(e.enemy_gun_angle, _player_direction, 0.45);

            if (e.enemy_sprite != e.enemy_sprite_idle)
            {
                e.enemy_sprite = e.enemy_sprite_idle;
                e.enemy_frame = 0;
            }

            e.state_timer -= frame_scale;

            if (e.state_timer <= 0)
            {
                e = raid_enemy_pick_random_position(e);
                e.enemy_state = RaidEnemyState.MOVE;
            }
        }
        break;
    }

    return e;
}
