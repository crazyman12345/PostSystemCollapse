function step_raid_player()
{
    var _mx = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var _my = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    // ==========================================
    // DASH
    // ==========================================

    raid_player_stamina = min(
        raid_player_max_stamina,
        raid_player_stamina + raid_player_stamina_regen
    );

    if (
        !raid_player_dash_active
        && raid_player_stamina >= raid_player_dash_stamina_cost
        && keyboard_check_pressed(vk_space)
    )
    {
        raid_player_dash_x = _mx;
        raid_player_dash_y = _my;

        if (raid_player_dash_x == 0 && raid_player_dash_y == 0)
        {
            raid_player_dash_x = mouse_x - raid_player_x;
            raid_player_dash_y = mouse_y - raid_player_y;
        }

        var _dash_len = point_distance(
            0,
            0,
            raid_player_dash_x,
            raid_player_dash_y
        );

        if (_dash_len > 0)
        {
            raid_player_dash_x /= _dash_len;
            raid_player_dash_y /= _dash_len;
            raid_player_dash_active = true;
            raid_player_dash_timer = raid_player_dash_time;
            raid_player_stamina -= raid_player_dash_stamina_cost;
        }
    }

    raid_player_moving = (
        _mx != 0
        || _my != 0
        || raid_player_dash_active
    );

    if (raid_player_moving != raid_player_was_moving)
        raid_player_anim_frame = 0;

    raid_player_was_moving = raid_player_moving;

    if (raid_player_dash_active)
    {
        var _dash_trail = {
            trail_x: raid_player_x,
            trail_y: raid_player_y,
            trail_frame: floor(raid_player_anim_frame),
            trail_facing: raid_player_facing,
            trail_timer: raid_player_dash_trail_time
        };

        array_push(raid_player_dash_trail, _dash_trail);

        raid_player_x += raid_player_dash_x * raid_player_dash_speed;
        raid_player_y += raid_player_dash_y * raid_player_dash_speed;

        raid_player_dash_timer--;

        if (raid_player_dash_timer <= 0)
        {
            raid_player_dash_active = false;
            raid_player_dash_timer = 0;
        }
    }
    else if (raid_player_moving)
    {
        var _len = point_distance(0, 0, _mx, _my);

        _mx /= _len;
        _my /= _len;

        raid_player_x += _mx * raid_player_speed;
        raid_player_y += _my * raid_player_speed;
    }

    for (
        var i = array_length(raid_player_dash_trail) - 1;
        i >= 0;
        i--
    )
    {
        var _trail = raid_player_dash_trail[i];
        _trail.trail_timer--;

        if (_trail.trail_timer <= 0)
        {
            array_delete(raid_player_dash_trail, i, 1);
            continue;
        }

        raid_player_dash_trail[i] = _trail;
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
