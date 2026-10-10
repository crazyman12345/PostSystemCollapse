function step_raid_player()
{
    var _start_x = raid_player_x;
    var _start_y = raid_player_y;
    var _mx = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var _my = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    // ==========================================
    // DASH
    // ==========================================

    raid_player_stamina = min(
        raid_player_max_stamina,
        raid_player_stamina + raid_player_stamina_regen * frame_scale
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
            raid_player_dash_trail_accumulator = max(0, 1 - frame_scale);
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
        raid_player_dash_trail_accumulator += frame_scale;
        if (raid_player_dash_trail_accumulator >= 1)
        {
            var _dash_trail = {
                trail_x: raid_player_x,
                trail_y: raid_player_y,
                trail_frame: floor(raid_player_anim_frame),
                trail_facing: raid_player_facing,
                trail_timer: raid_player_dash_trail_time
            };

            array_push(raid_player_dash_trail, _dash_trail);
            raid_player_dash_trail_accumulator -= 1;
        }

        var _dash_step = min(frame_scale, raid_player_dash_timer);
        raid_player_x += raid_player_dash_x * raid_player_dash_speed * _dash_step;
        raid_player_y += raid_player_dash_y * raid_player_dash_speed * _dash_step;

        raid_player_dash_timer -= frame_scale;

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

        raid_player_x += _mx * raid_player_speed * frame_scale;
        raid_player_y += _my * raid_player_speed * frame_scale;
    }

    for (
        var i = array_length(raid_player_dash_trail) - 1;
        i >= 0;
        i--
    )
    {
        var _trail = raid_player_dash_trail[i];
        _trail.trail_timer -= frame_scale;

        if (_trail.trail_timer <= 0)
        {
            array_delete(raid_player_dash_trail, i, 1);
            continue;
        }

        raid_player_dash_trail[i] = _trail;
    }

	raid_player_facing = 1;

	if (mouse_x < raid_player_x)
	    raid_player_facing = -1;
	else
    raid_player_facing = 1;

    var _bbox = raid_player_get_collision_bbox();

    raid_player_x = clamp(
        raid_player_x,
        raid_room_x1 + raid_player_x - _bbox.left,
        raid_room_x2 - (_bbox.right - raid_player_x)
    );

    raid_player_y = clamp(
        raid_player_y,
        raid_room_y1 + raid_player_y - _bbox.top,
        raid_room_y2 - (_bbox.bottom - raid_player_y)
    );

    raid_player_velocity_x = (raid_player_x - _start_x) / frame_scale;
    raid_player_velocity_y = (raid_player_y - _start_y) / frame_scale;

    var _target_velocity_x = raid_player_velocity_x;
    var _target_velocity_y = raid_player_velocity_y;
    var _velocity_deadzone = 0.1;

    if (point_distance(0, 0, _target_velocity_x, _target_velocity_y) < _velocity_deadzone)
    {
        _target_velocity_x = 0;
        _target_velocity_y = 0;
    }

    var _velocity_smoothing = 1 - power(1 - 0.065, frame_scale);
    raid_player_smoothed_velocity_x += (_target_velocity_x - raid_player_smoothed_velocity_x) * _velocity_smoothing;
    raid_player_smoothed_velocity_y += (_target_velocity_y - raid_player_smoothed_velocity_y) * _velocity_smoothing;
	
    raid_player_anim_frame += raid_player_anim_speed * frame_scale;
}

function raid_player_get_collision_bbox()
{
    var _sprite = raid_player_moving ? spr_player_run : spr_player_idle;
    var _x_origin = sprite_get_xoffset(_sprite);
    var _y_origin = sprite_get_yoffset(_sprite);
    var _left_offset;
    var _right_offset;

    if (raid_player_facing < 0)
    {
        _left_offset = _x_origin - sprite_get_bbox_right(_sprite);
        _right_offset = _x_origin - sprite_get_bbox_left(_sprite);
    }
    else
    {
        _left_offset = sprite_get_bbox_left(_sprite) - _x_origin;
        _right_offset = sprite_get_bbox_right(_sprite) - _x_origin;
    }

    return {
        left: raid_player_x + _left_offset,
        right: raid_player_x + _right_offset,
        top: raid_player_y + sprite_get_bbox_top(_sprite) - _y_origin,
        bottom: raid_player_y + sprite_get_bbox_bottom(_sprite) - _y_origin
    };
}
