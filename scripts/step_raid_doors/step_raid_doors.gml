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
		    // LEAVING CHECKPOINT
		    if (
		        raid.current_room_type
		        == RaidRoomType.CHECKPOINT
		    )
		    {
		        raid.rooms_in_section = 0;
		        raid.section++;
		        raid.extract_active = false;
		    }

		    raid.room_number++;
		    raid_enter_normal_room(
		        d.reward_type
		    );

		    return;
		}
    }
}
