function draw_raid_lootable_prompt()
{
    if (!raid.room_cleared)
        return;


    for (
        var i = 0;
        i < array_length(raid_lootables);
        i++
    )
    {
        var l =
            raid_lootables[i];


        if (
            point_distance(
                raid_player_x,
                raid_player_y,
                l.lootable_x,
                l.lootable_y
            ) <= 36
        )
        {
            draw_interact_prompt(
                l.lootable_x,
                l.lootable_y - 30
            );

            return;
        }
    }
}