function draw_raid_enemy_combat_panel()
{
    var enemy =
        enemy_get(
            raid.enemy_key
        );


    if (is_undefined(enemy))
    {
        return;
    }


    // ========================================================
    // PANEL
    // ========================================================

    terminal_panel(
        1040,
        190,
        820,
        430,
        enemy.name
    );


    // ========================================================
    // ASCII
    // ========================================================

    if (
        variable_struct_exists(
            enemy,
            "ascii"
        )
    )
    {
      


        var ascii_x =
            1370;

        var ascii_y =
            310;


        draw_ascii_block(
            enemy.ascii,
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
        1100;

    var stat_y =
        470;


    // --------------------------------------------------------
    // HP
    // --------------------------------------------------------

    draw_text(
        stat_x,
        stat_y,

        "HP: "
        + string(raid.enemy_hp)
        + " / "
        + string(enemy.max_hp)
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
                enemy.accuracy * 100
            )
        )
        + "%"
    );


    // --------------------------------------------------------
    // DAMAGE
    // --------------------------------------------------------

    draw_text(
        stat_x,
        stat_y + 80,

        "DAMAGE: "
        + string(enemy.damage_min)
        + " - "
        + string(enemy.damage_max)
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
            == CombatTurn.ENEMY
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