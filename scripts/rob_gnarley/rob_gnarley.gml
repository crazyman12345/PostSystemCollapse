function rob_gnarley(_enemy)
{
    var e = _enemy;
    var _bullet_speed = 2.4;
    var _aim_direction = raid_predict_player_aim(
        e.enemy_x,
        e.enemy_y - 10,
        _bullet_speed * 1.15,
        e.lead_strength
    );
    e.enemy_gun_angle = raid_smooth_aim_direction(e.enemy_gun_angle, _aim_direction);

    e.shot_timer -= frame_scale;
    if (e.shot_timer <= 0)
    {
        e = raid_enemy_fire_gun(e, e.enemy_gun_angle, _bullet_speed, 10);
        e.shot_timer += randomize_enemy_timer(75, 0.2);
    }

    var _target_distance = point_distance(e.enemy_x, e.enemy_y, e.target_x, e.target_y);
    if (_target_distance <= 4)
    {
        e = raid_enemy_pick_random_position(e);
    }
    else
    {
        var _move_direction = point_direction(e.enemy_x, e.enemy_y, e.target_x, e.target_y);
        e.enemy_x += lengthdir_x(e.enemy_speed * frame_scale, _move_direction);
        e.enemy_y += lengthdir_y(e.enemy_speed * frame_scale, _move_direction);
    }

    return e;
}
