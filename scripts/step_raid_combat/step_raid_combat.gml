function step_raid_combat()
{
    if (!raid.combat_active)
    {
        return;
    }


    switch (raid.combat_phase)
    {
        case CombatPhase.DECISION:
        {
            step_raid_combat_decision();
            break;
        }


        case CombatPhase.AUTO_BURST:
        {
            step_raid_combat_auto();
            break;
        }


        case CombatPhase.ITEM_SELECT:
        {
            step_raid_combat_item_select();
            break;
        }
    }
}