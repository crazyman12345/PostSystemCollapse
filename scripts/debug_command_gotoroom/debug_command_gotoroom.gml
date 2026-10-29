function debug_command_gotoroom(_args)
{
    if (array_length(_args) < 2)
    {
        debug_log_add("Usage: gotoroom <room_number>");
        return;
    }

    if (state != GameState.RAID || raid.state == RaidState.INACTIVE || raid.state == RaidState.RESULT)
    {
        debug_log_add("Start a raid before using gotoroom.");
        return;
    }

    var _room_number = real(_args[1]);
    var _boss_room_number = raid.room_count + 1;
    if (_room_number != floor(_room_number) || _room_number < 1 || _room_number > _boss_room_number)
    {
        debug_log_add("Room must be between 1 and " + string(_boss_room_number) + ".");
        return;
    }

    raid.room_number = _room_number;
    raid.rooms_cleared = _room_number - 1;
    raid.rooms_in_section = (_room_number - 1) mod 5;
    raid.section = 1 + floor((_room_number - 1) / 5);
    raid_enter_normal_room(raid_get_random_reward());

    debug_console_open = false;
    debug_log_add("Moved to room " + string(_room_number) + ".");
}
