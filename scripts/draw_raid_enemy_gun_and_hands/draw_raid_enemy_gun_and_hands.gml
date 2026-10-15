function draw_raid_enemy_gun_and_hands(_enemy, _lighting_mask = false, _mask_alpha = 1)
{
    if (_enemy.weapon == -1 || is_undefined(_enemy.weapon))
        return;

    var _weapon = _enemy.weapon;

    var _s = variable_struct_exists(_enemy, "size_multiplier")
        ? _enemy.size_multiplier
        : 1;

    if (_weapon.weapon_sprite == -1)
        return;


    // ==============================
    // PIVOT / DIRECTION
    // ==============================

    var _pivot_x = _enemy.enemy_x;
    var _pivot_y = _enemy.enemy_y - (18 * _s);

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
        / max(1, _visible_width)
        * 0.75
        * _s;


    // ==============================
    // GUN POSITION
    // ==============================

    var _weapon_offset_y = variable_struct_exists(_weapon, "weapon_offset_y")
        ? _weapon.weapon_offset_y * _s * _flip
        : 0;

    var _offset =
        _enemy.enemy_gun_recoil
        + (_weapon.weapon_offset_x * _s);

    var _gun_x =
        _pivot_x
        + lengthdir_x(
            _offset,
            _dir
        )
        + lengthdir_x(
            _weapon_offset_y,
            _dir + 90
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
        _lighting_mask ? _mask_alpha : 1
    );

    if (is_struct(_enemy.enemy_muzzle_flash_light) && _enemy.enemy_muzzle_flash_light.lifetime > 0)
    {
        var _muzzle_x = _enemy.enemy_muzzle_x * _s;
        var _muzzle_y = _enemy.enemy_muzzle_y * _s * _flip;
        var _muzzle_world_x = _gun_x
            + lengthdir_x(_muzzle_x, _dir)
            + lengthdir_x(_muzzle_y, _dir + 90);
        var _muzzle_world_y = _gun_y
            + lengthdir_y(_muzzle_x, _dir)
            + lengthdir_y(_muzzle_y, _dir + 90);
        var _muzzle_flash_scale = variable_struct_exists(_weapon, "muzzle_flash_scale")
            ? _weapon.muzzle_flash_scale
            : 0.5;

        _enemy.enemy_muzzle_flash_light.x = _muzzle_world_x;
        _enemy.enemy_muzzle_flash_light.y = _muzzle_world_y;
        _enemy.enemy_muzzle_flash_light.flash_xscale = _muzzle_flash_scale * _s * _enemy.enemy_muzzle_flash_light.flash_scale;
        _enemy.enemy_muzzle_flash_light.flash_yscale = _muzzle_flash_scale * _s * _enemy.enemy_muzzle_flash_light.flash_scale * _flip * _enemy.enemy_muzzle_flash_light.flash_mirror;
        _enemy.enemy_muzzle_flash_light.flash_direction = _dir + _enemy.enemy_muzzle_flash_light.flash_rotation;
    }


    // ==============================
    // HAND 1 - HANDLE
    // ==============================

    if (_enemy.enemy_hand_sprite != -1)
    {
        var _h1x = _weapon.hand1_x * _s;
        var _h1y = _weapon.hand1_y * _s;

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
            _s,
            _s * _flip,
            _dir,
            c_white,
            _lighting_mask ? _mask_alpha : 1
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
        var _h2x = _weapon.hand2_x * _s;
        var _h2y = _weapon.hand2_y * _s;

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
            _s,
            _s * _flip,
            _dir,
            c_white,
            _lighting_mask ? _mask_alpha : 1
        );
    }
}
