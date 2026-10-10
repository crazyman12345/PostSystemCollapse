function raid_enemy_fire_gun(_enemy, _dir, _speed, _damage)
{
    var e = _enemy;

    var _s = variable_struct_exists(_enemy, "size_multiplier")
        ? _enemy.size_multiplier
        : 1;

    // ==============================
    // GUN PIVOT
    // ==============================

    var _pivot_x = e.enemy_x;
    var _pivot_y = e.enemy_y - (18 * _s);


    // ==============================
    // GUN POSITION
    // ==============================

    var _gun_offset =
        (e.enemy_gun_offset * _s)
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
        e.enemy_muzzle_x * _s;

    var _my =
        e.enemy_muzzle_y * _s;


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
	audio_play_sound(enemy_shot_sound,0,false);
    return e;
}

function raid_predict_player_aim(_shooter_x, _shooter_y, _bullet_speed, _lead_strength)
{
    var _travel_time = point_distance(
        _shooter_x,
        _shooter_y,
        raid_player_x,
        raid_player_y
    ) / _bullet_speed;

    var _predicted_x = raid_player_x + raid_player_smoothed_velocity_x * _travel_time * _lead_strength;
    var _predicted_y = raid_player_y + raid_player_smoothed_velocity_y * _travel_time * _lead_strength;

    return point_direction(_shooter_x, _shooter_y, _predicted_x, _predicted_y);
}

function raid_smooth_aim_direction(_current_direction, _target_direction)
{
    var _aim_smoothing = 1 - power(1 - 0.1, frame_scale);
    var _angle_delta = ((_target_direction - _current_direction + 540) mod 360) - 180;

    return (_current_direction + _angle_delta * _aim_smoothing + 360) mod 360;
}
