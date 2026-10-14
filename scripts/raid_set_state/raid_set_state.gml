function raid_set_state(_state)
{
    if (raid.state == _state) return;

    var _previous_state = raid.state;
    raid.state = _state;

    switch (_state)
    {
        case RaidState.COMBAT:
            if (_previous_state == RaidState.ENTERING)
            {
                raid_player_moving = false;
                raid_player_was_moving = false;
                raid_player_anim_frame = 0;
            }
        break;

        case RaidState.ENTERING:
        case RaidState.EXITING:
            raid_player_moving = true;
            raid_player_was_moving = false;
            raid_player_anim_frame = 0;
        break;

        case RaidState.PAUSED:
            raid.pause_menu_index = 7;
        break;

        case RaidState.DEATH:
            part_particles_clear(smoke_particle_system);
            smoke_particle_update_accumulator = 0;
            raid_player_death_phase = 0;
            raid_player_death_timer = 0;
            raid_player_death_x = raid_player_x;
            raid_player_death_y = raid_player_y;
            raid_player_death_sprite = raid_player_moving ? spr_player_run : spr_player_idle;
            raid_player_death_frame = floor(raid_player_anim_frame) mod sprite_get_number(raid_player_death_sprite);
            raid_player_death_facing = raid_player_facing;
            raid_player_death_scale = 1;
            raid_player_death_chunks_created = false;
            raid_player_death_camera_width = camera_get_view_width(raid_camera);
            raid_player_death_camera_height = camera_get_view_height(raid_camera);
            raid_player_x = raid_player_death_x;
            raid_player_y = raid_player_death_y;
            raid_player_velocity_x = 0;
            raid_player_velocity_y = 0;
            raid_player_smoothed_velocity_x = 0;
            raid_player_smoothed_velocity_y = 0;
            raid_player_dash_active = false;
            raid_player_moving = false;
            raid_gun_tuning_active = false;
            overlay_mode = OverlayMode.NONE;
            blood_stamp_pool(raid_player_death_x, raid_player_death_y, 1.6);
        break;

        case RaidState.RESULT:
            part_particles_clear(smoke_particle_system);
            smoke_particle_update_accumulator = 0;
            raid_gun_tuning_active = false;
            menu_index = 0;
        break;
    }
}
