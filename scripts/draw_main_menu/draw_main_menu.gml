function draw_main_menu()
{
    var _gui_width = display_get_gui_width();
    var _gui_height = display_get_gui_height();

    if (main_menu_credits_open)
    {
        terminal_header("TERMINAL // CREDITS");
        terminal_panel(240, 220, 1440, 500, "CREDITS");

        draw_set_font(fnt_terminal_tiny);
        draw_set_color(global.ui_text_color);
        draw_text_ext(320, 320, "\"RECYCLER / SHREDDER - ChaosWeld\" (https://skfb.ly/pxyqq) by ChaosWeld is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).", 34, 1280);
        draw_text_ext(320, 410, "\"Workbench\" (https://sketchfab.com/3d-models/workbench-9903d3f3a9c94c478cca7eee8ba9e6ab) by Heroinfather is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).", 34, 1280);
        draw_text_ext(320, 500, "\"Autopsy Lab - Assets\" (https://sketchfab.com/3d-models/autopsy-lab-assets-5ceaaa4482a84774b9922366cfb228e7) by Evan Petrov is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).", 34, 1280);
        draw_text_ext(320, 590, "\"Chemistry Drug Lab\" (https://sketchfab.com/3d-models/chemistry-drug-lab-1864ec8ab4704653b27e2ebf37ee75d6) by KendeMrena is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).", 34, 1280);
        draw_text_ext(320, 680, "\"Workbench\" (https://sketchfab.com/3d-models/workbench-445cdf5f8951457684e5550b6c590142) by chaschinkaa is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).", 34, 1280);

        var _back_hovered = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _gui_width - 180, _gui_height - 80, _gui_width - 20, _gui_height - 20);
        terminal_menu_item(_gui_width - 180, _gui_height - 70, "BACK", _back_hovered);
        return;
    }

    if (save_new_game_setup)
    {
        terminal_header("TERMINAL // NEW PLAYER");
        terminal_panel(620, 340, 680, 500, "WHAT IS YOUR NAME?");

        draw_set_font(fnt_terminal_tiny);
        draw_set_color(global.ui_text_color);
        draw_text(760, 500, "PLAYER NAME");
        draw_set_color(global.ui_text_color);
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

    var _credits_hovered = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _gui_width - 280, _gui_height - 80, _gui_width - 20, _gui_height - 20);
    terminal_menu_item(_gui_width - 260, _gui_height - 70, "CREDITS", _credits_hovered);

    if (save_new_game_confirm)
    {
        draw_set_color(c_black);
        draw_rectangle(660, 500, 1260, 800, false);
        draw_set_color(global.ui_text_color);
        terminal_panel(520, 450, 880, 370, "OVERWRITE PLAYER SAVE?");
        draw_set_halign(fa_center);
        draw_text(960, 575, "Existing progress will be replaced.");
        draw_set_halign(fa_left);
        terminal_menu_item(760, 650, "YES - NEW GAME", save_new_game_confirm_index == 0);
        terminal_menu_item(760, 710, "NO - KEEP SAVE", save_new_game_confirm_index == 1);
    }
}
