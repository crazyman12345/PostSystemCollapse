function step_raid()
{
    // ==========================================
    // RESULT SCREEN
    // ==========================================

    if (raid.mode == RaidMode.RESULT)
    {
        step_raid_result();
        return;
    }

    // ==========================================
    // ACTIVE PHYSICAL RAID
    // ==========================================

    if (!raid.active)
        return;

    if (raid.room_exiting)
    {
        raid_player_y = max(
            raid_player_y - raid_player_entry_speed,
            raid_player_exit_target_y
        );
        raid_player_moving = true;
        raid_player_anim_frame += raid_player_anim_speed;
        step_raid_camera();

        if (raid_player_y <= raid_player_exit_target_y)
        {
            raid_player_y = raid_player_exit_target_y;
            raid.room_exiting = false;
            raid_player_moving = false;
            raid_player_was_moving = false;
            raid_player_anim_frame = 0;

            if (raid.current_room_type == RaidRoomType.CHECKPOINT)
            {
                raid.rooms_in_section = 0;
                raid.section++;
                raid.extract_active = false;
            }

            raid.room_number++;
            raid_enter_normal_room(raid_player_exit_reward_type);
        }

        return;
    }

    if (raid.room_entering)
    {
        raid_player_y = max(
            raid_player_y - raid_player_entry_speed,
            raid_player_entry_target_y
        );
        raid_player_anim_frame += raid_player_anim_speed;
        step_raid_camera();

        if (raid_player_y <= raid_player_entry_target_y)
        {
            raid_player_y = raid_player_entry_target_y;
            raid.room_entering = false;
            raid_player_moving = false;
            raid_player_was_moving = false;
            raid_player_anim_frame = 0;
        }

        return;
    }

    if (raid.paused)
    {
        if (keyboard_check_pressed(vk_escape))
        {
            audio_play_sound(snd_interact, 0, false);
            raid.paused = false;
            return;
        }

        if (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(ord("S")))
        {
            raid.pause_menu_index = 1 - raid.pause_menu_index;
            scroll_sound();
        }

        if (keyboard_check_pressed(vk_enter))
        {
            audio_play_sound(snd_interact, 0, false);

            if (raid.pause_menu_index == 0)
            {
                raid.paused = false;
                raid_combat_loss();
            }
            else
            {
                raid.paused = false;
            }
        }

        return;
    }

    if (keyboard_check_pressed(vk_escape))
    {
        audio_play_sound(snd_interact, 0, false);
        raid.paused = true;
        raid.pause_menu_index = 1;
        return;
    }

    if (raid_gun_tuning_active)
    {
        step_raid_gun_tuning();
        step_raid_camera();
        return;
    }

    step_raid_player();
	step_raid_player_damage();
	
    step_raid_shooting();
	
    step_raid_bullets();
    step_raid_enemy_bullets();
    step_raid_ring_hazards();

  
    step_raid_enemies();
	step_raid_enemy_death_effects();
	step_raid_lootables();
	step_raid_ground_items();
	
	step_raid_doors();
	step_raid_extract();
	
	step_raid_camera();

    if (array_length(raid_enemies) <= 0)
    {
        raid.room_cleared = true;
    }

    // Open loadout while inside raid
    if (keyboard_check_pressed(ord("U")))
    {
        overlay_mode = OverlayMode.LOADOUT;
    }
}
