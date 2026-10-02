function draw_raid_location_select()
{
    // ========================================================
    // BACKGROUND
    // ========================================================

    draw_set_color(c_black);

    draw_rectangle(
        0,
        0,
        1920,
        1080,
        false
    );

    draw_set_color(c_lime);


    // ========================================================
    // HEADER
    // ========================================================

    terminal_header(
        "RAID // SELECT LOCATION"
    );


    // ========================================================
    // GET LOCATION KEYS
    // ========================================================

    var location_keys =
        raid_location_get_all_keys();

    var location_count =
        array_length(location_keys);


    // ========================================================
    // LEFT PANEL
    // ========================================================

    terminal_panel(
        60,
        160,
        700,
        760,
        "LOCATIONS"
    );


    draw_set_font(
        fnt_terminal_small
    );


    if (location_count <= 0)
    {
        draw_text(
            110,
            240,
            "NO RAID LOCATIONS AVAILABLE"
        );

        draw_set_font(
            fnt_terminal
        );

        return;
    }


    // ========================================================
    // DRAW LOCATION LIST
    // ========================================================

    for (
        var i = 0;
        i < location_count;
        i++
    )
    {
        var location_key =
            location_keys[i];

        var location =
            raid_location_get(
                location_key
            );


        var location_text =
            location.name;


        // ----------------------------------------------------
        // LOCKED?
        // ----------------------------------------------------

        if (
            location.danger_level
            > global.progress.danger_level
        )
        {
            location_text +=
                "  [LOCKED]";
        }


        terminal_menu_item(
            110,
            240 + (i * 48),
            location_text,
            menu_index == i
        );
    }


    // ========================================================
    // SELECTED LOCATION
    // ========================================================

    menu_index =
        clamp(
            menu_index,
            0,
            location_count - 1
        );


    var selected_key =
        location_keys[
            menu_index
        ];

    var selected_location =
        raid_location_get(
            selected_key
        );


    // ========================================================
    // RIGHT PANEL
    // ========================================================

    terminal_panel(
        800,
        160,
        1060,
        760,
        selected_location.name
    );


    var info_x = 860;
    var info_y = 240;


    // ========================================================
    // DANGER LEVEL
    // ========================================================

    draw_text(
        info_x,
        info_y,
        "DANGER LEVEL: "
        + string(
            selected_location.danger_level
        )
    );


    // ========================================================
    // ACCESS STATUS
    // ========================================================

    var location_unlocked =
        selected_location.danger_level
        <= global.progress.danger_level;


    draw_text(
        info_x,
        info_y + 55,

        "STATUS: "
        + (
            location_unlocked
            ? "AVAILABLE"
            : "LOCKED"
        )
    );


    // ========================================================
    // DESCRIPTION
    // ========================================================

    draw_text(
        info_x,
        info_y + 140,
        "DESCRIPTION"
    );


    draw_text_ext(
        info_x,
        info_y + 190,
        selected_location.description,
        30,
        900
    );


    // ========================================================
    // OPTIONAL LOCATION INFORMATION
    // ========================================================

    if (
        variable_struct_exists(
            selected_location,
            "recommended_level"
        )
    )
    {
        draw_text(
            info_x,
            info_y + 380,

            "RECOMMENDED LEVEL: "
            + string(
                selected_location.recommended_level
            )
        );
    }


    if (
        variable_struct_exists(
            selected_location,
            "expected_threat"
        )
    )
    {
        draw_text(
            info_x,
            info_y + 430,

            "EXPECTED THREAT: "
            + selected_location.expected_threat
        );
    }


    // ========================================================
    // LOCK MESSAGE
    // ========================================================

    if (!location_unlocked)
    {
        draw_text(
            info_x,
            info_y + 540,

            "REQUIRES DANGER LEVEL "
            + string(
                selected_location.danger_level
            )
        );
    }


    draw_set_font(
        fnt_terminal
    );


    // ========================================================
    // CONTROLS
    // ========================================================

    if (location_unlocked)
    {
        terminal_prompt(
            "W/S: SELECT    ENTER: START RAID    ESC: BACK"
        );
    }
    else
    {
        terminal_prompt(
            "W/S: SELECT    ESC: BACK"
        );
    }
}