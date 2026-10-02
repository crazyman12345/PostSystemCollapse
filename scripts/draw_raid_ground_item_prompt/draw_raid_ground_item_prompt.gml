function draw_raid_ground_item_prompt()
{
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
            _dist <= 28
            && _dist < _nearest_distance
        )
        {
            _nearest_distance = _dist;
            _nearest_index = i;
        }
    }


    if (_nearest_index != -1)
    {
        var g =
            raid_ground_items[
                _nearest_index
            ];

        draw_interact_prompt(
            g.ground_x,
            g.ground_y - 25
        );
    }
}