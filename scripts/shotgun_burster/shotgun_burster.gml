function shotgun_burster(_enemy)
{
    var e = _enemy;
    var _aim_direction = point_direction(e.enemy_x, e.enemy_y - 18, raid_player_x, raid_player_y);
    e.enemy_gun_angle = raid_smooth_aim_direction(e.enemy_gun_angle, _aim_direction);

    switch (e.enemy_state)
    {
        case RaidEnemyState.PAUSE:
        {
            e.state_timer -= frame_scale;

            if (e.state_timer <= 0)
            {
                if (e.shotgun_dash_pending)
                {
                    e.shotgun_dash_pending = false;
                    e.enemy_state = RaidEnemyState.DASH;
                    e.state_timer = e.dash_duration;
                }
                else
                {
                    e.enemy_state = RaidEnemyState.ATTACK;
                }
            }
        }
        break;

        case RaidEnemyState.ATTACK:
        {
            var _travel_distance = point_distance(e.enemy_x, e.enemy_y - 18, raid_player_x, raid_player_y);
            var _projectile_config = {
                count: 3,
                spread: 24,
                travel_distance: max(0, _travel_distance - 38),
                linger_duration: 120,
                fade_duration: 45,
                sound: shotgun_shoot
            };

            e = raid_enemy_fire_gun(e, _aim_direction, 2.6, 8, _projectile_config);
            e.dash_dir = random(360);
            var _arena_width = raid_room_x2 - raid_room_x1;
            var _dash_distance = random_range(_arena_width * 0.3, _arena_width * 0.5);
            e.dash_duration = _dash_distance / e.dash_speed;
            e.shotgun_dash_pending = true;
            e.enemy_state = RaidEnemyState.PAUSE;
            e.state_timer = 48;
        }
        break;

        case RaidEnemyState.DASH:
        {
            var _dash_step = min(frame_scale, e.state_timer);
            e.enemy_x += lengthdir_x(e.dash_speed * _dash_step, e.dash_dir);
            e.enemy_y += lengthdir_y(e.dash_speed * _dash_step, e.dash_dir);
            e.state_timer -= frame_scale;

            if (e.state_timer <= 0)
            {
                e.enemy_state = RaidEnemyState.PAUSE;
                e.state_timer = randomize_enemy_timer(145, 0.15);
            }
        }
        break;
    }

    return e;
}
