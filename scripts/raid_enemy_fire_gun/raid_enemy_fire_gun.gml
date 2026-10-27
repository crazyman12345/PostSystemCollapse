function raid_enemy_fire_gun(_enemy, _dir, _speed, _damage, _projectile_config = undefined)
{
    var e = _enemy;

    var _s = variable_struct_exists(_enemy, "size_multiplier")
        ? _enemy.size_multiplier
        : 1;

    // ==============================
    // GUN PIVOT
    // ==============================

    var _pivot_x = e.enemy_x;
    var _pivot_y = e.enemy_y - (18 * _s) + (e.enemy_gun_y * _s);


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

    var _projectile_count = is_struct(_projectile_config) && variable_struct_exists(_projectile_config, "count")
        ? max(1, floor(_projectile_config.count))
        : 1;
    var _projectile_spread = is_struct(_projectile_config) && variable_struct_exists(_projectile_config, "spread")
        ? _projectile_config.spread
        : 0;

    for (var _projectile_index = 0; _projectile_index < _projectile_count; _projectile_index++)
    {
        var _spread_position = _projectile_count > 1
            ? _projectile_index / (_projectile_count - 1) - 0.5
            : 0;

        raid_enemy_fire_bullet(
            _muzzle_x,
            _muzzle_y,
            _dir + _projectile_spread * _spread_position,
            _speed,
            _damage,
            true,
            make_color_rgb(255, 70, 45),
            20,
            0.15,
            true,
            1.25,
            _projectile_config
        );
    }

    var _muzzle_flash_radius = raid_muzzle_flash_radius;
    var _muzzle_flash_lifetime = raid_muzzle_flash_lifetime;

    if (variable_struct_exists(e.weapon, "pellet_count") && e.weapon.pellet_count > 1)
    {
        _muzzle_flash_radius = raid_muzzle_flash_shotgun_radius;
        _muzzle_flash_lifetime = raid_muzzle_flash_shotgun_lifetime;
    }
    else if (array_length(e.weapon.fire_modes) > 1)
    {
        _muzzle_flash_radius = raid_muzzle_flash_auto_radius;
        _muzzle_flash_lifetime = raid_muzzle_flash_auto_lifetime;
    }

    e.enemy_muzzle_flash_light = raid_refresh_muzzle_flash_light(
        e.enemy_muzzle_flash_light,
        _muzzle_x,
        _muzzle_y,
        _muzzle_flash_radius * _s,
        _muzzle_flash_lifetime
    );
    e.enemy_muzzle_flash_light.flash_scale = random_range(0.8, 1.2);
    e.enemy_muzzle_flash_light.flash_rotation = random_range(-12, 12);
    e.enemy_muzzle_flash_light.flash_mirror = choose(-1, 1);
    e.enemy_muzzle_flash_light.flash_subimage = irandom(sprite_get_number(spr_muzzle_flash) - 1);


    // ==============================
    // RECOIL
    // ==============================

    e.enemy_gun_recoil = 3;
    var _shot_sound = is_struct(_projectile_config) && variable_struct_exists(_projectile_config, "sound")
        ? _projectile_config.sound
        : enemy_shot_sound;
    audio_play_sound(_shot_sound, 0, false);
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
