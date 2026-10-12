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
            raid_player_y - raid_player_entry_speed * frame_scale,
            raid_player_exit_target_y
        );
        raid_player_moving = true;
        raid_player_anim_frame += raid_player_anim_speed * frame_scale;
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
            raid_player_y - raid_player_entry_speed * frame_scale,
            raid_player_entry_target_y
        );
        raid_player_anim_frame += raid_player_anim_speed * frame_scale;
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
        var _fps_options = [60, 120, 144, 165, 240];
        var _gui_width = display_get_gui_width();
        var _gui_height = display_get_gui_height();
        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);
        var _hover_index = -1;

        if (_mouse_x >= _gui_width * 0.25 && _mouse_x <= _gui_width * 0.75)
        {
            if (_mouse_y >= _gui_height * 0.44 && _mouse_y < _gui_height * 0.50) _hover_index = 0;
            else if (_mouse_y >= _gui_height * 0.50 && _mouse_y < _gui_height * 0.56) _hover_index = 1;
            else if (_mouse_y >= _gui_height * 0.56 && _mouse_y < _gui_height * 0.62) _hover_index = 2;
        }

        if (_hover_index != -1 && raid.pause_menu_index != _hover_index)
        {
            raid.pause_menu_index = _hover_index;
            scroll_sound();
        }

        if (keyboard_check_pressed(vk_escape))
        {
            audio_play_sound(snd_interact, 0, false);
            raid.paused = false;
            return;
        }

        var _menu_move = keyboard_check_pressed(ord("S")) - keyboard_check_pressed(ord("W"));
        if (_menu_move != 0)
        {
            raid.pause_menu_index += _menu_move;
            if (raid.pause_menu_index < 0) raid.pause_menu_index = 2;
            if (raid.pause_menu_index > 2) raid.pause_menu_index = 0;
            scroll_sound();
        }

        var _fps_change = (keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right))
            - (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left));
        var _mouse_clicked = mouse_check_button_pressed(mb_left);
        if (_mouse_clicked && raid.pause_menu_index == 1)
        {
            var _fps_y = _gui_height * 0.52;
            if (point_in_rectangle(_mouse_x, _mouse_y, _gui_width * 0.5 - 57, _fps_y - 8, _gui_width * 0.5 - 13, _fps_y + 32)) _fps_change = -1;
            if (point_in_rectangle(_mouse_x, _mouse_y, _gui_width * 0.5 + 13, _fps_y - 8, _gui_width * 0.5 + 57, _fps_y + 32)) _fps_change = 1;
        }
        if (raid.pause_menu_index == 1 && _fps_change != 0)
        {
            raid.pause_fps_index += _fps_change;
            if (raid.pause_fps_index < 0) raid.pause_fps_index = array_length(_fps_options) - 1;
            if (raid.pause_fps_index >= array_length(_fps_options)) raid.pause_fps_index = 0;
            game_set_speed(_fps_options[raid.pause_fps_index], gamespeed_fps);
            scroll_sound();
        }

        var _keyboard_confirm = keyboard_check_pressed(vk_enter);
        var _mouse_confirm = _mouse_clicked && _hover_index != -1 && _hover_index != 1;
        if (_keyboard_confirm || _mouse_confirm)
        {
            audio_play_sound(snd_interact, 0, false);

            if (raid.pause_menu_index == 0)
            {
                raid.paused = false;
                raid_combat_loss();
            }
            else if (raid.pause_menu_index == 1 && _keyboard_confirm)
            {
                raid.pause_fps_index = (raid.pause_fps_index + 1) mod array_length(_fps_options);
                game_set_speed(_fps_options[raid.pause_fps_index], gamespeed_fps);
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
        raid.pause_menu_index = 2;
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
    if (!raid.active) return;

    step_raid_ring_hazards();
    if (!raid.active) return;

  
    step_raid_enemies();
	if (!raid.active) return;

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
