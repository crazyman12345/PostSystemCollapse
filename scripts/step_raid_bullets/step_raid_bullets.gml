function step_raid_bullets()
{
    for (var i = array_length(raid_bullets) - 1; i >= 0; i--)
    {
        var b = raid_bullets[i];

        b.bx += lengthdir_x(b.bspeed, b.bdirection);
        b.by += lengthdir_y(b.bspeed, b.bdirection);

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