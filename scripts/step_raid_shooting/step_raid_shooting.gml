function step_raid_shooting(_allow_input)
{
    raid_update_active_weapon();

    if (_allow_input && (mouse_wheel_up() || mouse_wheel_down()))
    {
        raid_switch_weapon();
    }

    var _weapon = raid_update_active_weapon();

    if (active_weapon_slot == EquipmentSlot.WEAPON_2)
    {
        raid_weapon_slot_display_target = 1;
    }
    else
    {
        raid_weapon_slot_display_target = 0;
    }

    raid_weapon_slot_display = lerp(
        raid_weapon_slot_display,
        raid_weapon_slot_display_target,
        1 - power(0.65, frame_scale)
    );

    // ======================================================
    // NEW / CHANGED GUN
    // ======================================================

    if (
        !is_undefined(_weapon)
        && (
            raid_weapon_loaded_slot != active_weapon_slot
            || raid_weapon_loaded_key != equipment_get_slot_item(
                raid.crew_index,
                active_weapon_slot
            )
        )
    )
    {
        if (raid_weapon_loaded_slot >= 0)
        {
            raid_weapon_mags[raid_weapon_loaded_slot] = raid_weapon_mag;
        }

        raid_weapon_loaded_slot = active_weapon_slot;
        raid_weapon_loaded_key = equipment_get_slot_item(
            raid.crew_index,
            active_weapon_slot
        );

        if (
            raid_weapon_slot_keys[active_weapon_slot]
            != raid_weapon_loaded_key
        )
        {
            raid_weapon_slot_keys[active_weapon_slot] = raid_weapon_loaded_key;
            raid_weapon_mags[active_weapon_slot] = _weapon.mag_size;
        }

        raid_weapon_mag = raid_weapon_mags[active_weapon_slot];

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
        raid_shot_cooldown -= frame_scale;

    if (!_allow_input) raid_burst_remaining = 0;

    for (var t = array_length(raid_knife_trail) - 1; t >= 0; t--)
    {
        var _trail = raid_knife_trail[t];
        _trail.trail_timer -= frame_scale;

        if (_trail.trail_timer <= 0)
        {
            array_delete(raid_knife_trail, t, 1);
            continue;
        }

        raid_knife_trail[t] = _trail;
    }

    // ======================================================
    // BUILT-IN KNIFE
    // ======================================================

    if (is_undefined(_weapon))
    {
        raid_reload_active = false;
        raid_reload_timer = 0;

        var _knife_timer_before = raid_knife_attack_timer;

        if (raid_knife_attack_timer > 0)
        {
            raid_knife_attack_timer -= frame_scale;
        }

        if (
            _allow_input
            && mouse_check_button_pressed(mb_left)
            && raid_shot_cooldown <= 0
        )
        {
            raid_knife_attack_timer = raid_knife_attack_time;
            raid_knife_attack_hit = false;
            raid_knife_attack_dir = raid_aim_dir;
            raid_knife_trail_accumulator = max(0, 1 - frame_scale);
            raid_shot_cooldown = 12;
        }

        if (raid_knife_attack_timer > 0)
        {
            var _progress = 1 - (raid_knife_attack_timer / raid_knife_attack_time);
            var _knife_raise = 90 * raid_player_facing;
            var _knife_dir;
            var _stab_distance;

            if (_progress < 0.625)
            {
                _knife_dir = raid_knife_attack_dir + _knife_raise - (_knife_raise * min(1, _progress / 0.25));
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

            raid_knife_trail_accumulator += frame_scale;
            if (raid_knife_trail_accumulator >= 1)
            {
                array_push(raid_knife_trail, {
                    trail_hand_x: raid_player_x + lengthdir_x(12, raid_knife_attack_dir) + lengthdir_x(_stab_distance, _knife_dir),
                    trail_hand_y: raid_player_y - 10 + lengthdir_y(12, raid_knife_attack_dir) + lengthdir_y(_stab_distance, _knife_dir),
                    trail_dir: _knife_dir,
                    trail_timer: raid_knife_trail_time
                });
                raid_knife_trail_accumulator -= 1;
            }
        }

        if (
            _allow_input
            && _knife_timer_before > floor(raid_knife_attack_time * 0.5)
            && raid_knife_attack_timer <= floor(raid_knife_attack_time * 0.5)
            && !raid_knife_attack_hit
        )
        {
            var _attack_x = raid_player_x + lengthdir_x(60, raid_knife_attack_dir);
            var _attack_y = raid_player_y + lengthdir_y(60, raid_knife_attack_dir);
            var _target_index = -1;
            var _target_distance = 9999;

            for (var i = 0; i < array_length(raid_enemies); i++)
            {
                var _enemy = raid_enemies[i];
                var _enemy_bbox = raid_enemy_get_collision_bbox(_enemy);
                var _distance = point_distance(_attack_x, _attack_y, _enemy.enemy_x, _enemy.enemy_y);
                if (
                    _attack_x >= _enemy_bbox.left - 8
                    && _attack_x <= _enemy_bbox.right + 8
                    && _attack_y >= _enemy_bbox.top - 8
                    && _attack_y <= _enemy_bbox.bottom + 8
                    && _distance < _target_distance
                )
                {
                    _target_index = i;
                    _target_distance = _distance;
                }
            }

            if (_target_index >= 0)
            {
                var _target = raid_enemies[_target_index];
                if (!_target.enemy_invulnerable)
                {
                    var _enemy_hp_before = _target.enemy_hp;
                    _target.enemy_hp -= 5;
                    _target.enemy_last_hit_direction = raid_knife_attack_dir;
                    if (_target.enemy_hp < _enemy_hp_before)
                        blood_hit_effect(_target.enemy_x, _target.enemy_y, raid_knife_attack_dir);
                    player_skill_add_xp("strength", skill_xp_awards.strength_knife_hit);
                    var _total_flash_duration = 8;
                    _target.enemy_hit_flash_timer = _total_flash_duration + ceil(_total_flash_duration / 2);
                    play_impact_sound(raid_enemy_hit_sound, "knife");
                }
                raid_enemies[_target_index] = _target;
            }

            raid_knife_attack_hit = true;
        }

        return;
    }


    // ======================================================
    // FIRE MODE SWITCH
    // B
    // ======================================================

    if (
        _allow_input
        && keyboard_check_pressed(ord("B"))
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
        raid_reload_timer -= frame_scale;

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

if (_allow_input && keyboard_check_pressed(ord("R")))
{
    if (raid_weapon_mag < _weapon.mag_size)
    {
        raid_reload_active = true;
		var _quick_hands = skill_node_find(skill_node_get_nodes("marksmanship"), "quick_hands_1");
		var _reload_time_multiplier = !is_undefined(_quick_hands) && skill_node_is_unlocked("marksmanship", _quick_hands) ? 0.95 : 1;

        raid_reload_timer =
			_weapon.reload_time * _reload_time_multiplier;

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
                _allow_input
                && mouse_check_button_pressed(
                    mb_left
                );
        }
        break;


        case WeaponFireMode.AUTO:
        {
            _fire =
                _allow_input
                && mouse_check_button(
                    mb_left
                );
        }
        break;


        case WeaponFireMode.BURST:
        {
            if (
                _allow_input
                && mouse_check_button_pressed(
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

        var _tuning = raid_gun_tuning_get(raid_gun_tuning_weapon_key, _weapon);
        var _fire_dir = raid_aim_dir + _tuning.weapon_angle_offset;
        var _fire_flip = (_fire_dir > 90 && _fire_dir < 270) ? -1 : 1;

        var _gun_x =
            _pivot_x
            + lengthdir_x(
                _tuning.weapon_offset_x,
                _fire_dir
            )
            + lengthdir_x(_tuning.weapon_offset_y, _fire_dir + 90);

        var _gun_y =
            _pivot_y
            + lengthdir_y(
                _tuning.weapon_offset_x,
                _fire_dir
            )
            + lengthdir_y(_tuning.weapon_offset_y, _fire_dir + 90);


        // ----------------------------------------------
        // MUZZLE OFFSET
        // ----------------------------------------------

        var _mx = _tuning.muzzle_offset_x;
        var _my = _tuning.muzzle_offset_y * _fire_flip;


        // ----------------------------------------------
        // MUZZLE WORLD POSITION
        // ----------------------------------------------

        var _muzzle_x =
            _gun_x
            + lengthdir_x(
                _mx,
                _fire_dir
            )
            + lengthdir_x(
                _my,
                _fire_dir + 90
            );

        var _muzzle_y =
            _gun_y
            + lengthdir_y(
                _mx,
                _fire_dir
            )
            + lengthdir_y(
                _my,
                _fire_dir + 90
            );


        // ----------------------------------------------
        // CREATE BULLET
        // ----------------------------------------------

		var _pellet_count = variable_struct_exists(_weapon, "pellet_count")
			? _weapon.pellet_count
			: 1;
		var _pellet_spread = variable_struct_exists(_weapon, "pellet_spread")
			? _weapon.pellet_spread
			: 0;
		var _lethal_aim = skill_node_find(skill_node_get_nodes("marksmanship"), "lethal_aim");
		var _gun_damage_multiplier = !is_undefined(_lethal_aim) && skill_node_is_unlocked("marksmanship", _lethal_aim) ? 1.05 : 1;

		for (var i = 0; i < _pellet_count; i++)
		{
			var _pellet_angle = _fire_dir + random_range(-_pellet_spread, _pellet_spread);
			var bullet = {
				bx: _muzzle_x,
				by: _muzzle_y,

				bdirection: _pellet_angle,

				bspeed: _weapon.bullet_speed,
				bdamage: irandom_range(
					_weapon.damage_min,
					_weapon.damage_max
				) * _gun_damage_multiplier
			};

			array_push(
				raid_bullets,
				bullet
			);
		}
		
		audio_play_sound(
		_weapon.sound_shoot,
	    0,
	    false
		);

        // ----------------------------------------------
        // REMOVE ROUND FROM MAG
        // ----------------------------------------------

        raid_weapon_mag--;
		player_skill_add_xp("marksmanship", skill_xp_awards.marksmanship_shot);
		raid_gun_recoil = 5;

        // ----------------------------------------------
        // FIRE RATE
        // ----------------------------------------------

        raid_shot_cooldown =
            max(
                1,
                round(
                    60
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
	    raid_gun_recoil -= raid_gun_recoil_return * frame_scale;

	    if (raid_gun_recoil < 0)
	        raid_gun_recoil = 0;
	}
}
