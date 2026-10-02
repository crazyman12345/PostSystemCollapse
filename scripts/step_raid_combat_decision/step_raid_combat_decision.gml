function step_raid_combat_decision()
{
    // ========================================================
    // MOVE THROUGH COMBAT OPTIONS
    //
    // 0 = ATTACK
    // 1 = USE ITEM
    // ========================================================

    raid.combat_action_index =
        terminal_menu_input(
            raid.combat_action_index,
            2
        );


    // ========================================================
    // SELECT ACTION
    // ========================================================

    if (!keyboard_check_pressed(vk_enter))
    {
        return;
    }


    switch (raid.combat_action_index)
    {
        // ====================================================
        // ATTACK
        // ====================================================

        case CombatAction.ATTACK:
        {
            // Cannot attack while overencumbered
            if (raid_is_overencumbered())
            {
                log_add(
                    "Too encumbered to attack."
                );

                return;
            }


            // Start automatic combat burst
            raid.combat_phase =
                CombatPhase.AUTO_BURST;

            raid.combat_turn =
                CombatTurn.PLAYER;

            raid.combat_timer =
                0;

            raid.combat_exchanges_remaining =
                raid.combat_exchanges_per_burst;

            break;
        }


        // ====================================================
        // USE ITEM
        // ====================================================

        case CombatAction.USE_ITEM:
        {
            var usable_items = raid_combat_get_usable_items();             


            if (array_length(usable_items) <= 0)
            {
                log_add(
                    "No usable combat items."
                );

                return;
            }


            raid.combat_item_index =
                0;

            raid.combat_phase =
                CombatPhase.ITEM_SELECT;

            break;
        }
    }
}