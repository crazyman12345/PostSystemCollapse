function draw_raid_doors()
{
    if (!raid.doors_active)
        return;

    draw_set_halign(fa_center);
    draw_set_font(fnt_terminal_small);

    for (var i = 0; i < array_length(raid_doors); i++)
    {
        var d = raid_doors[i];

        draw_set_color(c_lime);

        //draw_rectangle(
        //    d.door_x - d.door_w * 0.5,
        //    d.door_y - d.door_h * 0.5,
        //    d.door_x + d.door_w * 0.5,
        //    d.door_y + d.door_h * 0.5,
        //    true
        //);

        draw_text_transformed(
            d.door_x,
            d.door_y-75,
            raid_reward_name(d.reward_type),
            0.35,
            0.35,
            0
        );
    }

    draw_set_halign(fa_left);
}



function draw_raid_door_overlay()
{
    if (!raid.doors_active && !raid.room_exiting)
        return;

    // Match the room border's scaled position so the doorway stays aligned.
    var _source_inner_left = 80;
    var _source_inner_top = 80;
    var _source_inner_width = 467;
    var _source_inner_height = 467;

    var _scale_x = (raid_room_x2 - raid_room_x1) / _source_inner_width;
    var _scale_y = (raid_room_y2 - raid_room_y1) / _source_inner_height;

    var _draw_x = raid_room_x1 - (_source_inner_left * _scale_x);
    var _draw_y = raid_room_y1 - (_source_inner_top * _scale_y);


    // ==============================
    // BLACK AREA ABOVE DOORS
    // ==============================

    if (array_length(raid_doors) > 0)
    {
        var _door_top = raid_doors[0].door_y - (raid_doors[0].door_h * 0.5);

        // Find highest door in case their positions differ.
        for (var i = 1; i < array_length(raid_doors); i++)
        {
            var _top =
                raid_doors[i].door_y
                - (raid_doors[i].door_h * 0.5);

            _door_top = min(_door_top, _top);
        }

        draw_set_color(c_black);

        draw_rectangle(
            raid_room_x1,
            150,
            raid_room_x2,
            _door_top -55,
            false
        );
    }


    // ==============================
    // DOOR OVERLAY
    // ==============================

    draw_sprite_ext(
        spr_door_overlay,
        0,
        _draw_x,
        _draw_y,
        _scale_x,
        _scale_y,
        0,
        c_white,
        1
    );
}
