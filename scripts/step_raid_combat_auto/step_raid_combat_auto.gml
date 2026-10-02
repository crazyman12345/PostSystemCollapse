function step_raid_combat_auto()
{
    // ========================================================
    // UPDATE ATTACK TIMER
    // ========================================================

    var delta_seconds =
        delta_time / 1000000;


    raid.combat_timer +=
        delta_seconds;


    // Wait until next attack
    if (
        raid.combat_timer
        < raid.combat_delay
    )
    {
        return;
    }


    raid.combat_timer =
        0;


    // ========================================================
    // PLAYER TURN
    // ========================================================

    if (
        raid.combat_turn
        == CombatTurn.PLAYER
    )
    {
        // ----------------------------------------------------
        // CHECK OVERENCUMBRANCE AGAIN
        //
        // Useful in case inventory somehow changes during
        // combat.
        // ----------------------------------------------------

        if (raid_is_overencumbered())
        {
            log_add(
                "Too encumbered to attack."
            );

            raid.combat_phase =
                CombatPhase.DECISION;

            raid.combat_turn =
                CombatTurn.PLAYER;

            return;
        }


        // ----------------------------------------------------
        // ATTACK
        // ----------------------------------------------------

        raid_player_attack();


        // Combat may have ended because enemy died
        if (!raid.combat_active)
        {
            return;
        }


        raid.combat_turn =
            CombatTurn.ENEMY;

        return;
    }


    // ========================================================
    // ENEMY TURN
    // ========================================================

    if (
        raid.combat_turn
        == CombatTurn.ENEMY
    )
    {
        raid_enemy_attack();


        // Combat may have ended because player died
        if (!raid.combat_active)
        {
            return;
        }


        // One full player + enemy exchange has finished
        raid.combat_exchanges_remaining--;


        // ====================================================
        // BURST FINISHED
        // ====================================================

        if (
            raid.combat_exchanges_remaining
            <= 0
        )
        {
            raid.combat_phase =
                CombatPhase.DECISION;

            raid.combat_turn =
                CombatTurn.PLAYER;

            raid.combat_action_index =
                CombatAction.ATTACK;

            return;
        }


        // ====================================================
        // NEXT EXCHANGE
        // ====================================================

        raid.combat_turn =
            CombatTurn.PLAYER;
    }
}