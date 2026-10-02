function draw_raid_equip()
{
    var member = crew[raid.crew_index];

    terminal_header("RAID // EQUIP CREW");

    terminal_panel(
        120,
        180,
        800,
        560,
        "CREW MEMBER"
    );

    terminal_value(
        180,
        260,
        "NAME",
        member.name,
        300
    );

    terminal_value(
        180,
        320,
        "HP",
        string(member.hp) + " / " + string(member.max_hp),
        300
    );

    terminal_value(
        180,
        380,
        "WEAPON",
        member.weapon,
        300
    );

    terminal_value(
        180,
        440,
        "ARMOR",
        member.armor,
        300
    );


    terminal_panel(
        1020,
        180,
        780,
        560,
        "EQUIPMENT"
    );

    terminal_menu_item(
        1080,
        280,
        "EQUIP PISTOL",
        menu_index == 0
    );

    terminal_menu_item(
        1080,
        340,
        "NO WEAPON",
        menu_index == 1
    );

    terminal_menu_item(
        1080,
        440,
        "CONTINUE",
        menu_index == 2
    );

    terminal_prompt(
        "W/S: SELECT    ENTER: CONFIRM    ESC: BACK"
    );
}