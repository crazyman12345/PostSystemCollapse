function draw_event_log()
{
    var log_left = 80;
    var log_top = 900;
    var log_width = 1760;
    var log_height = 100;

    // Background
    draw_set_color(c_black);
	draw_set_font(fnt_terminal_small);
    draw_rectangle(
        log_left,
        log_top,
        log_left + log_width,
        log_top + log_height,
        false
    );

    draw_set_color(c_lime);

    // Border
    terminal_panel(
        log_left,
        log_top,
        log_width,
        log_height,
        "EVENT LOG"
    );

    var line_x = log_left + 40;
    var line_y = log_top + 35;
    var line_spacing = 24;

    for (var i = 0; i < array_length(event_log); i++)
    {
        draw_text(
            line_x,
            line_y + (i * line_spacing),
            "> " + event_log[i]
        );
    }
	draw_set_font(fnt_terminal);
}