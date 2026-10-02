function draw_debug_console()
{
    if (!debug_console_open)
    {
        return;
    }

    var console_left = 0;
    var console_top = 0;

    var console_width = 1920;
    var console_height = 400;

    var output_x = console_left + 50;
    var output_y = console_top + 70;

    var line_spacing = 30;


    // ==============================
    // BACKGROUND
    // ==============================

    draw_set_color(c_black);

    draw_rectangle(
        console_left,
        console_top,
        console_left + console_width,
        console_top + console_height,
        false
    );

    draw_set_color(c_lime);


    // ==============================
    // PANEL
    // ==============================

    terminal_panel(
        console_left,
        console_top,
        console_width,
        console_height,
        "DEBUG TERMINAL"
    );


    // ==============================
    // OUTPUT HISTORY
    // ==============================

    for (
        var i = 0;
        i < array_length(debug_log);
        i++
    )
    {
        draw_text(
            output_x,
            output_y + (i * line_spacing),
            debug_log[i]
        );
    }


    // ==============================
    // COMMAND INPUT
    // ==============================

    draw_text(
        console_left + 50,
        console_top + console_height - 100,
        "> " + debug_input + "_"
    );


    // ==============================
    // CONTROLS
    // ==============================

    draw_text(
        console_left + 50,
        console_top + console_height - 50,
        "ENTER: EXECUTE    ESC/F1: CLOSE"
    );
}