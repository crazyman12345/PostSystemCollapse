function step_raid()
{
    // Debug input
    var _raid_transition_blocks_input = raid.state == RaidState.ENTERING
        || raid.state == RaidState.DEATH;

    if (!_raid_transition_blocks_input) step_debug_terminal();
    if (debug_console_open) return;

    // Raid states
    switch (raid.state)
    {
        case RaidState.COMBAT: step_raid_combat(); break;
        case RaidState.ENTERING: step_raid_room_entry(); break;
        case RaidState.EXITING: step_raid_room_exit(); break;
        case RaidState.PAUSED: step_raid_pause_menu(); break;
        case RaidState.DEATH:
            step_raid_player_death();
            return;
        case RaidState.RESULT: step_raid_result(); break;
    }

    // Cleanup
    if (raid.state != RaidState.ENTERING && raid.state != RaidState.DEATH) smoke_update();
}
