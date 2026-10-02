function draw_crew_screen()
{
    var gui_w =
        display_get_gui_width();

    var gui_h =
        display_get_gui_height();


    draw_set_font(
        fnt_terminal
    );


    // ----------------------------------
    // MAIN PANELS
    // ----------------------------------

    draw_ascii_rectangle(
        40,
        80,
        350,
        700
    );

    draw_ascii_rectangle(
        370,
        80,
        1050,
        700
    );

    draw_ascii_rectangle(
        1070,
        80,
        gui_w - 40,
        700
    );


    draw_text(
        60,
        100,
        "CREW"
    );


    var member =
        crew[crew_screen_index];


    // ----------------------------------
    // CREW LIST
    // ----------------------------------

    var list_y = 150;

    for (
        var i = 0;
        i < array_length(crew);
        i++
    )
    {
        var prefix = "  ";

        if (i == crew_screen_index)
        {
            prefix = "> ";
        }


        draw_text(
            70,
            list_y,
            prefix + crew[i].name
        );


        list_y += 40;
    }


    // ----------------------------------
    // SELECTED CREW
    // ----------------------------------

    draw_text(
        400,
        100,
        member.name
    );


    draw_text(
        400,
        160,
        "WEAPON: "
        + string(member.weapon)
    );

    draw_text(
        400,
        200,
        "HEAD: "
        + string(member.armor_head)
    );

    draw_text(
        400,
        240,
        "CHEST: "
        + string(member.armor_chest)
    );

    draw_text(
        400,
        280,
        "BAG: "
        + string(member.bag)
    );


    // ----------------------------------
    // STATUS
    // ----------------------------------

    draw_text(
        1100,
        100,
        "STATUS"
    );


    if (
        member.status
        == CrewStatus.READY
    )
    {
        draw_text(
            1100,
            160,
            "READY"
        );
    }
    else
    {
        draw_text(
            1100,
            160,
            "CRITICALLY INJURED"
        );


        var remaining =
            max(
                0,
                member.injury_end_time
                - current_time
            );


        var seconds =
            floor(
                remaining / 1000
            );

        var minutes =
            floor(
                seconds / 60
            );

        seconds =
            seconds mod 60;


        var time_text =
            string(minutes)
            + ":"
            + string_format(
                seconds,
                2,
                0
            );


        draw_text(
            1100,
            210,
            "RECOVERY: "
            + time_text
        );


        draw_text(
            1100,
            260,
            "TREATMENT: $50"
        );


        draw_text(
            1100,
            320,
            "[R] TREAT NOW"
        );
    }


    // ----------------------------------
    // CONTROLS
    // ----------------------------------

    draw_text(
        60,
        740,
        "[W/S] SELECT CREW"
    );

    draw_text(
        60,
        780,
        "[ESC] BACK"
    );
}