function step_idle_combat_boxes()
{
    var count = 4;

    if (keyboard_check_pressed(ord("W")))
    {
        idle_combat_box--;
        if (idle_combat_box < 0) idle_combat_box = count - 1;
    }

    if (keyboard_check_pressed(ord("S")))
    {
        idle_combat_box++;
        if (idle_combat_box >= count) idle_combat_box = 0;
    }

    if (keyboard_check_pressed(vk_enter))
    {
        switch (idle_combat_box)
        {
            case IdleCombatBox.MEDS:
                idle_combat_med_index = 0;
                idle_combat_in_box = true;
            break;

            case IdleCombatBox.EQUIPMENT:
                idle_combat_equipment_index = 0;
                idle_combat_in_box = true;
            break;

            case IdleCombatBox.TACTIC:
                idle_combat_tactic_index = combat_tactic;
                idle_combat_in_box = true;
            break;

            case IdleCombatBox.BACK:
                idle_combat_active = false;
                combat_menu_focus = CombatMenuFocus.AREAS;
                combat_area_index = 0;
                combat_enemy_index = 0;
            break;
        }

        return;
    }
}