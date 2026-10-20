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

            case RaidEnemyType.GRENADE_THROWER:
            {
                e = grenade_thrower(e);
            }
            break;

            case RaidEnemyType.BURST_DODGER:
            {
                e = burst_dodger(e);
            }
            break;

            case RaidEnemyType.SHOTGUN_BURSTER:
            {
                e = shotgun_burster(e);
            }
            break;

            case RaidEnemyType.BOMBER:
            {
                e = bomber(e);
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
		        e.enemy_gun_recoil_return * frame_scale;

		    if (e.enemy_gun_recoil < 0)
		        e.enemy_gun_recoil = 0;
		}

        if (e.enemy_hit_flash_timer > 0)
            e.enemy_hit_flash_timer -= frame_scale;

        // ==========================================
        // KEEP ENEMY INSIDE ROOM
        // ==========================================

        var _enemy_bbox = raid_enemy_get_collision_bbox(e);
        e.enemy_x = clamp(e.enemy_x, raid_room_x1 + e.enemy_x - _enemy_bbox.left, raid_room_x2 - (_enemy_bbox.right - e.enemy_x));
        e.enemy_y = clamp(e.enemy_y, raid_room_y1 + e.enemy_y - _enemy_bbox.top, raid_room_y2 - (_enemy_bbox.bottom - e.enemy_y));

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

            var _bullet_bbox = raid_enemy_get_collision_bbox(e);
            if (
                bullet.bx >= _bullet_bbox.left - 4
                && bullet.bx <= _bullet_bbox.right + 4
                && bullet.by >= _bullet_bbox.top - 4
                && bullet.by <= _bullet_bbox.bottom + 4
            )
            {
                if (!e.enemy_invulnerable)
                {
                    var _enemy_hp_before = e.enemy_hp;
                    e.enemy_hp -= bullet.bdamage;
                    e.enemy_last_hit_direction = bullet.bdirection;
                    if (e.enemy_hp < _enemy_hp_before)
                        blood_hit_effect(e.enemy_x, e.enemy_y, bullet.bdirection);
                    if (_enemy_hp_before > 0 && e.enemy_hp <= 0)
                    {
                        var _death_sound = audio_play_sound(choose(gore1, gore2, gore3, gore4, gore5), 0, false);
                        audio_sound_pitch(_death_sound, random_range(0.92, 1.08));
                    }
                    var _total_flash_duration = 8;
                    e.enemy_hit_flash_timer = _total_flash_duration + ceil(_total_flash_duration / 2);
                    play_impact_sound(raid_enemy_hit_sound, "bullet");
                }

                array_delete(
                    raid_bullets,
                    b,
                    1
                );

                break;
            }
        }
		//Colliding with player (like knife enemies)
		var _player_bbox = raid_player_get_collision_bbox();
		var _enemy_collision_bbox = raid_enemy_get_collision_bbox(e);
		if (
		    _enemy_collision_bbox.left <= _player_bbox.right
		    && _enemy_collision_bbox.right >= _player_bbox.left
		    && _enemy_collision_bbox.top <= _player_bbox.bottom
		    && _enemy_collision_bbox.bottom >= _player_bbox.top
		)
		{
			var _random_limb = e.enemy_type == RaidEnemyType.KNIFE_STALKER
				|| e.enemy_type == RaidEnemyType.KNIFE_DASHER;
		    raid_player_take_damage(10, point_direction(e.enemy_x, e.enemy_y, raid_player_x, raid_player_y), e.enemy_x, e.enemy_y, false, _random_limb);

		    if (raid.state != RaidState.COMBAT)
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
			    var _speed_ratio = (_actual_move_speed / max(0.001, frame_scale))
			        / max(0.001, e.enemy_animation_reference_speed);

			        e.enemy_image_speed = clamp(
			            e.enemy_animation_base_speed * _speed_ratio,
			            0.08,
			            0.35
			        );
			        e.enemy_frame += e.enemy_image_speed * frame_scale;
			    }
			    else
			    {
			        e.enemy_image_speed = e.enemy_animation_base_speed;
			        e.enemy_frame += e.enemy_image_speed * frame_scale;
			    }
			}
			else
			{
			    e.enemy_frame += e.enemy_image_speed * frame_scale;
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
		    player_skill_add_xp("marksmanship", skill_xp_awards.marksmanship_kill);

		    if (
		        variable_struct_exists(e, "enemy_sprite")
		        && e.enemy_sprite != -1
		    )
		    {
		        raid_create_enemy_death_effect(e);
		    }

		    var _death_direction = !is_undefined(e.enemy_last_hit_direction)
		        ? e.enemy_last_hit_direction
		        : random(360);
		    blood_death_effect(e.enemy_x, e.enemy_y, _death_direction);

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

        if (raid.state == RaidState.COMBAT)
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
        if (is_struct(raid_room_clear_light)) raid_room_clear_light.enabled = true;

        raid.rooms_cleared++;
        raid.rooms_in_section++;
		
		//SPAWN LOOTABLES
		raid_spawn_reward_lootable(
        raid.current_reward_type
		);

        if (raid.rooms_cleared >= 15)
        {
            raid.extract_active = true;
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
