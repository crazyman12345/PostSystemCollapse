function step_raid()
{
    // Debug input
    var _raid_transition_blocks_input = raid.state == RaidState.ENTERING
        || raid.state == RaidState.DEATH;

    if (!_raid_transition_blocks_input) step_debug_terminal();
    if (debug_console_open) return;

    if (raid_texture_crop_debug_step())
    {
        raid_environment_update();
        return;
    }

    if (keyboard_check_pressed(vk_f3)) raid_shadow_debug = !raid_shadow_debug;
    if (keyboard_check_pressed(vk_f4)) raid_environment.enabled = !raid_environment.enabled;
    if (keyboard_check_pressed(vk_f5)) raid_environment.debug = !raid_environment.debug;
    raid_environment_update();

    // Debug movement proves that visibility is rebuilt from live light/caster data.
    if (raid_shadow_debug && array_length(raid_wall_lights) > 0)
    {
        var _debug_move_x = keyboard_check(vk_right) - keyboard_check(vk_left);
        var _debug_move_y = keyboard_check(vk_down) - keyboard_check(vk_up);
        var _debug_move_speed = 2 * frame_scale;
        if (keyboard_check(vk_shift))
        {
            raid_wall_lights[0].x += _debug_move_x * _debug_move_speed;
            raid_wall_lights[0].y += _debug_move_y * _debug_move_speed;
        }
        else if (array_length(raid_lootables) > 0)
        {
            raid_lootables[0].lootable_x += _debug_move_x * _debug_move_speed;
            raid_lootables[0].lootable_y += _debug_move_y * _debug_move_speed;
            raid_lootables[0].sprite_x += _debug_move_x * _debug_move_speed;
            raid_lootables[0].sprite_y += _debug_move_y * _debug_move_speed;
        }
    }

    if (raid.state != RaidState.PAUSED && raid.state != RaidState.RESULT)
    {
        for (var _light_index = array_length(raid_temporary_lights) - 1; _light_index >= 0; _light_index--)
        {
            var _light = raid_temporary_lights[_light_index];
            _light.lifetime = max(0, _light.lifetime - frame_scale);
            var _initial_lifetime = variable_struct_exists(_light, "initial_lifetime") ? _light.initial_lifetime : max(0.001, _light.lifetime + frame_scale);
            var _initial_intensity = variable_struct_exists(_light, "initial_intensity") ? _light.initial_intensity : _light.intensity;
            var _decay_power = variable_struct_exists(_light, "decay_power") ? _light.decay_power : 1;
            _light.intensity = _initial_intensity * power(clamp(_light.lifetime / _initial_lifetime, 0, 1), _decay_power);

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
    if (raid.state == RaidState.COMBAT || raid.state == RaidState.EXITING) smoke_update();
}
