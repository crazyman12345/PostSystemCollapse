function step_main_menu(){
	if (save_new_game_confirm)
    {
        save_new_game_confirm_index = terminal_menu_input(save_new_game_confirm_index, 2);
        var confirm_mouse = terminal_menu_mouse_input(save_new_game_confirm_index, 2, 0, 760, 650, 400, 60);
        save_new_game_confirm_index = confirm_mouse.index;

        if (keyboard_check_pressed(vk_escape))
        {
            save_new_game_confirm = false;
            save_new_game_confirm_index = 1;
        }
        else if (keyboard_check_pressed(vk_enter) || confirm_mouse.confirm)
        {
            if (save_new_game_confirm_index == 0)
            {
                save_new_game_confirm = false;
                if (save_begin_new_game()) audio_play_sound(snd_level_up, 0, false);
            }
            else
            {
                save_new_game_confirm = false;
                save_new_game_confirm_index = 1;
            }
        }
        return;
    }

	var options = save_continue_available ? 3 : 2;
        menu_index = terminal_menu_input(menu_index, options);
        var mouse_menu = terminal_menu_mouse_input(menu_index, options, 0, 760, 570, 500, 60);
        menu_index = mouse_menu.index;

        var _gui_width = display_get_gui_width();
        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);
        if (mouse_check_button_pressed(mb_left)
        && point_in_rectangle(_mouse_x, _mouse_y, _gui_width - 40, 38, _gui_width - 20, 58))
        {
            music_volume = 0;
            audio_sound_gain(music_instance, 0, 0);
        }

        // Enter = Select
        if (keyboard_check_pressed(vk_enter) || mouse_menu.confirm) {
            var selected_continue = save_continue_available && menu_index == 0;
            var selected_new_game = menu_index == (save_continue_available ? 1 : 0);
            var selected_exit = menu_index == options - 1;

            if (selected_continue) {
                if (load_game()) audio_play_sound(snd_level_up, 0, false);
            }
            else if (selected_new_game) {
                if (file_exists(save_filename) || file_exists(save_backup_filename))
                {
                    save_new_game_confirm = true;
                    save_new_game_confirm_index = 1;
                }
                else if (save_begin_new_game()) audio_play_sound(snd_level_up, 0, false);
            }
            else if (selected_exit) {
                game_end();
            }
        }
}
