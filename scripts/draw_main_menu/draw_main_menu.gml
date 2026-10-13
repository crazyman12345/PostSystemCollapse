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

    terminal_menu_item(760, 600, "ENTER NETWORK", menu_index == 0);
    terminal_menu_item(760, 660, "EXIT", menu_index == 1);

    terminal_prompt(
        "W/S: SELECT    ENTER: CONFIRM    F11: FULLSCREEN"
    );
}
