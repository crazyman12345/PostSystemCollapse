function raid_enemy_fire_gun(_enemy, _dir, _speed, _damage)
{
    var e = _enemy;

    // ==============================
    // GUN PIVOT
    // ==============================

    var _pivot_x = e.enemy_x;
    var _pivot_y = e.enemy_y - 18;


    // ==============================
    // GUN POSITION
    // ==============================

    var _gun_offset =
        e.enemy_gun_offset
        - e.enemy_gun_recoil;

    var _gun_x =
        _pivot_x
        + lengthdir_x(
            _gun_offset,
            _dir
        );

    var _gun_y =
        _pivot_y
        + lengthdir_y(
            _gun_offset,
            _dir
        );


    // ==============================
    // MUZZLE OFFSET
    // ==============================

    var _mx =
        e.enemy_muzzle_x;

    var _my =
        e.enemy_muzzle_y;


    if (_dir > 90 && _dir < 270)
    {
        _my *= -1;
    }


    // ==============================
    // MUZZLE WORLD POSITION
    // ==============================

    var _muzzle_x =
        _gun_x
        + lengthdir_x(
            _mx,
            _dir
        )
        + lengthdir_x(
            _my,
            _dir + 90
        );

    var _muzzle_y =
        _gun_y
        + lengthdir_y(
            _mx,
            _dir
        )
        + lengthdir_y(
            _my,
            _dir + 90
        );


    // ==============================
    // FIRE EXISTING BULLET FUNCTION
    // ==============================

    raid_enemy_fire_bullet(
        _muzzle_x,
        _muzzle_y,
        _dir,
        _speed,
        _damage
    );


    // ==============================
    // RECOIL
    // ==============================

    e.enemy_gun_recoil = 3;

    return e;
}