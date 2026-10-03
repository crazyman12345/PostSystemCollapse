function step_main_menu(){
	var options = 2;
        menu_index = terminal_menu_input(menu_index, options);
        // Enter = Select
        if (keyboard_check_pressed(vk_enter)) {
            if (menu_index == 0) {
                state = GameState.HIDEOUT;
				audio_play_sound(snd_level_up,0,false);
            }
            if (menu_index == 1) {
                game_end();
            }
        }
}