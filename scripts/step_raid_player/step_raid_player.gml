function step_raid_player()
{
    var _mx = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var _my = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    raid_player_moving = (_mx != 0 || _my != 0);

    if (raid_player_moving != raid_player_was_moving)
        raid_player_anim_frame = 0;

    raid_player_was_moving = raid_player_moving;

    if (raid_player_moving)
    {
        var _len = point_distance(0, 0, _mx, _my);

        _mx /= _len;
        _my /= _len;

        raid_player_x += _mx * raid_player_speed;
        raid_player_y += _my * raid_player_speed;
    }
	
	

    raid_player_x = clamp(
        raid_player_x,
        raid_room_x1 + raid_player_radius,
        raid_room_x2 - raid_player_radius
    );

    raid_player_y = clamp(
        raid_player_y,
        raid_room_y1 + raid_player_radius,
        raid_room_y2 - raid_player_radius
    );

	raid_player_facing = 1;

	if (mouse_x < raid_player_x)
	    raid_player_facing = -1;
	else
    raid_player_facing = 1;
	
    raid_player_anim_frame += raid_player_anim_speed;
}