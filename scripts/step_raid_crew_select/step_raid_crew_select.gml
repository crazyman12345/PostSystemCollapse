function step_raid_crew_select(){
	menu_index = terminal_menu_input(menu_index, array_length(crew));
    if (keyboard_check_pressed(vk_enter)) {
        raid.crew_index = menu_index;
        state = RaidPrep.PREP;
        menu_index = 0;
    }
    if (keyboard_check_pressed(vk_escape)) {
		hideout_focus = HideoutFocus.SIDEBAR;
		menu_index = 0;
		return;
	}
}