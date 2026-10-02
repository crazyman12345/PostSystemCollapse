function draw_raid_crew_select()
{
    terminal_header("RAID // SELECT CREW");

    terminal_panel(
        120,
        180,
        1680,
        600,
        "AVAILABLE CREW"
    );

    for (var i = 0; i < array_length(crew); i++)
    {
        var member = crew[i];

        terminal_menu_item(
            180,
            260 + (i * 60),
            member.name
            + "    HP "
            + string(member.hp)
            + "/"
            + string(member.max_hp),
            menu_index == i
        );
    }

    terminal_prompt(
        "W/S: SELECT    ENTER: CONFIRM    ESC: BACK"
    );
}