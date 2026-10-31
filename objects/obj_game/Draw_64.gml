draw_set_font(fnt_terminal);
draw_set_color(global.ui_text_color);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
terminal_panel_scanlines_begin();

var _menu_background_visible = state == GameState.MAIN_MENU || state == GameState.HIDEOUT;
if (_menu_background_visible)
    draw_sprite_stretched_ext(background_overlay, 0, 0, 0, display_get_gui_width(), display_get_gui_height(),
        state == GameState.HIDEOUT ? make_color_rgb(28, 52, 40) : make_color_rgb(45, 45, 45), 1);

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
			draw_quest_tracker();
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

			if (
				is_struct(_boss)
				&& (!variable_struct_exists(_boss, "boss_intro_active") || !_boss.boss_intro_active)
			)
				draw_boss_healthbar(_boss);
		}

		if (raid.state == RaidState.PAUSED)
		{
			draw_raid_pause_menu();
		}

		draw_raid_player_death_screen();
	break;
}

terminal_panel_scanlines_draw();
 //==============================
 //GLOBAL EVENT LOG
 //==============================

if (state != GameState.MAIN_MENU)
{
   // draw_event_log();
}

draw_overlay(overlay_mode);
terminal_panel_scanlines_draw();

if (!(state == GameState.RAID && raid.state == RaidState.DEATH)) skill_notifications_draw();
if (!(state == GameState.RAID && raid.state == RaidState.DEATH)) quest_notifications_draw();
if (state == GameState.HIDEOUT || state == GameState.RAID) tutorial_callout_draw();

draw_raid_texture_crop_debug();
draw_debug_console();
terminal_panel_scanlines_draw();
// Debug console always on top

if (debug_show_mouse)
{
    draw_set_font(fnt_terminal_small);

    draw_text(
        20,
        20,
        "X: "
        + string(round(mouse_x))
        + "  Y: "
        + string(round(mouse_y))
    );
	
    draw_set_font(fnt_terminal);
}
