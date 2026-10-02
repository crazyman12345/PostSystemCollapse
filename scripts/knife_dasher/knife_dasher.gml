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

            e.state_timer--;

            if (e.state_timer <= 0)
            {
                e.dash_dir = point_direction(
                    e.enemy_x,
                    e.enemy_y,
                    raid_player_x,
                    raid_player_y
                );

                e.enemy_state = RaidEnemyState.DASH;
                e.state_timer = 40;
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

            e.enemy_x += lengthdir_x(
                e.dash_speed,
                e.dash_dir
            );

            e.enemy_y += lengthdir_y(
                e.dash_speed,
                e.dash_dir
            );

            e.state_timer--;

            if (e.state_timer <= 0)
            {
                e.enemy_state = RaidEnemyState.PAUSE;
                e.state_timer = 75;
            }
        }
        break;
    }

    return e;
}
