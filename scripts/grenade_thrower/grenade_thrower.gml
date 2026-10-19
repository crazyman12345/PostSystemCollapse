function grenade_thrower(_enemy)
{
    var e = _enemy;

    if (e.grenade_landed)
    {
        e.grenade_landed_timer = max(0, e.grenade_landed_timer - frame_scale);

        if (e.grenade_landed_timer <= 0)
            e.grenade_landed = false;
    }

    if (e.grenade_in_flight)
    {
        e.grenade_flight_timer = max(0, e.grenade_flight_timer - frame_scale);

        var _flight_progress = 1 - (e.grenade_flight_timer / e.grenade_flight_total);
        e.grenade_x = lerp(e.grenade_start_x, e.grenade_target_x, _flight_progress);
        e.grenade_y = lerp(e.grenade_start_y, e.grenade_target_y, _flight_progress)
            - dsin(_flight_progress * 180) * 45;
        e.grenade_rotation += 12 * frame_scale;

        if (e.grenade_flight_timer <= 0)
        {
            e.grenade_in_flight = false;
            e.grenade_held = true;
            e.grenade_landed = true;
            e.grenade_landed_timer = 120;
            e.grenade_x = e.grenade_target_x;
            e.grenade_y = e.grenade_target_y;

            ring_attack_create(
                e.grenade_x,
                e.grenade_y,
                120,
                70,
                2,
                10,
                10,
                make_color_rgb(230, 175, 70),
                make_color_rgb(120, 70, 20)
            );
        }
    }

    switch (e.enemy_state)
    {
        case RaidEnemyState.MOVE:
        {
            e.grenade_timer -= frame_scale;

            var _distance = point_distance(e.enemy_x, e.enemy_y, e.target_x, e.target_y);

            if (_distance > 4)
            {
                var _direction = point_direction(e.enemy_x, e.enemy_y, e.target_x, e.target_y);
                var _move_distance = min(e.enemy_speed * frame_scale, _distance);
                e.enemy_x += lengthdir_x(_move_distance, _direction);
                e.enemy_y += lengthdir_y(_move_distance, _direction);
            }
            else
            {
                e.enemy_x = e.target_x;
                e.enemy_y = e.target_y;
                e.enemy_state = RaidEnemyState.PAUSE;
            }
        }
        break;

        case RaidEnemyState.PAUSE:
        {
            e.grenade_timer -= frame_scale;

            if (e.grenade_timer <= 0)
            {
                e.enemy_state = RaidEnemyState.ATTACK;
                e.grenade_throw_timer = e.grenade_throw_total;
            }
        }
        break;

        case RaidEnemyState.ATTACK:
        {
            e.grenade_throw_timer = max(0, e.grenade_throw_timer - frame_scale);
            if (e.grenade_throw_timer > 0) break;

            e.grenade_held = false;
            e.grenade_in_flight = true;
            e.grenade_start_x = e.enemy_x + e.enemy_facing * 16;
            e.grenade_start_y = e.enemy_y - 20;
            e.grenade_target_x = raid_player_x;
            e.grenade_target_y = raid_player_y;
            e.grenade_x = e.grenade_start_x;
            e.grenade_y = e.grenade_start_y;
            e.grenade_flight_timer = e.grenade_flight_total;
            e.grenade_rotation = 0;

            e.grenade_timer = randomize_enemy_timer(420, 2 / 7);

            for (var _attempt = 0; _attempt < 6; _attempt++)
            {
                e = raid_enemy_pick_random_position(e);

                if (point_distance(e.enemy_x, e.enemy_y, e.target_x, e.target_y) >= 120)
                    break;
            }

            e.enemy_state = RaidEnemyState.MOVE;
        }
        break;
    }

    return e;
}
