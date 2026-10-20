function draw_main_menu()
{
    var _gui_width = display_get_gui_width();

    terminal_header("TERMINAL // NODE 01");
	draw_post_collapse_network(520,260);
    terminal_panel(520, 400, 880, 420, "POST-COLLAPSE NETWORK");

    draw_set_font(fnt_terminal_tiny);
    draw_text(_gui_width - 166, 42, "MUTE MUSIC");
    draw_rectangle(_gui_width - 40, 38, _gui_width - 20, 58, true);
    if (music_volume == 0)
    {
        draw_line(_gui_width - 37, 48, _gui_width - 32, 55);
        draw_line(_gui_width - 32, 55, _gui_width - 23, 41);
    }
    draw_set_font(fnt_terminal);

    if (save_continue_available)
    {
        terminal_menu_item(760, 570, "CONTINUE", menu_index == 0);
        terminal_menu_item(760, 630, "NEW GAME", menu_index == 1);
        terminal_menu_item(760, 690, "EXIT", menu_index == 2);
    }
    else
    {
        terminal_menu_item(760, 570, "NEW GAME", menu_index == 0);
        terminal_menu_item(760, 630, "EXIT", menu_index == 1);
    }

    if (save_new_game_confirm)
    {
        draw_set_color(c_black);
        draw_rectangle(660, 500, 1260, 800, false);
        draw_set_color(c_lime);
        terminal_panel(660, 500, 600, 300, "OVERWRITE PLAYER SAVE?");
        draw_set_halign(fa_center);
        draw_text(960, 575, "Existing progress will be replaced.");
        draw_set_halign(fa_left);
        terminal_menu_item(760, 650, "YES - NEW GAME", save_new_game_confirm_index == 0);
        terminal_menu_item(760, 710, "NO - KEEP SAVE", save_new_game_confirm_index == 1);
    }
}
