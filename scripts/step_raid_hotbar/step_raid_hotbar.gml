function step_raid_hotbar(_allow_combat_input)
{
    if (raid.state != RaidState.COMBAT && raid.state != RaidState.EXITING) return;

    raid_hotbar_validate();

    if (_allow_combat_input)
    {
        if (keyboard_check_pressed(ord("1"))) raid_hotbar_use(0);
        if (keyboard_check_pressed(ord("2"))) raid_hotbar_use(1);
        if (keyboard_check_pressed(ord("3"))) raid_hotbar_use(2);
        if (keyboard_check_pressed(ord("4"))) raid_hotbar_use(3);
        if (keyboard_check_pressed(ord("5"))) raid_hotbar_use(4);
        if (keyboard_check_pressed(ord("6"))) raid_hotbar_use(5);
    }

    if (raid.hotbar_feedback_timer > 0) raid.hotbar_feedback_timer -= frame_scale;
}
