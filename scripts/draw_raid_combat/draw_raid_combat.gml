function draw_raid_combat()
{
    draw_raid_player_combat_panel();

    draw_raid_enemy_combat_panel();


    switch (raid.combat_phase)
    {
        case CombatPhase.DECISION:
        {
            draw_raid_combat_actions();
            break;
        }


        case CombatPhase.AUTO_BURST:
        {
            draw_raid_combat_auto_status();
            break;
        }


        case CombatPhase.ITEM_SELECT:
        {
            draw_raid_combat_item_select();
            break;
        }
    }
}