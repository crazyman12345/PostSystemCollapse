function burst_shooter(_enemy)
{
    var e = _enemy;

    e.enemy_gun_angle =
        point_direction(
            e.enemy_x,
            e.enemy_y - 10,
            raid_player_x,
            raid_player_y - 12
        );


    switch (e.enemy_state)
    {
        // ==============================
        // MOVE
        // ==============================

        case RaidEnemyState.MOVE:
        {
            if (e.enemy_sprite != e.enemy_sprite_active)
            {
                e.enemy_sprite = e.enemy_sprite_active;
                e.enemy_frame = 0;
            }


            var _dist =
                point_distance(
                    e.enemy_x,
                    e.enemy_y,
                    e.target_x,
                    e.target_y
                );


            if (_dist > 4)
            {
                var _dir =
                    point_direction(
                        e.enemy_x,
                        e.enemy_y,
                        e.target_x,
                        e.target_y
                    );

                e.enemy_x +=
                    lengthdir_x(
                        e.enemy_speed,
                        _dir
                    );

                e.enemy_y +=
                    lengthdir_y(
                        e.enemy_speed,
                        _dir
                    );
            }
            else
            {
                e.enemy_state =
                    RaidEnemyState.ATTACK;

                e.shots_fired = 0;
                e.shot_timer = randomize_enemy_timer(12, 0.25);


                // Switch immediately to idle
                if (e.enemy_sprite != e.enemy_sprite_idle)
                {
                    e.enemy_sprite =
                        e.enemy_sprite_idle;

                    e.enemy_frame = 0;
                }
            }
        }
        break;


        // ==============================
        // ATTACK
        // ==============================

        case RaidEnemyState.ATTACK:
        {
            // Enemy is standing still here,
            // so use idle animation
            if (e.enemy_sprite != e.enemy_sprite_idle)
            {
                e.enemy_sprite =
                    e.enemy_sprite_idle;

                e.enemy_frame = 0;
            }


            if (e.shot_timer > 0)
                e.shot_timer--;


			 if (e.shot_timer <= 0 && e.shots_fired < 3)
			{
			    var _dir =
			        point_direction(
			            e.enemy_x,
			            e.enemy_y,
			            raid_player_x,
			            raid_player_y
			        );

			    e.enemy_gun_angle = _dir;

			    e = raid_enemy_fire_gun(
			        e,
			        _dir,
			        2,
			        10
			    );

			    e.shots_fired++;
                e.shot_timer = randomize_enemy_timer(12, 0.25);
			}


            if (
                e.shots_fired >= 3
                && e.shot_timer <= 0
            )
            {
                e.enemy_state =
                    RaidEnemyState.PAUSE;

                e.state_timer = randomize_enemy_timer(45, 0.25);
            }
        }
        break;


        // ==============================
        // PAUSE
        // ==============================

        case RaidEnemyState.PAUSE:
        {
            if (e.enemy_sprite != e.enemy_sprite_idle)
            {
                e.enemy_sprite =
                    e.enemy_sprite_idle;

                e.enemy_frame = 0;
            }


            e.state_timer--;


            if (e.state_timer <= 0)
            {
                e =
                    raid_enemy_pick_random_position(
                        e
                    );

                e.enemy_state =
                    RaidEnemyState.MOVE;
            }
        }
        break;
    }


    return e;
}
