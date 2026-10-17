function draw_raid_doors()
{
    if (!raid.doors_active && raid.state != RaidState.EXITING)
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
            d.door_y-90,
            raid_reward_name(d.reward_type),
            0.35,
            0.35,
            0
        );
    }

    draw_set_halign(fa_left);
}


function draw_raid_door_backgrounds()
{
    if (raid_environment.enabled) return;
    if (!raid.doors_active && raid.state != RaidState.EXITING)
        return;

    var _source_left = sprite_get_bbox_left(spr_door_bg);
    var _source_top = sprite_get_bbox_top(spr_door_bg);
    var _source_width = sprite_get_bbox_right(spr_door_bg) - _source_left + 1;
    var _source_height = sprite_get_bbox_bottom(spr_door_bg) - _source_top + 1;
    var _room_scale_x = (raid_room_x2 - raid_room_x1) / 467;
    var _room_scale_y = (raid_room_y2 - raid_room_y1) / 467;
    var _border_draw_x = raid_room_x1 - 80 * _room_scale_x;
    var _border_draw_y = raid_room_y1 - 80 * _room_scale_y;
    var _opening_padding = 2;
    var _opening_top_stretch = 6;

    for (var i = 0; i < array_length(raid_doors); i++)
    {
        var _opening_left = i == 0 ? 215 : 352;
        var _opening_width = i == 0 ? 61 : 60;
        var _opening_height = i == 0 ? 33 : 32;
        draw_sprite_part_ext(
            spr_door_bg,
            0,
            _source_left,
            _source_top,
            _source_width,
            _source_height,
            _border_draw_x + (_opening_left - _opening_padding) * _room_scale_x,
            _border_draw_y + (22 - _opening_padding - _opening_top_stretch) * _room_scale_y,
            (_opening_width + _opening_padding * 2) * _room_scale_x / _source_width,
            (_opening_height + _opening_padding * 2 + _opening_top_stretch) * _room_scale_y / _source_height,
            c_white,
            1
        );
    }
}



function draw_raid_door_overlay()
{
    if (raid_environment.enabled) return;
    if (!raid.doors_active && raid.state != RaidState.EXITING)
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
