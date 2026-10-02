draw_set_font(fnt_terminal);
draw_set_color(c_lime);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

switch (state)
{
    case GameState.MAIN_MENU:
        draw_main_menu();
    break;

    case GameState.HIDEOUT:
        draw_hideout();
    break;
		
	case GameState.RAID:
		if (raid.mode == RaidMode.RESULT)
		{
		    draw_raid_result();
		}
			
		if (raid.mode == RaidMode.START)
		{
			draw_raid_ammo_ui();
			draw_raid_health_ui();
		}
	break;
}
// ==============================
// GLOBAL EVENT LOG
// ==============================

//if (state != GameState.MAIN_MENU)
//{
//    draw_event_log();
//}

draw_overlay(overlay_mode);

// Debug console always on top
draw_debug_console();

if (debug_show_mouse)
{
    var mouse_gui_x = device_mouse_x_to_gui(0);
    var mouse_gui_y = device_mouse_y_to_gui(0);

    draw_set_font(fnt_terminal_small);

    draw_text(
        20,
        20,
        "X: "
        + string(round(mouse_gui_x))
        + "  Y: "
        + string(round(mouse_gui_y))
    );
	
    draw_set_font(fnt_terminal);
}