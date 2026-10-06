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

if (state == GameState.RAID && raid.active && !raid.paused)
{
    raid_hotbar_validate();
    if (keyboard_check_pressed(ord("1"))) raid_hotbar_use(0);
    if (keyboard_check_pressed(ord("2"))) raid_hotbar_use(1);
    if (keyboard_check_pressed(ord("3"))) raid_hotbar_use(2);
    if (keyboard_check_pressed(ord("4"))) raid_hotbar_use(3);
    if (keyboard_check_pressed(ord("5"))) raid_hotbar_use(4);
    if (keyboard_check_pressed(ord("6"))) raid_hotbar_use(5);
    if (raid.hotbar_feedback_timer > 0) raid.hotbar_feedback_timer--;
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

