function draw_morrowleaf_harvest()
{
    terminal_header("HARVEST COMPLETE");

    terminal_panel(
        420,
        220,
        1080,
        560,
        "HARVEST REPORT"
    );

    terminal_value(
        500,
        320,
        "FINAL QUALITY",
        string(harvest_quality) + "%",
        350
    );

    terminal_value(
        500,
        390,
        "YIELD",
        string(harvest_yield) + "x RAW MORROWLEAF",
        350
    );

    terminal_value(
        500,
        460,
        "DRUG MAKING XP",
        "+" + string(harvest_xp),
        350
    );

    terminal_menu_item(
        500,
        620,
        "COLLECT HARVEST",
        true
    );

    terminal_prompt(
        "ENTER: COLLECT"
    );
}