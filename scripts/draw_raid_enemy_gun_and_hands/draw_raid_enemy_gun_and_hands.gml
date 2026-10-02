function draw_raid_enemy_gun_and_hands(_enemy)
{
    if (_enemy.enemy_gun_sprite == -1)
        return;


    var _pivot_x =
        _enemy.enemy_x;

    var _pivot_y =
        _enemy.enemy_y - 18;

    var _dir =
        _enemy.enemy_gun_angle;


    // ==============================
    // FLIP
    // ==============================

    var _flip = 1;

    if (_dir > 90 && _dir < 270)
        _flip = -1;


    // ==============================
    // GUN POSITION
    // ==============================

    var _offset =
        _enemy.enemy_gun_offset
        - _enemy.enemy_gun_recoil;

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
        _enemy.enemy_gun_sprite,
        0,
        _gun_x,
        _gun_y,
        1,
        _flip,
        _dir,
        c_white,
        1
    );


    // ==============================
    // HAND 1 - HANDLE
    // ==============================

    if (_enemy.enemy_hand_sprite != -1)
    {
        var _h1x =
            _enemy.enemy_hand1_x;

        var _h1y =
            _enemy.enemy_hand1_y;


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
            _hand1_world_x,
            _hand1_world_y,
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
        _enemy.enemy_has_second_hand
        && _enemy.enemy_hand_sprite != -1
    )
    {
        var _h2x =
            _enemy.enemy_hand2_x;

        var _h2y =
            _enemy.enemy_hand2_y;


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
            _hand2_world_x,
            _hand2_world_y,
            1,
            1,
            0,
            c_white,
            1
        );
    }
}