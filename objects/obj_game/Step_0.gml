frame_scale = (delta_time / 1000000) * 60;
save_update();

skill_notifications_update();
quest_notifications_update();
quest_tracker_update();

// GameMaker may ignore window changes made immediately after leaving fullscreen.
step_fullscreen_restore();
if (keyboard_check_pressed(vk_f11)) {
  toggle_fullscreen();
}
if (state != GameState.RAID)
{
    step_debug_terminal();
    if (debug_console_open) exit;

    if (state == GameState.HIDEOUT && progress_get_flag("starting_crate_claimed")) step_handle_shortcuts();

    if (overlay_mode != OverlayMode.NONE)
    {
        step_overlay();
        exit;
    }
}

switch (state) {
	case GameState.MAIN_MENU: {
	    step_main_menu();
	    break;
	}
	case GameState.HIDEOUT: {
	    step_hideout();
	    break;
	}
	case GameState.RAID:{
		step_raid();
		break;
	}
}
