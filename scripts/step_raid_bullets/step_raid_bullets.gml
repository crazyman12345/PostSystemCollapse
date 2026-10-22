function step_raid_bullets()
{
    for (var i = array_length(raid_bullets) - 1; i >= 0; i--)
    {
        var b = raid_bullets[i];
        var _previous_x = b.bx;
        var _previous_y = b.by;

        b.bx += lengthdir_x(b.bspeed * frame_scale, b.bdirection);
        b.by += lengthdir_y(b.bspeed * frame_scale, b.bdirection);
        b.btravel_distance += point_distance(_previous_x, _previous_y, b.bx, b.by);
        b = projectile_smoke_update(b, _previous_x, _previous_y);

        raid_bullets[i] = b;

        if (
            b.bx < raid_room_x1 ||
            b.bx > raid_room_x2 ||
            b.by < raid_room_y1 ||
            b.by > raid_room_y2
        )
        {
            array_delete(raid_bullets, i, 1);
        }
    }
}
