function draw_raid_status_bar()
{
    var member =
        crew[raid.crew_index];

    var location =
        raid_location_get(
            raid.location_key
        );


    terminal_panel(
        60,
        60,
        1800,
        100,
        location.name
    );


    draw_set_font(
        fnt_terminal_small
    );


    draw_text(
        100,
        110,
        "CREW: "
        + member.name
    );


    draw_text(
        400,
        110,
        "HP: "
        + string(member.hp)
        + " / "
        + string(member.max_hp)
    );


    draw_text(
        700,
        110,
        "THREAT: "
        + raid_get_threat_name()
    );


    draw_text(
        1000,
        110,
        "NOISE: "
        + string(raid.noise)
    );


    draw_text(
        1300,
        110,
        "BAG: "
        + string_format(
            raid_bag_get_weight(),
            1,
            1
        )
        + " / "
        + string_format(
            raid_bag_get_max_weight(),
            1,
            1
        )
        + " KG"
    );


    draw_set_font(
        fnt_terminal
    );
}