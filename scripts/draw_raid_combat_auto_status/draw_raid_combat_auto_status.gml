function draw_raid_combat_auto_status()
{
    terminal_panel(
        660,
        650,
        600,
        250,
        "ENGAGED"
    );


    var progress =
        raid.combat_timer
        / raid.combat_delay;


    progress =
        clamp(
            progress,
            0,
            1
        );


    draw_text(
        720,
        720,

        "EXCHANGES REMAINING: "
        + string(
            raid.combat_exchanges_remaining
        )
    );


    draw_text(
        720,
        780,

        "TURN: "
        + (
            raid.combat_turn
            == CombatTurn.PLAYER

            ? "PLAYER"
            : "ENEMY"
        )
    );
}