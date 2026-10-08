function draw_raid_room_border()
{
    // Measured inner edges of the transparent room opening in the source image.
    var _source_inner_left = 80;
    var _source_inner_top = 80;
    var _source_inner_width = 467;
    var _source_inner_height = 467;

    var _scale_x = (raid_room_x2 - raid_room_x1) / _source_inner_width;
    var _scale_y = (raid_room_y2 - raid_room_y1) / _source_inner_height;
    var _draw_x = raid_room_x1 - (_source_inner_left * _scale_x);
    var _draw_y = raid_room_y1 - (_source_inner_top * _scale_y);

    draw_sprite_ext(
        raid.room_cleared ? spr_store_border_open : spr_store_border,
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
