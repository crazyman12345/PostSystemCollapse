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

		if (raid.paused)
		{
			var gui_width = display_get_gui_width();
			var gui_height = display_get_gui_height();
			var panel_left = gui_width * 0.25;
			var panel_top = gui_height * 0.3;
			var panel_right = gui_width * 0.75;
			var panel_bottom = gui_height * 0.7;

			draw_set_color(c_black);
			draw_set_alpha(0.75);
			draw_rectangle(0, 0, gui_width, gui_height, false);
			draw_set_alpha(1);

			draw_set_color(c_black);
			draw_rectangle(panel_left, panel_top, panel_right, panel_bottom, false);
			draw_set_color(c_lime);
			draw_rectangle(panel_left, panel_top, panel_right, panel_bottom, true);
			draw_set_halign(fa_center);
			draw_text(gui_width * 0.5, gui_height * 0.38, "PAUSED");

			if (raid.pause_menu_index == 0)
			{
				draw_text(gui_width * 0.5, gui_height * 0.48, "> LEAVE RAID (LOSE ALL GEAR) <");
				draw_text(gui_width * 0.5, gui_height * 0.54, "CONTINUE");
			}
			else
			{
				draw_text(gui_width * 0.5, gui_height * 0.48, "LEAVE RAID (LOSE ALL GEAR)");
				draw_text(gui_width * 0.5, gui_height * 0.54, "> CONTINUE <");
			}

			draw_text(gui_width * 0.5, gui_height * 0.63, "W/S: SELECT    ENTER: CONFIRM    ESC: CONTINUE");
			draw_set_halign(fa_left);
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
