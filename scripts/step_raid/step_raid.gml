function step_raid()
{
    // Debug input
    var _raid_transition_blocks_input = raid.state == RaidState.ENTERING
        || raid.state == RaidState.DEATH;

    if (!_raid_transition_blocks_input) step_debug_terminal();
    if (debug_console_open) return;

    if (raid.state != RaidState.PAUSED && raid.state != RaidState.RESULT)
    {
        for (var _light_index = array_length(raid_temporary_lights) - 1; _light_index >= 0; _light_index--)
        {
            var _light = raid_temporary_lights[_light_index];
            var _previous_lifetime = _light.lifetime;
            _light.lifetime = max(0, _light.lifetime - frame_scale);
            _light.intensity *= _previous_lifetime > 0 ? _light.lifetime / _previous_lifetime : 0;

            if (_light.lifetime <= 0)
                array_delete(raid_temporary_lights, _light_index, 1);
            else
                raid_temporary_lights[_light_index] = _light;
        }
    }

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
