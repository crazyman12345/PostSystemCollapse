function step_raid_room_entry()
{
    raid_player_y = max(
        raid_player_y - raid_player_entry_speed * frame_scale,
        raid_player_entry_target_y
    );
    raid_player_anim_frame += raid_player_anim_speed * frame_scale;
    step_raid_camera();

    if (raid_player_y > raid_player_entry_target_y) return;

    raid_player_y = raid_player_entry_target_y;
    raid_set_state(RaidState.COMBAT);
}
