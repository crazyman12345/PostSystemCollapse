function draw_skills_overlay()
{
    var gui_w =
        display_get_gui_width();

    var gui_h =
        display_get_gui_height();


    // ------------------------------------------
    // PANEL BOUNDS
    // ------------------------------------------

    var panel_w = 1000;

    var x1 =
        gui_w - panel_w - 30;

    var y1 = 40;

    var x2 =
        gui_w - 30;

    var y2 =
        gui_h - 40;


    draw_set_font(
        fnt_terminal_small
    );
	

    // ------------------------------------------
    // OUTER BOX
    // ------------------------------------------
	draw_set_color(c_black);
	draw_rectangle(x1,y1,x2,y2,false);
	draw_set_color(c_lime);
    draw_ascii_rectangle(
        x1,
        y1,
        x2,
        y2
    );


    // ------------------------------------------
    // TITLE
    // ------------------------------------------

    draw_text(
        x1 + 30,
        y1 + 25,
        "PLAYER SKILLS"
    );


    draw_text(
        x1 + 30,
        y1 + 55,
        "--------------------------------------------------"
    );


    // ------------------------------------------
    // SKILL LIST
    // ------------------------------------------

    var list_y =
        y1 + 100;

    var row_h = 38;


    for (
        var i = 0;
        i < array_length(player_skill_keys);
        i++
    )
    {
        var skill_key =
            player_skill_keys[i];

        var skill_def =
            skill_db_get(skill_key);

        var progress =
            variable_struct_get(
                player_skills,
                skill_key
            );


        var prefix = "  ";

        if (i == skills_index)
        {
            prefix = "> ";
        }


        draw_text(
            x1 + 35,
            list_y,
            prefix
            + skill_def.name
        );


        draw_text(
            x2 - 115,
            list_y,
            "LV. "
            + string(progress.level)
        );


        list_y += row_h;
    }


    // ------------------------------------------
    // DIVIDER
    // ------------------------------------------

    var info_y =
        y1 + 600;


    draw_text(
        x1 + 30,
        info_y,
        "--------------------------------------------------"
    );


    // ------------------------------------------
    // SELECTED SKILL
    // ------------------------------------------

    var selected_key =
        player_skill_keys[
            skills_index
        ];

    var selected_def =
        skill_db_get(
            selected_key
        );

    var selected_progress =
        variable_struct_get(
            player_skills,
            selected_key
        );


    var xp_required =
        skill_xp_required(
            selected_progress.level
        );


    draw_text(
        x1 + 35,
        info_y + 45,
        selected_def.name
    );


    draw_text(
        x1 + 35,
        info_y + 90,
        "XP: "
        + string(
            selected_progress.xp
        )
        + " / "
        + string(
            xp_required
        )
    );


    // ------------------------------------------
    // XP BAR
    // ------------------------------------------

    var bar_width = 30;

    var progress_percent =
        selected_progress.xp
        / xp_required;

    progress_percent =
        clamp(
            progress_percent,
            0,
            1
        );


    var filled =
        floor(
            bar_width
            * progress_percent
        );


    var bar = "[";


    for (
        var b = 0;
        b < bar_width;
        b++
    )
    {
        if (b < filled)
        {
            bar += "#";
        }
        else
        {
            bar += "-";
        }
    }


    bar += "]";


    draw_text(
        x1 + 35,
        info_y + 130,
        bar
    );


    // ------------------------------------------
    // DESCRIPTION
    // ------------------------------------------

    draw_text_ext(
        x1 + 35,
        info_y + 185,
        selected_def.description,
        28,
        panel_w - 70
    );


    // ------------------------------------------
    // CONTROLS
    // ------------------------------------------

    draw_text(
        x1 + 30,
        y2 - 165,
        "--------------------------------------------------"
    );


    draw_text(
        x1 + 35,
        y2 - 100,
        "[W/S] SELECT"
    );


    draw_text(
        x1 + 275,
        y2 - 100,
        "[K] CLOSE"
    );
}