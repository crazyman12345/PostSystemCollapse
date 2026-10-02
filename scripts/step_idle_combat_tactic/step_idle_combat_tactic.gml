function step_idle_combat_tactic()
{
    if (keyboard_check_pressed(ord("W")))
    {
        idle_combat_tactic_index--;
        if (idle_combat_tactic_index < 0) idle_combat_tactic_index = 2;
    }

    if (keyboard_check_pressed(ord("S")))
    {
        idle_combat_tactic_index++;
        if (idle_combat_tactic_index > 2) idle_combat_tactic_index = 0;
    }

    if (keyboard_check_pressed(vk_enter))
    {
        combat_tactic = idle_combat_tactic_index;
		idle_combat_in_box = false;
        return;
    }

    if (keyboard_check_pressed(vk_escape))
    {
        idle_combat_in_box = false;
        return;
    }
}