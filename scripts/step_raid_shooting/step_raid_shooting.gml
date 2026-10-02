function step_raid_shooting()
{
    var member = crew[0];

    if (member.weapon == "")
        return;

    var _weapon = item_get(member.weapon);

    if (!is_struct(_weapon))
        return;


    // ======================================================
    // NEW / CHANGED WEAPON
    // ======================================================

    if (raid_weapon_loaded_key != member.weapon)
    {
        raid_weapon_loaded_key = member.weapon;

        raid_weapon_mag = _weapon.mag_size;

        raid_reload_active = false;
        raid_reload_timer = 0;

        raid_shot_cooldown = 0;
        raid_burst_remaining = 0;

        raid_fire_mode_index = 0;
        raid_current_fire_mode = _weapon.fire_modes[0];
    }


    // ======================================================
    // AIM TOWARD MOUSE
    // ======================================================

    var _pivot_x = raid_player_x;
    var _pivot_y = raid_player_y - 12;

    raid_aim_dir = point_direction(
        _pivot_x,
        _pivot_y,
        mouse_x,
        mouse_y
    );


    // ======================================================
    // SHOT COOLDOWN
    // ======================================================

    if (raid_shot_cooldown > 0)
        raid_shot_cooldown--;


    // ======================================================
    // FIRE MODE SWITCH
    // B
    // ======================================================

    if (
        keyboard_check_pressed(ord("B"))
        && array_length(_weapon.fire_modes) > 1
    )
    {
        raid_fire_mode_index++;

        if (
            raid_fire_mode_index
            >= array_length(_weapon.fire_modes)
        )
        {
            raid_fire_mode_index = 0;
        }

        raid_current_fire_mode =
            _weapon.fire_modes[
                raid_fire_mode_index
            ];

        raid_burst_remaining = 0;
    }


    // ======================================================
    // CURRENTLY RELOADING
    // ======================================================

    if (raid_reload_active)
    {
        raid_reload_timer--;

        if (raid_reload_timer <= 0)
        {
            raid_weapon_finish_reload(
                _weapon
            );
        }

        return;
    }


// ======================================================
// START RELOAD
// ======================================================

if (keyboard_check_pressed(ord("R")))
{
    if (raid_weapon_mag < _weapon.mag_size)
    {
        raid_reload_active = true;

        raid_reload_timer =
            _weapon.reload_time;

        raid_burst_remaining = 0;


        var _snd = audio_play_sound(
            _weapon.sound_reload,
            0,
            false
        );

        audio_sound_pitch(
            _snd,
            1.2
        );
    }

    return;
}
    // ======================================================
    // DETERMINE IF GUN SHOULD FIRE
    // ======================================================

    var _fire = false;

    switch (raid_current_fire_mode)
    {
        case WeaponFireMode.SEMI:
        {
            _fire =
                mouse_check_button_pressed(
                    mb_left
                );
        }
        break;


        case WeaponFireMode.AUTO:
        {
            _fire =
                mouse_check_button(
                    mb_left
                );
        }
        break;


        case WeaponFireMode.BURST:
        {
            if (
                mouse_check_button_pressed(
                    mb_left
                )
                && raid_burst_remaining <= 0
            )
            {
                raid_burst_remaining = 3;
            }

            if (
                raid_burst_remaining > 0
                && raid_shot_cooldown <= 0
            )
            {
                _fire = true;
            }
        }
        break;
    }


    // ======================================================
    // EMPTY MAG
    // ======================================================

    if (
        _fire
        && raid_weapon_mag <= 0
    )
    {
        raid_burst_remaining = 0;
		   audio_play_sound(
		        _weapon.sound_empty,
		        0,
		        false
		    );
        return;
    }


    // ======================================================
    // FIRE
    // ======================================================

    if (
        _fire
        && raid_shot_cooldown <= 0
        && raid_weapon_mag > 0
    )
    {
        // ----------------------------------------------
        // GUN POSITION
        // ----------------------------------------------

        var _gun_x =
            _pivot_x
            + lengthdir_x(
                raid_gun_offset,
                raid_aim_dir
            );

        var _gun_y =
            _pivot_y
            + lengthdir_y(
                raid_gun_offset,
                raid_aim_dir
            );


        // ----------------------------------------------
        // MUZZLE OFFSET
        // ----------------------------------------------

        var _mx = _weapon.muzzle_x;
        var _my = _weapon.muzzle_y;

        if (
            raid_aim_dir > 90
            && raid_aim_dir < 270
        )
        {
            _my *= -1;
        }


        // ----------------------------------------------
        // MUZZLE WORLD POSITION
        // ----------------------------------------------

        var _muzzle_x =
            _gun_x
            + lengthdir_x(
                _mx,
                raid_aim_dir
            )
            + lengthdir_x(
                _my,
                raid_aim_dir + 90
            );

        var _muzzle_y =
            _gun_y
            + lengthdir_y(
                _mx,
                raid_aim_dir
            )
            + lengthdir_y(
                _my,
                raid_aim_dir + 90
            );


        // ----------------------------------------------
        // CREATE BULLET
        // ----------------------------------------------

        var bullet = {
            bx: _muzzle_x,
            by: _muzzle_y,

            bdirection: raid_aim_dir,

            bspeed: _weapon.bullet_speed,
            bdamage: irandom_range(
			    _weapon.damage_min,
			    _weapon.damage_max
			)
        };

        array_push(
            raid_bullets,
            bullet
        );
		
		audio_play_sound(
		_weapon.sound_shoot,
	    0,
	    false
		);

        // ----------------------------------------------
        // REMOVE ROUND FROM MAG
        // ----------------------------------------------

        raid_weapon_mag--;
		raid_gun_recoil = 5;

        // ----------------------------------------------
        // FIRE RATE
        // ----------------------------------------------

        raid_shot_cooldown =
            max(
                1,
                round(
                    game_get_speed(gamespeed_fps)
                    / _weapon.fire_rate
                )
            );


        // ----------------------------------------------
        // BURST
        // ----------------------------------------------

        if (
            raid_current_fire_mode
            == WeaponFireMode.BURST
        )
        {
            raid_burst_remaining--;
        }
    }
	
	if (raid_gun_recoil > 0)
	{
	    raid_gun_recoil -= raid_gun_recoil_return;

	    if (raid_gun_recoil < 0)
	        raid_gun_recoil = 0;
	}
}