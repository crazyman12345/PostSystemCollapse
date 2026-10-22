function debug_start_boss()
{
    if (!is_undefined(stash.held_item))
    {
        debug_log_add("Place the held item before starting a raid.");
        return;
    }

    raid_start(level_db[0]);

    if (raid.state == RaidState.INACTIVE || raid.state == RaidState.RESULT || state != GameState.RAID)
        return;

    raid.rooms_cleared = raid.room_count;
    raid.rooms_in_section = 5;
    raid.room_number = raid.room_count + 1;

    raid_enter_normal_room(RaidRewardType.BACKROOM_STASH);

    debug_console_open = false;
    debug_log_add("[DEBUG] Boss room started.");
}
