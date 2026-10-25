function draw_main_menu()
{
    var _gui_width = display_get_gui_width();

    if (save_new_game_setup)
    {
        terminal_header("TERMINAL // NEW PLAYER");
        terminal_panel(620, 340, 680, 500, "WHAT IS YOUR NAME?");

        draw_set_font(fnt_terminal_tiny);
        draw_set_color(c_green);
        draw_text(760, 500, "PLAYER NAME");
        draw_set_color(c_lime);
        draw_rectangle(760, 530, 1160, 590, true);
        draw_text(780, 547, save_new_game_name + (((current_time div 500) mod 2 == 0) ? "_" : ""));

        draw_rectangle(760, 635, 790, 665, true);
        if (save_new_game_skip_intro)
        {
            draw_line(765, 650, 773, 659);
            draw_line(773, 659, 786, 640);
        }
        draw_text(810, 640, "SKIP INTRO");
        terminal_menu_item(760, 710, "BEGIN", false);
        return;
    }

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
        terminal_panel(520, 450, 880, 370, "OVERWRITE PLAYER SAVE?");
        draw_set_halign(fa_center);
        draw_text(960, 575, "Existing progress will be replaced.");
        draw_set_halign(fa_left);
        terminal_menu_item(760, 650, "YES - NEW GAME", save_new_game_confirm_index == 0);
        terminal_menu_item(760, 710, "NO - KEEP SAVE", save_new_game_confirm_index == 1);
    }
}
