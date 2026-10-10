function knife_dasher(_enemy)
{
    var e = _enemy;

    switch (e.enemy_state)
    {
        case RaidEnemyState.PAUSE:
        {
            if (e.enemy_sprite != spr_dasher_idle)
            {
                e.enemy_sprite = spr_dasher_idle;
                e.enemy_frame = 0;
            }

            e.state_timer -= frame_scale;

            if (e.state_timer <= 0)
            {
                e.dash_dir = point_direction(
                    e.enemy_x,
                    e.enemy_y,
                    raid_player_x,
                    raid_player_y
                );

                e.enemy_state = RaidEnemyState.DASH;
                e.state_timer = randomize_enemy_timer(40, 0.25);
            }
        }
        break;

        case RaidEnemyState.DASH:
        {
            if (e.enemy_sprite != spr_dasher_run)
            {
                e.enemy_sprite = spr_dasher_run;
                e.enemy_frame = 0;
            }

            var _dash_step = min(frame_scale, e.state_timer);

            e.enemy_x += lengthdir_x(
                e.dash_speed * _dash_step,
                e.dash_dir
            );

            e.enemy_y += lengthdir_y(
                e.dash_speed * _dash_step,
                e.dash_dir
            );

            e.state_timer -= frame_scale;

            if (e.state_timer <= 0)
            {
                e.enemy_state = RaidEnemyState.PAUSE;
                e.state_timer = randomize_enemy_timer(75, 0.25);
            }
        }
        break;
    }

    return e;
}
