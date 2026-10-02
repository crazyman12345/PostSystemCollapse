function draw_raid_event()
{
    draw_set_color(c_lime);

    draw_text_ext(
        100,
        300,
        raid.event_text,
        24,
        800
    );

    draw_text(
        100,
        850,
        "[ENTER] CONTINUE"
    );
}