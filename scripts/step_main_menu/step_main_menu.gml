function step_main_menu(){
	var options = 2;
        menu_index = terminal_menu_input(menu_index, options);
        var mouse_menu = terminal_menu_mouse_input(menu_index, options, 0, 760, 600, 500, 60);
        menu_index = mouse_menu.index;
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
