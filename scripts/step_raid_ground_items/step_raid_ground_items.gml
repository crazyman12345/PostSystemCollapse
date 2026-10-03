function step_raid_ground_items()
{
    if (array_length(raid_ground_items) <= 0)
        return;


    var _interact_distance = 28;

    var _nearest_index = -1;
    var _nearest_distance = 999999;


    for (
        var i = 0;
        i < array_length(raid_ground_items);
        i++
    )
    {
        var g =
            raid_ground_items[i];


        var _dist =
            point_distance(
                raid_player_x,
                raid_player_y,
                g.ground_x,
                g.ground_y
            );


        if (
            _dist <= _interact_distance
            && _dist < _nearest_distance
        )
        {
            _nearest_index = i;
            _nearest_distance = _dist;
        }
    }


    if (
        _nearest_index != -1
        && keyboard_check_pressed(ord("E"))
    )
    {
        audio_play_sound(snd_interact, 0, false);
        raid_pickup_ground_item(
            _nearest_index
        );
    }
}
