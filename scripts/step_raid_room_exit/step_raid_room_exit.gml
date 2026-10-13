function step_raid_room_exit()
{
    raid_player_y = max(
        raid_player_y - raid_player_entry_speed * frame_scale,
        raid_player_exit_target_y
    );
    raid_player_moving = true;
    raid_player_anim_frame += raid_player_anim_speed * frame_scale;
    step_raid_camera();

    if (raid_player_y > raid_player_exit_target_y) return;

    raid_player_y = raid_player_exit_target_y;

    if (raid.current_room_type == RaidRoomType.CHECKPOINT)
    {
        raid.rooms_in_section = 0;
        raid.section++;
        raid.extract_active = false;
    }

    raid.room_number++;
    raid_enter_normal_room(raid_player_exit_reward_type);
}
