function step_main_menu(){
	var options = 2;
        menu_index = terminal_menu_input(menu_index, options);
        var mouse_menu = terminal_menu_mouse_input(menu_index, options, 0, 760, 600, 500, 60);
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
            if (menu_index == 0) {
                state = GameState.HIDEOUT;
				audio_play_sound(snd_level_up,0,false);
            }
            if (menu_index == 1) {
                game_end();
            }
        }
}
