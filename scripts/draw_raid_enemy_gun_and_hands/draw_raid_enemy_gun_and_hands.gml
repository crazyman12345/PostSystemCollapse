function draw_raid_enemy_gun_and_hands(_enemy)
{
    if (_enemy.weapon == -1 || is_undefined(_enemy.weapon))
        return;

    var _weapon = _enemy.weapon;

    if (_weapon.weapon_sprite == -1)
        return;


    // ==============================
    // PIVOT / DIRECTION
    // ==============================

    var _pivot_x = _enemy.enemy_x;
    var _pivot_y = _enemy.enemy_y - 18;

    var _dir = _enemy.enemy_gun_angle;


    // ==============================
    // FLIP
    // ==============================

    var _flip = 1;

    if (_dir > 90 && _dir < 270)
        _flip = -1;


    // ==============================
    // WEAPON SCALE
    // ==============================

    var _sprite = _weapon.weapon_sprite;

    var _visible_width =
        sprite_get_bbox_right(_sprite)
        - sprite_get_bbox_left(_sprite)
        + 1;

    var _weapon_scale =
        _weapon.weapon_draw_width
        / max(1, _visible_width);


    // ==============================
    // GUN POSITION
    // ==============================

    var _offset =
        _enemy.enemy_gun_recoil
        + _weapon.weapon_offset_x;

    var _gun_x =
        _pivot_x
        + lengthdir_x(
            _offset,
            _dir
        );

    var _gun_y =
        _pivot_y
        + lengthdir_y(
            _offset,
            _dir
        );


    // ==============================
    // DRAW GUN
    // ==============================

    draw_sprite_ext(
        _sprite,
        0,
        round(_gun_x),
        round(_gun_y),
        _weapon_scale,
        _weapon_scale * _flip,
        _dir,
        c_white,
        1
    );


    // ==============================
    // HAND 1 - HANDLE
    // ==============================

    if (_enemy.enemy_hand_sprite != -1)
    {
        var _h1x = _weapon.hand1_x;
        var _h1y = _weapon.hand1_y;

        if (_flip == -1)
            _h1y *= -1;

        var _hand1_world_x =
            _gun_x
            + lengthdir_x(
                _h1x,
                _dir
            )
            + lengthdir_x(
                _h1y,
                _dir + 90
            );

        var _hand1_world_y =
            _gun_y
            + lengthdir_y(
                _h1x,
                _dir
            )
            + lengthdir_y(
                _h1y,
                _dir + 90
            );

        draw_sprite_ext(
            _enemy.enemy_hand_sprite,
            0,
            round(_hand1_world_x),
            round(_hand1_world_y),
            1,
            1,
            0,
            c_white,
            1
        );
    }


    // ==============================
    // HAND 2 - FOREGRIP
    // ==============================

    if (
        _weapon.has_second_hand
        && _enemy.enemy_hand_sprite != -1
    )
    {
        var _h2x = _weapon.hand2_x;
        var _h2y = _weapon.hand2_y;

        if (_flip == -1)
            _h2y *= -1;

        var _hand2_world_x =
            _gun_x
            + lengthdir_x(
                _h2x,
                _dir
            )
            + lengthdir_x(
                _h2y,
                _dir + 90
            );

        var _hand2_world_y =
            _gun_y
            + lengthdir_y(
                _h2x,
                _dir
            )
            + lengthdir_y(
                _h2y,
                _dir + 90
            );

        draw_sprite_ext(
            _enemy.enemy_hand_sprite,
            0,
            round(_hand2_world_x),
            round(_hand2_world_y),
            1,
            1,
            0,
            c_white,
            1
        );
    }
}