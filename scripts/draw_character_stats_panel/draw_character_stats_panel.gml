function draw_character_stats_panel(_member)
{
    terminal_panel(
        60,
        590,
        760,
        360,
        "CHARACTER STATUS"
    );


    draw_set_font(fnt_terminal_small);


    var _x = 110;
    var _y = 660;
    var spacing = 42;


    draw_text(
        _x,
        _y,
        "STATUS: "
        + (_member.alive ? "ALIVE" : "DEAD")
    );


    draw_text(
        _x,
        _y + spacing,
        "HP: "
        + string(_member.hp)
        + " / "
        + string(_member.max_hp)
    );


    draw_text(
        _x,
        _y + (spacing * 2),
        "ACCURACY: "
        + string(round(_member.accuracy * 100))
        + "%"
    );


    draw_text(
        _x,
        _y + (spacing * 3),
        "BAG WEIGHT: "
        + string_format(
            raid_bag_get_weight(),
            1,
            1
        )
        + " / "
        + string_format(
            raid_get_max_weight(),
            1,
            1
        )
        + " KG"
    );
	
	if (raid_is_overencumbered())
	{
	    draw_text(
	        _x,
	        _y + (spacing * 4),
	        "STATUS: OVERENCUMBERED"
	    );
	}


    draw_set_font(fnt_terminal);
}