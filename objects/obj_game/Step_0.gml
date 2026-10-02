if (keyboard_check_pressed(vk_f11)) {
    window_set_fullscreen(!window_get_fullscreen());
}
var dt = delta_time / 1000000;
//Persistent Simulations
morrowleaf_update(dt);

step_debug_terminal();
if debug_console_open exit;
	

step_handle_shortcuts();

if (overlay_mode != OverlayMode.NONE)
{
    step_overlay();
    exit;
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

