function step_raid_doors()
{
    if (!raid.doors_active)
        return;

    for (var i = 0; i < array_length(raid_doors); i++)
    {
        var d = raid_doors[i];

        var _left = d.door_x - d.door_w * 0.5;
        var _right = d.door_x + d.door_w * 0.5;
        var _top = d.door_y - d.door_h * 0.5;
        var _bottom = d.door_y + d.door_h * 0.5;

		   if (
		    raid_player_x >= _left
		    && raid_player_x <= _right
		    && raid_player_y >= _top
		    && raid_player_y <= _bottom
		)
		{
            raid.doors_active = false;
            raid.room_exiting = true;
            raid_player_exit_target_y = raid_room_y1 - 60;
            raid_player_exit_reward_type = d.reward_type;
            raid_player_moving = true;
            raid_player_was_moving = false;
            raid_player_anim_frame = 0;

            return;
		}
    }
}
