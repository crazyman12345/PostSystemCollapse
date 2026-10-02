function draw_raid_gun()
{
    var member = crew[0];

    if (member.weapon == "")
        return;

    var _weapon = item_get(member.weapon);

    if (!is_struct(_weapon))
        return;

    var _pivot_x = raid_player_x;
    var _pivot_y = raid_player_y - 10;

    var _dir = raid_aim_dir;


    // ==============================
    // GUN POSITION
    // ==============================

var _draw_offset =
    raid_gun_offset
    - raid_gun_recoil;

var _gun_x =
    _pivot_x
    + lengthdir_x(
        _draw_offset,
        _dir
    );

var _gun_y =
    _pivot_y
    + lengthdir_y(
        _draw_offset,
        _dir
    );


    // ==============================
    // DRAW GUN
    // ==============================

		 var _flip_y = 1;

		if (raid_aim_dir > 90 && raid_aim_dir < 270)
		{
		    _flip_y = -1;
		}

		draw_sprite_ext(
		    _weapon.weapon_sprite,
		    0,
		    round(_gun_x),
		    round(_gun_y),
		    1,
		    _flip_y,
		    _dir,
		    c_white,
		    1
		);


    // ==============================
    // MAIN HAND
    // ==============================

    var _hand1_x =
        _gun_x
        + lengthdir_x(
            _weapon.hand1_x,
            _dir
        )
        + lengthdir_x(
            _weapon.hand1_y,
            _dir + 90
        );

    var _hand1_y =
        _gun_y
        + lengthdir_y(
            _weapon.hand1_x,
            _dir
        )
        + lengthdir_y(
            _weapon.hand1_y,
            _dir + 90
        );

		draw_sprite_ext(
		    spr_hand,
		    0,
		    round(_hand1_x),
		    round(_hand1_y),
		    1,
		    _flip_y,
		    _dir,
		    c_white,
		    1
		);


    // ==============================
    // SECOND HAND
    // ==============================

    if (_weapon.has_second_hand)
    {
        var _hand2_x =
            _gun_x
            + lengthdir_x(
                _weapon.hand2_x,
                _dir
            )
            + lengthdir_x(
                _weapon.hand2_y,
                _dir + 90
            );

        var _hand2_y =
            _gun_y
            + lengthdir_y(
                _weapon.hand2_x,
                _dir
            )
            + lengthdir_y(
                _weapon.hand2_y,
                _dir + 90
            );

		      draw_sprite_ext(
		    spr_hand,
		    0,
		    round(_hand2_x),
		    round(_hand2_y),
		    1,
		    _flip_y,
		    _dir,
		    c_white,
		    1
		);
		    }
}