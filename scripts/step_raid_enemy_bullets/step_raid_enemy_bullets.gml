function step_raid_enemy_bullets()
{
    for (var i = array_length(raid_enemy_bullets) - 1; i >= 0; i--)
    {
        var b = raid_enemy_bullets[i];


        // ==================================================
        // MOVE BULLET
        // ==================================================

        b.bx += lengthdir_x(
            b.bspeed * frame_scale,
            b.bdirection
        );

        b.by += lengthdir_y(
            b.bspeed * frame_scale,
            b.bdirection
        );


        // ==================================================
        // PLAYER COLLISION
        // ==================================================

        var _player_bbox = raid_player_get_collision_bbox();

        if (
            b.bx >= _player_bbox.left
            && b.bx <= _player_bbox.right
            && b.by >= _player_bbox.top
            && b.by <= _player_bbox.bottom
        )
        {
            raid_player_take_damage(10, b.bdirection);


            // ==============================================
            // PLAYER DIED / RAID ENDED
            // raid_combat_loss() cleared the bullet arrays
            // ==============================================

            if (!raid.active)
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
