function draw_raid_extract()
{
    if (!raid.extract_active)
        return;

    var _x = raid_room_x1 + 55;

    var _bottom =
        raid_room_y1 + 70;

    var _top =
        raid_room_y1 - 60;

    var _width = 24;

    draw_set_color(c_white);

    // LEFT RAIL
    draw_line(
        _x - _width * 0.5,
        _bottom,
        _x - _width * 0.5,
        _top
    );

    // RIGHT RAIL
    draw_line(
        _x + _width * 0.5,
        _bottom,
        _x + _width * 0.5,
        _top
    );

    // RUNGS
    for (var _y = _bottom; _y >= _top; _y -= 12)
    {
        draw_line(
            _x - _width * 0.5,
            _y,
            _x + _width * 0.5,
            _y
        );
    }

    // LABEL
    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_center);

    draw_text_transformed(
        _x,
        _bottom + 18,
        "EXTRACT",
        0.35,
        0.35,
        0
    );
	
	var _distance = point_distance(
    raid_player_x,
    raid_player_y,
    _x,
    raid_room_y1 + 55
	);

	if (_distance <= 50)
	{
	    draw_interact_prompt(
	        raid_player_x,
	        raid_player_y - 38
	    );
	}

    draw_set_halign(fa_left);
}