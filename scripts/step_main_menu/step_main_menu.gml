function step_main_menu(){
	if (main_menu_credits_open)
    {
        var _credits_mouse_x = device_mouse_x_to_gui(0);
        var _credits_mouse_y = device_mouse_y_to_gui(0);
        var _back_clicked = mouse_check_button_pressed(mb_left)
            && point_in_rectangle(_credits_mouse_x, _credits_mouse_y, display_get_gui_width() - 180, display_get_gui_height() - 80, display_get_gui_width() - 20, display_get_gui_height() - 20);

        if (keyboard_check_pressed(vk_escape) || _back_clicked) main_menu_credits_open = false;
        return;
    }

	if (save_new_game_setup)
    {
        var mouse_x_gui = device_mouse_x_to_gui(0);
        var mouse_y_gui = device_mouse_y_to_gui(0);
        var clicked = mouse_check_button_pressed(mb_left);

        if (keyboard_check_pressed(vk_escape))
        {
            keyboard_string = save_new_game_keyboard_restore;
            save_new_game_setup = false;
            return;
        }

        if (clicked && point_in_rectangle(mouse_x_gui, mouse_y_gui, 760, 530, 1160, 590))
            keyboard_string = save_new_game_name;
        if (clicked && point_in_rectangle(mouse_x_gui, mouse_y_gui, 760, 625, 1160, 675))
            save_new_game_skip_intro = !save_new_game_skip_intro;

        save_new_game_name = string_copy(keyboard_string, 1, 20);
        var begin_clicked = clicked && point_in_rectangle(mouse_x_gui, mouse_y_gui, 760, 710, 1160, 770);
        if (keyboard_check_pressed(vk_enter) || begin_clicked)
        {
            var player_name = string_trim(save_new_game_name);
            if (string_length(player_name) > 0 && save_begin_new_game(player_name, save_new_game_skip_intro))
            {
                keyboard_string = save_new_game_keyboard_restore;
                save_new_game_setup = false;
                audio_play_sound(snd_level_up, 0, false);
            }
        }
        return;
    }

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
                save_new_game_setup = true;
                save_new_game_name = "";
                save_new_game_skip_intro = false;
                save_new_game_keyboard_restore = keyboard_string;
                keyboard_string = "";
            }
            else
            {
                save_new_game_confirm = false;
                save_new_game_confirm_index = 1;
            }
        }
        return;
    }

	var options = save_continue_available ? 4 : 3;
        menu_index = terminal_menu_input(menu_index, options);
        var mouse_menu = terminal_menu_mouse_input(menu_index, options, 0, 80, 600, 400, 60);
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
            var selected_exit = menu_index == (save_continue_available ? 2 : 1);
            var selected_credits = menu_index == options - 1;

            if (selected_continue) {
                if (load_game()) audio_play_sound(snd_level_up, 0, false);
            }
            else if (selected_new_game) {
                if (file_exists(save_filename) || file_exists(save_backup_filename))
                {
                    save_new_game_confirm = true;
                    save_new_game_confirm_index = 1;
                }
                else
                {
                    save_new_game_setup = true;
                    save_new_game_name = "";
                    save_new_game_skip_intro = false;
                    save_new_game_keyboard_restore = keyboard_string;
                    keyboard_string = "";
                }
            }
            else if (selected_exit) {
                game_end();
            }
            else if (selected_credits) {
                main_menu_credits_open = true;
            }
        }
}
