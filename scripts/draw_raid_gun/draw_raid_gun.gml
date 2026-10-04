function draw_raid_gun()
{
    var _weapon = raid_update_active_weapon();

    if (!is_struct(_weapon))
    {
        var _pivot_x = raid_player_x;
        var _pivot_y = raid_player_y - 10;
        var _knife_raise = 90 * raid_player_facing;
        var _knife_dir = raid_aim_dir + _knife_raise;
        var _hand_dir = raid_aim_dir;
        var _stab_distance = 0;

        if (raid_knife_attack_timer > 0)
        {
            var _progress = 1 - (raid_knife_attack_timer / raid_knife_attack_time);
            var _raised_dir = raid_knife_attack_dir + _knife_raise;
            _hand_dir = raid_knife_attack_dir;

            if (_progress < 0.625)
            {
                _knife_dir = _raised_dir - (_knife_raise * min(1, _progress / 0.25));
            }
            else
            {
                _knife_dir = raid_knife_attack_dir + (_knife_raise * ((_progress - 0.625) / 0.375));
            }

            if (_progress < 0.5)
            {
                _stab_distance = clamp((_progress - 0.25) / 0.25, 0, 1) * 42;
            }
            else if (_progress < 0.625)
            {
                _stab_distance = 42;
            }
            else
            {
                _stab_distance = clamp(1 - ((_progress - 0.625) / 0.375), 0, 1) * 42;
            }
        }

        var _hand_x = _pivot_x + lengthdir_x(12, _hand_dir) + lengthdir_x(_stab_distance, _knife_dir);
        var _hand_y = _pivot_y + lengthdir_y(12, _hand_dir) + lengthdir_y(_stab_distance, _knife_dir);
        var _handle_end_x = _hand_x + lengthdir_x(7, _knife_dir);
        var _handle_end_y = _hand_y + lengthdir_y(7, _knife_dir);
        var _blade_base_x = _handle_end_x;
        var _blade_base_y = _handle_end_y;
        var _blade_tip_x = _hand_x + lengthdir_x(22, _knife_dir);
        var _blade_tip_y = _hand_y + lengthdir_y(22, _knife_dir);
        var _blade_side_x = lengthdir_x(3, _knife_dir + 90);
        var _blade_side_y = lengthdir_y(3, _knife_dir + 90);
        var _handle_side_x = lengthdir_x(3, _knife_dir + 90);
        var _handle_side_y = lengthdir_y(3, _knife_dir + 90);

        for (var i = 0; i < array_length(raid_knife_trail); i++)
        {
            var _trail = raid_knife_trail[i];
            var _trail_handle_end_x = _trail.trail_hand_x + lengthdir_x(7, _trail.trail_dir);
            var _trail_handle_end_y = _trail.trail_hand_y + lengthdir_y(7, _trail.trail_dir);
            var _trail_blade_tip_x = _trail.trail_hand_x + lengthdir_x(22, _trail.trail_dir);
            var _trail_blade_tip_y = _trail.trail_hand_y + lengthdir_y(22, _trail.trail_dir);
            var _trail_side_x = lengthdir_x(3, _trail.trail_dir + 90);
            var _trail_side_y = lengthdir_y(3, _trail.trail_dir + 90);

            draw_set_alpha((_trail.trail_timer / raid_knife_trail_time) * 0.35);
            draw_set_color(c_white);
            draw_triangle(
                _trail_handle_end_x + _trail_side_x,
                _trail_handle_end_y + _trail_side_y,
                _trail_handle_end_x - _trail_side_x,
                _trail_handle_end_y - _trail_side_y,
                _trail_blade_tip_x,
                _trail_blade_tip_y,
                false
            );
        }

        draw_set_alpha(1);
        draw_set_color(c_black);
        draw_triangle(
            _hand_x + _handle_side_x,
            _hand_y + _handle_side_y,
            _hand_x - _handle_side_x,
            _hand_y - _handle_side_y,
            _handle_end_x + _handle_side_x,
            _handle_end_y + _handle_side_y,
            false
        );
        draw_triangle(
            _hand_x - _handle_side_x,
            _hand_y - _handle_side_y,
            _handle_end_x - _handle_side_x,
            _handle_end_y - _handle_side_y,
            _handle_end_x + _handle_side_x,
            _handle_end_y + _handle_side_y,
            false
        );
        draw_set_color(make_color_rgb(100, 60, 35));
        draw_triangle(
            _hand_x + (_handle_side_x * 0.5),
            _hand_y + (_handle_side_y * 0.5),
            _hand_x - (_handle_side_x * 0.5),
            _hand_y - (_handle_side_y * 0.5),
            _handle_end_x + (_handle_side_x * 0.5),
            _handle_end_y + (_handle_side_y * 0.5),
            false
        );
        draw_triangle(
            _hand_x - (_handle_side_x * 0.5),
            _hand_y - (_handle_side_y * 0.5),
            _handle_end_x - (_handle_side_x * 0.5),
            _handle_end_y - (_handle_side_y * 0.5),
            _handle_end_x + (_handle_side_x * 0.5),
            _handle_end_y + (_handle_side_y * 0.5),
            false
        );

        draw_set_color(c_black);
        draw_triangle(
            _blade_base_x + _blade_side_x,
            _blade_base_y + _blade_side_y,
            _blade_base_x - _blade_side_x,
            _blade_base_y - _blade_side_y,
            _blade_tip_x,
            _blade_tip_y,
            false
        );
        draw_set_color(c_white);
        draw_triangle(
            _blade_base_x + (_blade_side_x * 0.6),
            _blade_base_y + (_blade_side_y * 0.6),
            _blade_base_x - (_blade_side_x * 0.6),
            _blade_base_y - (_blade_side_y * 0.6),
            _blade_tip_x,
            _blade_tip_y,
            false
        );

        draw_sprite_ext(spr_hand, 0, round(_hand_x), round(_hand_y), 1, 1, _knife_dir, c_white, 1);
        draw_set_color(c_white);
        return;
    }

    var _pivot_x = raid_player_x;
    var _pivot_y = raid_player_y - 10;

    var _dir = raid_aim_dir;


    // ==============================
    // GUN POSITION
    // ==============================

var _draw_offset =
    raid_gun_offset
    - raid_gun_recoil;

var _gun_x =
    _pivot_x
    + lengthdir_x(
        _draw_offset,
        _dir
    );

var _gun_y =
    _pivot_y
    + lengthdir_y(
        _draw_offset,
        _dir
    );


    // ==============================
    // DRAW GUN
    // ==============================

		 var _flip_y = 1;

		if (raid_aim_dir > 90 && raid_aim_dir < 270)
		{
		    _flip_y = -1;
		}

		draw_sprite_ext(
		    _weapon.weapon_sprite,
		    0,
		    round(_gun_x),
		    round(_gun_y),
		    1,
		    _flip_y,
		    _dir,
		    c_white,
		    1
		);


    // ==============================
    // MAIN HAND
    // ==============================

    var _hand1_x =
        _gun_x
        + lengthdir_x(
            _weapon.hand1_x,
            _dir
        )
        + lengthdir_x(
            _weapon.hand1_y,
            _dir + 90
        );

    var _hand1_y =
        _gun_y
        + lengthdir_y(
            _weapon.hand1_x,
            _dir
        )
        + lengthdir_y(
            _weapon.hand1_y,
            _dir + 90
        );

		draw_sprite_ext(
		    spr_hand,
		    0,
		    round(_hand1_x),
		    round(_hand1_y),
		    1,
		    _flip_y,
		    _dir,
		    c_white,
		    1
		);


    // ==============================
    // SECOND HAND
    // ==============================

    if (_weapon.has_second_hand)
    {
        var _hand2_x =
            _gun_x
            + lengthdir_x(
                _weapon.hand2_x,
                _dir
            )
            + lengthdir_x(
                _weapon.hand2_y,
                _dir + 90
            );

        var _hand2_y =
            _gun_y
            + lengthdir_y(
                _weapon.hand2_x,
                _dir
            )
            + lengthdir_y(
                _weapon.hand2_y,
                _dir + 90
            );

		      draw_sprite_ext(
		    spr_hand,
		    0,
		    round(_hand2_x),
		    round(_hand2_y),
		    1,
		    _flip_y,
		    _dir,
		    c_white,
		    1
		);
		    }
}
