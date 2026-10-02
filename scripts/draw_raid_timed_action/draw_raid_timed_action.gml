function draw_raid_timed_action()
{
    var action =
        raid.pending_action;


    terminal_panel(
        400,
        270,
        1120,
        500,
        action.label
    );


    var progress =
        raid.action_timer
        / raid.action_duration;


    progress =
        clamp(
            progress,
            0,
            1
        );


    var bar_x =
        520;

    var bar_y =
        480;

    var bar_width =
        880;

    var bar_height =
        40;


    draw_rectangle(
        bar_x,
        bar_y,
        bar_x + bar_width,
        bar_y + bar_height,
        true
    );


    draw_rectangle(
        bar_x,
        bar_y,
        bar_x
        + (bar_width * progress),
        bar_y + bar_height,
        false
    );


    draw_text(
        900,
        550,
        string(
            floor(progress * 100)
        )
        + "%"
    );


    if (
        variable_struct_exists(
            action,
            "noise"
        )
    )
    {
        draw_text(
            760,
            620,
            "NOISE: +"
            + string(action.noise)
        );
    }
}