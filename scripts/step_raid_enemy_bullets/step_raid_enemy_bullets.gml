function step_raid_enemy_bullets()
{
    for (var i = array_length(raid_enemy_bullets) - 1; i >= 0; i--)
    {
        var b = raid_enemy_bullets[i];
        var _previous_x = b.bx;
        var _previous_y = b.by;


        // ==================================================
        // MOVE BULLET
        // ==================================================

        if (!b.stopped)
        {
            var _move_distance = b.bspeed * frame_scale;

            if (b.travel_remaining >= 0)
                _move_distance = min(_move_distance, b.travel_remaining);

            b.bx += lengthdir_x(_move_distance, b.bdirection);
            b.by += lengthdir_y(_move_distance, b.bdirection);
            b = projectile_smoke_update(b, _previous_x, _previous_y);

            if (b.travel_remaining >= 0)
            {
                b.travel_remaining -= _move_distance;

                if (b.travel_remaining <= 0)
                    b.stopped = true;
            }
        }

        if (b.stopped)
        {
            if (b.linger_timer > 0)
            {
                b.linger_timer -= frame_scale;
            }
            else
            {
                b.fade_timer -= frame_scale;
                b.alpha = b.fade_duration > 0
                    ? clamp(b.fade_timer / b.fade_duration, 0, 1)
                    : 0;

                if (b.fade_timer <= 0)
                {
                    array_delete(raid_enemy_bullets, i, 1);
                    continue;
                }
            }
        }


        // ==================================================
        // PLAYER COLLISION
        // ==================================================

        var _player_bbox = raid_player_get_collision_bbox();
        var _nearest_player_x = clamp(b.bx, _player_bbox.left, _player_bbox.right);
        var _nearest_player_y = clamp(b.by, _player_bbox.top, _player_bbox.bottom);

        if (
            point_distance(b.bx, b.by, _nearest_player_x, _nearest_player_y) <= b.collision_radius
        )
        {
            if (raid_hit_region_debug_enabled)
            {
                raid_hit_region_debug_impact_x = b.bx;
                raid_hit_region_debug_impact_y = b.by;
                raid_hit_region_debug_region = "BLOCKED";
                raid_hit_region_debug_limb = "NONE";
            }
            raid_player_take_damage(10, b.bdirection, b.bx, b.by, true);


            // ==============================================
            // PLAYER DIED / DEATH CINEMATIC STARTED
            // Leave arrays intact until the deferred loss cleanup.
            // ==============================================

            if (raid.state != RaidState.COMBAT)
                return;


            // ==============================================
            // PLAYER SURVIVED - REMOVE BULLET
            // ==============================================

            array_delete(
                raid_enemy_bullets,
                i,
                1
            );

            continue;
        }


        // ==================================================
        // REMOVE OUTSIDE ROOM
        // ==================================================

        if (
            b.bx < raid_room_x1 ||
            b.bx > raid_room_x2 ||
            b.by < raid_room_y1 ||
            b.by > raid_room_y2
        )
        {
            array_delete(
                raid_enemy_bullets,
                i,
                1
            );

            continue;
        }


        // ==================================================
        // SAVE BULLET BACK
        // ==================================================

        raid_enemy_bullets[i] = b;
    }
}
