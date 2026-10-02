function step_raid_extract()
{
    if (!raid.extract_active)
        return;

   var _ladder_x = raid_room_x1 + 55;

    var _ladder_y =
        raid_room_y1 + 55;

    var _distance =
        point_distance(
            raid_player_x,
            raid_player_y,
            _ladder_x,
            _ladder_y
        );

    if (_distance <= 35)
    {
        if (keyboard_check_pressed(ord("E")))
        {
            raid_extract();
        }
    }
}