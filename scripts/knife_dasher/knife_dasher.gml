function knife_dasher(_enemy)
{
    var e = _enemy;

    switch (e.enemy_state)
    {
        case RaidEnemyState.PAUSE:
        {
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
                e.state_timer = 30;
            }
        }
        break;

        case RaidEnemyState.DASH:
        {
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