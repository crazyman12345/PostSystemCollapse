function step_raid_enemies()
{
    for (var i = array_length(raid_enemies) - 1; i >= 0; i--)
    {
        var e = raid_enemies[i];
		
		// ==========================================
		// INVALID ENEMY SAFETY
		// ==========================================

		if (!is_struct(e))
		{
		    show_debug_message("INVALID RAID ENEMY [" + string(i) + "]: " + string(e));
		    continue;
		}

		var _start_x = e.enemy_x;
		var _start_y = e.enemy_y;

		if (!variable_struct_exists(e, "enemy_type"))
		{
		    show_debug_message("RAID ENEMY MISSING enemy_type [" + string(i) + "]");
		    continue;
		}

        // ==========================================
        // ENEMY AI
        // ==========================================
		
        switch (e.enemy_type)
        {
            case RaidEnemyType.BURST_SHOOTER:
            {
                e = burst_shooter(e);
            }
            break;

            case RaidEnemyType.KNIFE_STALKER:
            {
                e = knife_stalker(e);
            }
            break;

            case RaidEnemyType.SPINNER:
            {
                e = spinner(e);
            }
            break;

            case RaidEnemyType.KNIFE_DASHER:
            {
                e = knife_dasher(e);
            }
            break;
			
			case RaidEnemyType.WALL_RUSHER:
			{
				e = wall_rusher(e);
			}
			break;

			case RaidEnemyType.BONES:
			{
				e = bones(e);
			}
        }
		
		if (e.enemy_gun_recoil > 0)
		{
		    e.enemy_gun_recoil -=
		        e.enemy_gun_recoil_return;

		    if (e.enemy_gun_recoil < 0)
		        e.enemy_gun_recoil = 0;
		}

        if (e.enemy_hit_flash_timer > 0)
            e.enemy_hit_flash_timer--;

        // ==========================================
        // KEEP ENEMY INSIDE ROOM
        // ==========================================

        e.enemy_x = clamp(
            e.enemy_x,
            raid_room_x1 + e.enemy_radius,
            raid_room_x2 - e.enemy_radius
        );

        e.enemy_y = clamp(
            e.enemy_y,
            raid_room_y1 + e.enemy_radius,
            raid_room_y2 - e.enemy_radius
        );

		var _actual_move_speed = point_distance(
		    _start_x,
		    _start_y,
		    e.enemy_x,
		    e.enemy_y
		);

        // ==========================================
        // PLAYER BULLET COLLISION
        // ==========================================

        for (var b = array_length(raid_bullets) - 1; b >= 0; b--)
        {
            var bullet = raid_bullets[b];

            var _dist = point_distance(
                e.enemy_x,
                e.enemy_y,
                bullet.bx,
                bullet.by
            );

            if (_dist <= e.enemy_radius + 4)
            {
                e.enemy_hp -= bullet.bdamage;
                var _total_flash_duration = max(2, round(game_get_speed(gamespeed_fps) / 8));
                e.enemy_hit_flash_timer = _total_flash_duration + ceil(_total_flash_duration / 2);
                play_impact_sound(raid_enemy_hit_sound, "bullet");

                array_delete(
                    raid_bullets,
                    b,
                    1
                );

                break;
            }
        }
		//Colliding with player (like knife enemies)
		if (
		    point_distance(
		        e.enemy_x,
		        e.enemy_y,
		        raid_player_x,
		        raid_player_y
		    )
		    <= e.enemy_radius + 12
		)
		{
		    raid_player_take_damage(10);

		    if (!raid.active)
		        return;
		}
		//direction facing
		if (raid_player_x < e.enemy_x)
		    e.enemy_facing = -1;
		else
		    e.enemy_facing = 1;
		if (e.enemy_sprite != -1)
		{
			if (
			    variable_struct_exists(e, "enemy_sprite_idle")
			    && variable_struct_exists(e, "enemy_sprite_active")
			)
			{
			    var _is_moving = _actual_move_speed > 0;
			    var _desired_sprite = _is_moving
			        ? e.enemy_sprite_active
			        : e.enemy_sprite_idle;

			    if (e.enemy_sprite != _desired_sprite)
			    {
			        e.enemy_sprite = _desired_sprite;
			        e.enemy_frame = 0;
			    }

			    if (_is_moving)
			    {
			        var _speed_ratio = _actual_move_speed
			            / max(0.001, e.enemy_animation_reference_speed);

			        e.enemy_image_speed = clamp(
			            e.enemy_animation_base_speed * _speed_ratio,
			            0.08,
			            0.35
			        );
			        e.enemy_frame += e.enemy_image_speed;
			    }
			    else
			    {
			        e.enemy_image_speed = e.enemy_animation_base_speed;
			        e.enemy_frame = 0;
			    }
			}
			else
			{
			    e.enemy_frame += e.enemy_image_speed;
			}

			var _frame_count = sprite_get_number(e.enemy_sprite);

			if (e.enemy_frame >= _frame_count)
				e.enemy_frame = 0;
		}
        // ==========================================
        // DEATH
        // ==========================================

		if (e.enemy_hp <= 0)
		{
		    if (
		        variable_struct_exists(e, "enemy_sprite")
		        && e.enemy_sprite != -1
		    )
		    {
		        raid_create_enemy_death_effect(e);
		    }

		    array_delete(
		        raid_enemies,
		        i,
		        1
		    );

		    continue;
		}

        // ==========================================
        // SAVE ENEMY BACK
        // ==========================================

        if (raid.active)
            raid_enemies[i] = e;
    }

    // ==========================================
    // ROOM CLEAR
    // ==========================================

    if (
        array_length(raid_enemies) <= 0
        && !raid.room_cleared
    )
    {
        raid.room_cleared = true;
        raid.reward_unlocked = true;

        raid.rooms_cleared++;
        raid.rooms_in_section++;
		
		//SPAWN LOOTABLES
		raid_spawn_reward_lootable(
        raid.current_reward_type
		);

        if (raid.rooms_cleared >= 20)
        {
            // boss later
            return;
        }

        if (raid.rooms_in_section >= 5)
        {
            raid_activate_checkpoint();
            return;
        }

        raid_create_next_doors();
    }
}
