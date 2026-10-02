function step_raid_enemies()
{
    for (var i = array_length(raid_enemies) - 1; i >= 0; i--)
    {
        var e = raid_enemies[i];

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
        }
		
		if (e.enemy_gun_recoil > 0)
		{
		    e.enemy_gun_recoil -=
		        e.enemy_gun_recoil_return;

		    if (e.enemy_gun_recoil < 0)
		        e.enemy_gun_recoil = 0;
		}
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
		}
		//direction facing
		if (raid_player_x < e.enemy_x)
		    e.enemy_facing = -1;
		else
		    e.enemy_facing = 1;
		if (e.enemy_sprite != -1)
		{
			e.enemy_frame += e.enemy_image_speed;

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