function step_raid_result(){
	if keyboard_check_pressed(vk_enter){
		hideout_menu_index = 1;
		hideout_page = HideoutPage.STASH;
		hideout_focus = HideoutFocus.CONTENT;
		raid_set_state(RaidState.INACTIVE);
		state = GameState.HIDEOUT;
	}
}
