function step_idle_combat()
{
    var dt = delta_time / 1000000;

    // Combat continues even while navigating boxes
    if (idle_combat_active) idle_combat_update(dt);

    // OUTSIDE BOXES
    if (!idle_combat_in_box)
    {
        step_idle_combat_boxes();
        return;
    }

    // INSIDE SELECTED BOX
    switch (idle_combat_box)
    {
        case IdleCombatBox.MEDS:
            step_idle_combat_meds();
        break;

        case IdleCombatBox.EQUIPMENT:
            step_idle_combat_equipment();
        break;

        case IdleCombatBox.TACTIC:
            step_idle_combat_tactic();
        break;
    }
}