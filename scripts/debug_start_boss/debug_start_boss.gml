function debug_start_boss()
{
    if (!is_undefined(stash.held_item))
    {
        debug_log_add("Place the held item before starting a raid.");
        return;
    }

    raid_start("prototype_block");

    if (!raid.active || state != GameState.RAID)
        return;

    raid.rooms_cleared = 14;
    raid.rooms_in_section = 4;
    raid.room_number = 15;

    raid_enter_normal_room(RaidRewardType.BACKROOM_STASH);

    debug_log_add("[DEBUG] Boss room started.");
}
