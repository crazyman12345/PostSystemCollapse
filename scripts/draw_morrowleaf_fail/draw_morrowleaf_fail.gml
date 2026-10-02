function draw_morrowleaf_fail()
{
    terminal_header("MORROWLEAF GROW FAILED");

    terminal_panel(
        420,
        240,
        1080,
        500,
        "FAILURE REPORT"
    );

    terminal_value(
        500,
        340,
        "CAUSE",
        grow_fail_reason,
        350
    );

    terminal_value(
        500,
        410,
        "FINAL GROWTH",
        string(round(grow.growth)) + "%",
        350
    );

    terminal_value(
        500,
        480,
        "FINAL QUALITY",
        string(round(grow.quality)) + "%",
        350
    );

    draw_text(
        500,
        590,
        "[ GROW KIT LOST ]"
    );

    terminal_menu_item(
        500,
        660,
        "RETURN TO DRUG LAB",
        true
    );

    terminal_prompt(
        "ENTER: CONTINUE"
    );
}