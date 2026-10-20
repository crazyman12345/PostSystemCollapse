function bomber(_enemy)
{
    var e = _enemy;
    var _bullet_speed = 2.4;
    var _aim_direction = raid_predict_player_aim(
        e.enemy_x,
        e.enemy_y - 10,
        _bullet_speed * 1.15,
        e.lead_strength
    );
    e.enemy_gun_angle = raid_smooth_aim_direction(e.enemy_gun_angle, _aim_direction);

    switch (e.enemy_state)
    {
        case RaidEnemyState.MOVE:
        {
            e.shot_timer -= frame_scale;
            e.bomb_timer -= frame_scale;

            if (e.shot_timer <= 0)
            {
                e = raid_enemy_fire_gun(e, e.enemy_gun_angle, _bullet_speed, 10);
                e.shot_timer += randomize_enemy_timer(90, 0.2);
            }

            if (e.bomb_timer <= 0)
            {
                e.enemy_state = RaidEnemyState.ATTACK;
                e.bomb_windup_timer = e.bomb_windup_total;
                ring_attack_create(
                    e.enemy_x,
                    e.enemy_y,
                    e.bomb_windup_total,
                    e.bomb_indicator_radius,
                    2,
                    10,
                    10,
                    make_color_rgb(255, 90, 90),
                    make_color_rgb(120, 70, 20)
                );
                break;
            }

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
        break;

        case RaidEnemyState.ATTACK:
        {
            e.bomb_windup_timer -= frame_scale;

            if (e.bomb_windup_timer <= 0)
            {
                var _start_direction = random(60);
                var _projectile_behavior = {
                    travel_distance: 145,
                    linger_duration: 90,
                    fade_duration: 60
                };

                for (var i = 0; i < 6; i++)
                {
                    raid_enemy_fire_bullet(
                        e.enemy_x,
                        e.enemy_y - 10,
                        _start_direction + i * 60,
                        2.2,
                        10,
                        true,
                        make_color_rgb(255, 70, 45),
                        24,
                        0.2,
                        true,
                        1.25,
                        _projectile_behavior
                    );
                }

                e.enemy_state = RaidEnemyState.PAUSE;
                e.state_timer = 30;
            }
        }
        break;

        case RaidEnemyState.PAUSE:
        {
            e.state_timer -= frame_scale;

            if (e.state_timer <= 0)
            {
                e.enemy_state = RaidEnemyState.MOVE;
                e.bomb_timer = 600;
                e.shot_timer = max(e.shot_timer, randomize_enemy_timer(45, 0.2));
                e = raid_enemy_pick_random_position(e);
            }
        }
        break;
    }

    return e;
}
