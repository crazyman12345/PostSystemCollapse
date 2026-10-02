function draw_raid_lootables()
{
    draw_set_font(fnt_terminal_medium);


    for (
        var i = 0;
        i < array_length(raid_lootables);
        i++
    )
    {
        var l =
            raid_lootables[i];


        var _x1 =
            l.lootable_x
            - l.width * 0.5;

        var _y1 =
            l.lootable_y
            - l.height * 0.5;

        var _x2 =
            l.lootable_x
            + l.width * 0.5;

        var _y2 =
            l.lootable_y
            + l.height * 0.5;


        // BODY
        draw_set_color(c_dkgray);

        draw_rectangle(
            _x1,
            _y1,
            _x2,
            _y2,
            false
        );


        // BORDER
        if (raid.room_cleared)
            draw_set_color(c_lime);
        else
            draw_set_color(c_gray);

        draw_rectangle(
            _x1,
            _y1,
            _x2,
            _y2,
            true
        );


        // LABEL
        draw_set_halign(fa_center);

        draw_text_transformed(
            l.lootable_x,
            l.lootable_y - 20,

            raid_reward_name(
                l.reward_type
            ),

            0.25,
            0.25,
            0
        );

        draw_set_halign(fa_left);
    }
}