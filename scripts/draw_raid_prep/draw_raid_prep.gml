function draw_raid_prep()
{
    var member =
        crew[raid.crew_index];


    terminal_header(
        "RAID // PREPARATION"
    );


    // ==============================
    // CREW PANEL
    // ==============================
	draw_set_font(fnt_terminal_small);
    terminal_panel(
        80,
        180,
        650,
        650,
        "SELECTED CREW"
    );


    draw_text(
        130,
        250,
        member.name
    );


    // ==============================
    // CHARACTER ASCII
    // ==============================

    var ascii_x =
        130;

    var ascii_y =
        330;

    for (
        var i = 0;
        i < array_length(member.ascii);
        i++
    )
    {
        draw_text(
            ascii_x,
            ascii_y + (i * 30),
            member.ascii[i]
        );
    }


    // ==============================
    // CURRENT LOADOUT
    // ==============================

    var loadout_x =
        390;

    var loadout_y =
        300;


    draw_text(
        loadout_x,
        loadout_y,
        "CURRENT LOADOUT"
    );


    draw_loadout_line(
        loadout_x,
        loadout_y + 80,
        "WEAPON",
        member.weapon
    );


    draw_loadout_line(
        loadout_x,
        loadout_y + 140,
        "HEAD",
        member.armor_head
    );


    draw_loadout_line(
        loadout_x,
        loadout_y + 200,
        "CHEST",
        member.armor_chest
    );


    draw_loadout_line(
        loadout_x,
        loadout_y + 260,
        "BAG",
        member.bag
    );


    // ==============================
    // BAG CAPACITY
    // ==============================

    var bag_capacity =
        2.0;

    if (member.bag != "")
    {
        var bag_item =
            item_get(member.bag);

        if (!is_undefined(bag_item))
        {
            bag_capacity =
                bag_item.bag_capacity;
        }
    }


    terminal_value(
        loadout_x,
        loadout_y + 340,
        "LOOT CAPACITY",
        string_format(
            bag_capacity,
            1,
            1
        ) + " KG",
        240
    );

	draw_set_font(fnt_terminal);
    // ==============================
    // PREP OPTIONS
    // ==============================

    terminal_panel(
        800,
        180,
        1020,
        650,
        "RAID OPTIONS"
    );


    terminal_menu_item(
        860,
        300,
        "CHANGE CREW",
        menu_index == 0
    );


    terminal_menu_item(
        860,
        380,
        "CREW EQUIPMENT",
        menu_index == 1
    );


    terminal_menu_item(
        860,
        460,
        "SELECT LOCATION",
        menu_index == 2
    );


    terminal_prompt(
        "W/S: SELECT    ENTER: CONFIRM    ESC: BACK"
    );
}