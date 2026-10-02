function draw_raid_player_combat_panel()
{
    var member =
        crew[raid.crew_index];


    // ========================================================
    // PANEL
    // ========================================================

    terminal_panel(
        60,
        190,
        820,
        430,
        member.name
    );


    // ========================================================
    // ASCII
    // ========================================================

    if (
        variable_struct_exists(
            member,
            "ascii"
        )
    )
    {
        var ascii_x =
            390;

        var ascii_y =
            310;

        draw_ascii_block(
            member.ascii,
            ascii_x,
            ascii_y,
            36
        );
    }


    // ========================================================
    // STATS
    // ========================================================

    draw_set_font(
        fnt_terminal_small
    );

    var stat_x =
        120;

    var stat_y =
        470;


    // --------------------------------------------------------
    // HP
    // --------------------------------------------------------

    draw_text(
        stat_x,
        stat_y,

        "HP: "
        + string(member.hp)
        + " / "
        + string(member.max_hp)
    );


    // --------------------------------------------------------
    // ACCURACY
    // --------------------------------------------------------

    draw_text(
        stat_x,
        stat_y + 40,

        "ACCURACY: "
        + string(
            round(
                member.accuracy * 100
            )
        )
        + "%"
    );


    // --------------------------------------------------------
    // BAG WEIGHT
    // --------------------------------------------------------

    var weight_text =
        "WEIGHT: "
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
        + " KG";


    if (raid_is_overencumbered())
    {
        weight_text +=
            "  [OVERENCUMBERED]";
    }


    draw_text(
        stat_x,
        stat_y + 80,
        weight_text
    );


    // ========================================================
    // CURRENT TURN
    // ========================================================

    if (
        raid.combat_phase
        == CombatPhase.AUTO_BURST
    )
    {
        if (
            raid.combat_turn
            == CombatTurn.PLAYER
        )
        {
            draw_text(
                stat_x,
                stat_y + 120,
                "> ACTING"
            );
        }
    }


    draw_set_font(
        fnt_terminal
    );
}