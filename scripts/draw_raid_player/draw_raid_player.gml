function draw_raid_player(_lighting_mask = false, _mask_alpha = 1)
{
    if (raid.state == RaidState.DEATH)
    {
        if (raid_player_death_phase <= 1)
        {
            draw_sprite_ext(
                raid_player_death_sprite,
                raid_player_death_frame,
                round(raid_player_death_x),
                round(raid_player_death_y),
                raid_player_death_facing * raid_player_death_scale,
                raid_player_death_scale,
                0,
                c_red,
                _lighting_mask ? _mask_alpha : 1
            );
        }

        return;
    }

    var member = crew[0];

    var _base;

    if (raid_player_moving)
        _base = spr_player_run;
    else
        _base = spr_player_idle;
	
	
	
    var _frame =
        floor(raid_player_anim_frame)
        mod sprite_get_number(_base);

    var _x = round(raid_player_x);
    var _y = round(raid_player_y);

	var _player_alpha = 1;

	if (raid_player_invincible)
	{
	    if (
	        floor(
	            raid_player_invincible_timer / 5
	        )
	        mod 2 == 0
	    )
	    {
	        _player_alpha = 0.35;
	    }
	}

    // ==============================
    // DASH TRAIL - BEHIND PLAYER
    // ==============================

    for (var i = 0; !_lighting_mask && i < array_length(raid_player_dash_trail); i++)
    {
        var _trail = raid_player_dash_trail[i];
        var _trail_alpha =
            (_trail.trail_timer / raid_player_dash_trail_time)
            * 0.5;

        draw_sprite_ext(
            spr_player_run,
            _trail.trail_frame mod sprite_get_number(spr_player_run),
            round(_trail.trail_x),
            round(_trail.trail_y),
            _trail.trail_facing,
            1,
            0,
            c_white,
            _trail_alpha
        );
    }

    // ==============================
    // BAG - BEHIND PLAYER
    // ==============================

    raid_draw_equipment_layer(
        member.bag,
        _frame,
        _x,
        _y,
        _lighting_mask ? _mask_alpha : 1
    );


    // ==============================
    // BASE BODY
    // ==============================

    draw_sprite_ext(
        _base,
        _frame,
        _x,
        _y,
        raid_player_facing,
        1,
        0,
        c_white,
        _lighting_mask ? _mask_alpha : _player_alpha
    );


    // ==============================
    // CHEST ARMOR
    // ==============================

    raid_draw_equipment_layer(
        member.armor_chest,
        _frame,
        _x,
        _y,
        _lighting_mask ? _mask_alpha : 1
    );


    // ==============================
    // HELMET
    // ==============================

    raid_draw_equipment_layer(
        member.armor_head,
        _frame,
        _x,
        _y,
        _lighting_mask ? _mask_alpha : 1
    );
}
