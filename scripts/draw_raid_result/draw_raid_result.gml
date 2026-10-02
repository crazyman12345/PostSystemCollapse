function draw_raid_result()
{
    terminal_panel(
        400,
        250,
        1120,
        550,
        raid.result_title
    );


    draw_set_font(
        fnt_terminal_small
    );


    draw_text_ext(
        500,
        360,
        raid.result_message,
        34,
        920
    );


    draw_set_font(
        fnt_terminal
    );


    terminal_prompt(
        "ENTER: CONTINUE"
    );
}