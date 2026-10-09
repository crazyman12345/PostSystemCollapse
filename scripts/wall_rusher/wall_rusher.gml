function wall_rusher(_enemy)
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

                e.enemy_state =
                    RaidEnemyState.DASH;
            }
        }
        break;


        case RaidEnemyState.DASH:
        {
            var _next_x =
                e.enemy_x
                + lengthdir_x(
                    e.dash_speed,
                    e.dash_dir
                );

            var _next_y =
                e.enemy_y
                + lengthdir_y(
                    e.dash_speed,
                    e.dash_dir
                );


            // ==========================================
            // CHECK ROOM WALL
            // ==========================================

            var _hit_wall = false;

            var _next_bbox = raid_enemy_get_collision_bbox_at(e, _next_x, _next_y);

            if (_next_bbox.left <= raid_room_x1)
            {
                _next_x += raid_room_x1 - _next_bbox.left;

                _hit_wall = true;
            }

            _next_bbox = raid_enemy_get_collision_bbox_at(e, _next_x, _next_y);
            if (_next_bbox.right >= raid_room_x2)
            {
                _next_x -= _next_bbox.right - raid_room_x2;

                _hit_wall = true;
            }

            _next_bbox = raid_enemy_get_collision_bbox_at(e, _next_x, _next_y);
            if (_next_bbox.top <= raid_room_y1)
            {
                _next_y += raid_room_y1 - _next_bbox.top;

                _hit_wall = true;
            }

            _next_bbox = raid_enemy_get_collision_bbox_at(e, _next_x, _next_y);
            if (_next_bbox.bottom >= raid_room_y2)
            {
                _next_y -= _next_bbox.bottom - raid_room_y2;

                _hit_wall = true;
            }


            e.enemy_x = _next_x;
            e.enemy_y = _next_y;


            // ==========================================
            // SLAMMED INTO WALL
            // ==========================================

            if (_hit_wall)
            {
                e.enemy_state =
                    RaidEnemyState.PAUSE;

                e.state_timer = randomize_enemy_timer(90, 0.25);
            }
        }
        break;
    }

    return e;
}
