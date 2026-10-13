function draw_main_menu()
{
    terminal_header("TERMINAL // NODE 01");
	draw_post_collapse_network(520,260);
    terminal_panel(520, 400, 880, 420, "POST-COLLAPSE NETWORK");

    terminal_menu_item(760, 600, "ENTER NETWORK", menu_index == 0);
    terminal_menu_item(760, 660, "EXIT", menu_index == 1);

    terminal_prompt(
        "W/S: SELECT    ENTER: CONFIRM    F11: FULLSCREEN"
    );
}
