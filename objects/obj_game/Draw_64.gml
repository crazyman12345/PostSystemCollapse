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
		if (raid_gun_tuning_active && raid.state != RaidState.INACTIVE && raid.state != RaidState.RESULT && raid.state != RaidState.DEATH)
		{
			draw_raid_gun_tuning_panel();
		}
		if ((raid.state == RaidState.COMBAT || raid.state == RaidState.EXITING) && overlay_mode == OverlayMode.NONE)
		{
			draw_raid_hotbar(false);
		}
		if (raid.state == RaidState.RESULT)
		{
		    draw_raid_result();
		}
			
		if (raid.state != RaidState.RESULT && raid.state != RaidState.DEATH)
		{
			draw_raid_ammo_ui();
			draw_raid_health_ui();
			draw_raid_progress();
		}

		if (raid.state != RaidState.INACTIVE && raid.state != RaidState.RESULT && raid.state != RaidState.DEATH)
		{
			var _boss = undefined;
			for (var _boss_i = 0; _boss_i < array_length(raid_enemies); _boss_i++)
			{
				if (raid_enemies[_boss_i].enemy_boss)
				{
					_boss = raid_enemies[_boss_i];
					break;
				}
			}

			if (is_struct(_boss))
				draw_boss_healthbar(_boss);
		}

		if (raid.state == RaidState.PAUSED)
		{
			draw_raid_pause_menu();
		}

		draw_raid_player_death_screen();
	break;
}
 //==============================
 //GLOBAL EVENT LOG
 //==============================

if (state != GameState.MAIN_MENU)
{
   // draw_event_log();
}

draw_overlay(overlay_mode);

if (!(state == GameState.RAID && raid.state == RaidState.DEATH)) skill_notifications_draw();

draw_debug_console();
// Debug console always on top

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
