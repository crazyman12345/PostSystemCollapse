function debug_start_boss(_args)
{
    if (array_length(_args) < 2 || (_args[1] != "1" && _args[1] != "2"))
    {
        debug_log_add("Usage: debug_start_boss <1|2> (1: Bones, 2: Rob Gnarley)");
        return;
    }

    if (!is_undefined(stash.held_item))
    {
        debug_log_add("Place the held item before starting a raid.");
        return;
    }

    var _area_index = real(_args[1]) - 1;
    raid_start(level_db[_area_index]);

    if (raid.state == RaidState.INACTIVE || raid.state == RaidState.RESULT || state != GameState.RAID)
        return;

    raid.rooms_cleared = raid.room_count;
    raid.rooms_in_section = 5;
    raid.room_number = raid.room_count + 1;

    raid_enter_normal_room(RaidRewardType.BACKROOM_STASH);

    debug_console_open = false;
    debug_log_add("[DEBUG] Boss room started.");
}
