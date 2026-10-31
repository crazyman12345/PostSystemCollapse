function draw_trader_info_panel(_trader_key)
{
    var trader =
        trader_get(_trader_key);


    // ==============================
    // PANEL LAYOUT
    // ==============================

    var panel_left = 80;
    var panel_top = 180;
    var panel_width = 520;
    var panel_height = 600;

    var portrait_left = panel_left + 40;
    var portrait_top = panel_top + 70;
    var portrait_width = 220;
    var portrait_height = 260;

	draw_set_font(fnt_terminal_small);
    // ==============================
    // MAIN PANEL
    // ==============================

    terminal_panel(
        panel_left,
        panel_top,
        panel_width,
        panel_height,
        "TRADER"
    );


    // ==============================
    // PORTRAIT BOX
    // ==============================

    if (trader.portrait != -1)
    {
        draw_chamfered_sprite(
            trader.portrait,
            0,

            portrait_left + 3,
            portrait_top + 3,

            portrait_width - 6,
            portrait_height - 6,
            9,
            merge_color(c_white, global.hideout_secondary_color, 0.5),
            1
        );
    }
    else
    {
        draw_set_halign(fa_center);

        draw_text(
            portrait_left + (portrait_width / 2),
            portrait_top + 110,
            "[ NO IMAGE ]"
        );

        draw_set_halign(fa_left);
    }
    draw_set_color(global.ui_text_color);
    terminal_box(portrait_left, portrait_top, portrait_width, portrait_height);


    // ==============================
    // NAME / ROLE
    // ==============================

	var info_left =
	    portrait_left + portrait_width + 30;

	draw_text(
	    info_left,
	    panel_top + 100,
	    trader.name
	);

	draw_text(
	    info_left,
	    panel_top + 150,
	    trader.title
	);

    // ==============================
    // DESCRIPTION
    // ==============================

    terminal_panel(
        panel_left + 40,
        panel_top + 330,
        panel_width - 80,
        190,
        "DESCRIPTION"
    );

    draw_text_ext(
        panel_left + 65,
        panel_top + 380,

        trader.description,

        24,
        panel_width - 130
    );


    // ==============================
    // PLAYER CASH
    // ==============================

    terminal_value(
        panel_left + 40,
        panel_top + 550,
        "CASH",
        "$" + string(get_cash()),
        180
    );
	draw_set_font(fnt_terminal);
}
