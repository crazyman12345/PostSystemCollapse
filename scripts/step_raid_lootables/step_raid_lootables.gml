function step_raid_lootables()
{
    if (!raid.room_cleared)
        return;


    var _interact_distance = 36;


    for (var i = 0; i < array_length(raid_lootables); i++)
    {
        var l =
            raid_lootables[i];


        var _dist =
            point_distance(
                raid_player_x,
                raid_player_y,
                l.lootable_x,
                l.lootable_y
            );


        if (_dist <= _interact_distance)
        {
            if (keyboard_check_pressed(ord("E")))
            {
                raid_open_lootable(i);
                return;
            }
        }
    }
}