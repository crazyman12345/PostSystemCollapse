function draw_raid_junction()
{
    var junction =
        raid_junction_get(
            raid.junction_key
        );


    // ========================================================
    // ROOM / AREA
    // ========================================================

    terminal_panel(
        60,
        190,
        1050,
        700,
        junction.name
    );


    draw_set_font(
        fnt_ascii
    );


    draw_raid_map(
        80,
		240,
		1080,
		750
    );

    draw_set_font(
        fnt_terminal_small
    );


    draw_text_ext(
        120,
        765,
        junction.description,
        30,
        900
    );


    // ========================================================
    // ACTIONS
    // ========================================================

    terminal_panel(
        1140,
        190,
        720,
        700,
        "ACTIONS"
    );


    var actions =
        raid_get_available_actions();


    for (
        var i = 0;
        i < array_length(actions);
        i++
    )
    {
        var action =
            actions[i];


        terminal_menu_item(
            1200,
            270 + (i * 55),
            action.label,
            raid.junction_action_index == i
        );
    }


    draw_set_font(
        fnt_terminal
    );
}