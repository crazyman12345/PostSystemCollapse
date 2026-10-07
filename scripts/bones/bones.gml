function bones(_enemy)
{
    var e = _enemy;
    var _phase2 = e.enemy_hp < e.enemy_max_hp * 0.5;
    e.boss_phase = _phase2 ? 2 : 1;

    var _delay_scale = _phase2 ? 0.6 : 1.0;
    var _dash_speed = _phase2 ? 9 : e.boss_dash_speed;

    switch (e.boss_attack)
    {
        case BossAttackType.BONES_ATTACK_SHOOT_DASH_SHOOT:
        {
            switch (e.boss_attack_state)
            {
                case BossAttackState.SELECT:
                    var _attack_roll = irandom(2);
                    if (_attack_roll == e.boss_last_attack)
                        _attack_roll = (_attack_roll + 1 + irandom(1)) mod 3;

                    e.boss_last_attack = _attack_roll;
                    if (_attack_roll < 1)
                    {
                        e.boss_attack = BossAttackType.BOSS_ATTACK_ROOM_SHOCKWAVE;
                        e.boss_attack_state = BossAttackState.SHOCKWAVE_MOVE;
                    }
                    else if (_attack_roll < 2)
                    {
                        e.boss_attack = BossAttackType.BOSS_ATTACK_WALKDOWN;
                        e.boss_attack_state = BossAttackState.WALKDOWN;
                        e.boss_attack_timer = 1;
                        e.boss_shots_fired = 0;
                    }
                    else
                    {
                        e.boss_attack_repeat_count = 0;
                        e.boss_attack_state = BossAttackState.AIM;
                        e.boss_attack_timer = 0;
                    }
                    break;

                case BossAttackState.AIM:
                    e.boss_attack_timer = max(1, round(18 * _delay_scale));
                    e.boss_shots_fired = 0;
                    e.boss_attack_state = BossAttackState.SHOOT_FIRST;
                    break;

                case BossAttackState.SHOOT_FIRST:
                    e.boss_attack_timer--;
                    if (e.boss_attack_timer <= 0 && e.boss_shots_fired < 3)
                    {
                        e.enemy_gun_angle = point_direction(
                            e.enemy_x, e.enemy_y - 10,
                            raid_player_x, raid_player_y - 12
                        );
                        e = raid_enemy_fire_gun(e, e.enemy_gun_angle, 2.5, 10);
                        e.boss_shots_fired++;
                        e.boss_attack_timer = max(1, round(8 * _delay_scale));
                    }

                    if (e.boss_shots_fired >= 3 && e.boss_attack_timer <= 0)
                    {
                        e.boss_attack_timer = max(1, round(20 * _delay_scale));
                        e.boss_attack_state = BossAttackState.PRE_DASH;
                    }
                    break;

                case BossAttackState.PRE_DASH:
                    e.boss_attack_timer--;
                    if (e.boss_attack_timer <= 0)
                    {
                        e = bones_pick_dash_position(e);
                        e.boss_attack_state = BossAttackState.DASH;
                        e.boss_attack_timer = 18;
                    }
                    break;

                case BossAttackState.DASH:
                    var _dash_dist = point_distance(e.enemy_x, e.enemy_y, e.target_x, e.target_y);
                    var _dash_dir = point_direction(e.enemy_x, e.enemy_y, e.target_x, e.target_y);
                    e.enemy_x = clamp(e.enemy_x + lengthdir_x(_dash_speed, _dash_dir), raid_room_x1 + e.enemy_radius, raid_room_x2 - e.enemy_radius);
                    e.enemy_y = clamp(e.enemy_y + lengthdir_y(_dash_speed, _dash_dir), raid_room_y1 + e.enemy_radius, raid_room_y2 - e.enemy_radius);
                    e.boss_attack_timer--;

                    if (_dash_dist <= _dash_speed + 4 || e.boss_attack_timer <= 0)
                    {
                        e.boss_attack_timer = max(1, round(14 * _delay_scale));
                        e.boss_attack_state = BossAttackState.POST_DASH;
                    }
                    break;

                case BossAttackState.POST_DASH:
                    e.boss_attack_timer--;
                    if (e.boss_attack_timer <= 0)
                    {
                        e.boss_shots_fired = 0;
                        e.boss_attack_state = BossAttackState.SHOOT_SECOND;
                        e.boss_attack_timer = max(1, round(8 * _delay_scale));
                    }
                    break;

                case BossAttackState.SHOOT_SECOND:
                    e.boss_attack_timer--;
                    if (e.boss_attack_timer <= 0 && e.boss_shots_fired < 3)
                    {
                        e.enemy_gun_angle = point_direction(
                            e.enemy_x, e.enemy_y - 10,
                            raid_player_x, raid_player_y - 12
                        );
                        e = raid_enemy_fire_gun(e, e.enemy_gun_angle, 2.5, 10);
                        e.boss_shots_fired++;
                        e.boss_attack_timer = max(1, round(8 * _delay_scale));
                    }

                    if (e.boss_shots_fired >= 3 && e.boss_attack_timer <= 0)
                    {
                        e.boss_attack_repeat_count++;
                        if (e.boss_attack_repeat_count < 3)
                        {
                            e.boss_attack_timer = max(1, round(35 * 1.5 * _delay_scale));
                            e.boss_attack_state = BossAttackState.RECOVERY;
                        }
                        else
                        {
                            e.boss_attack_timer = max(1, round(35 * _delay_scale));
                            e.boss_attack_state = BossAttackState.RECOVERY;
                        }
                    }
                    break;

                case BossAttackState.RECOVERY:
                    e.boss_attack_timer--;
                    if (e.boss_attack_timer <= 0)
                    {
                        if (e.boss_attack_repeat_count < 3)
                            e.boss_attack_state = BossAttackState.AIM;
                        else
                            e.boss_attack_state = BossAttackState.SELECT;
                    }
                    break;
            }
        }
        break;

        case BossAttackType.BOSS_ATTACK_WALKDOWN:
        {
            var _walkdown_speed = _phase2 ? 1.2 : 0.95;
            var _walkdown_delay = _phase2 ? 11 : 16;
            var _walkdown_shots = 18;

            switch (e.boss_attack_state)
            {
                case BossAttackState.WALKDOWN:
                    var _walkdown_dir = point_direction(
                        e.enemy_x,
                        e.enemy_y,
                        raid_player_x,
                        raid_player_y
                    );

                    e.enemy_x = clamp(
                        e.enemy_x + lengthdir_x(_walkdown_speed, _walkdown_dir),
                        raid_room_x1 + e.enemy_radius,
                        raid_room_x2 - e.enemy_radius
                    );
                    e.enemy_y = clamp(
                        e.enemy_y + lengthdir_y(_walkdown_speed, _walkdown_dir),
                        raid_room_y1 + e.enemy_radius,
                        raid_room_y2 - e.enemy_radius
                    );

                    e.boss_attack_timer--;
                    if (e.boss_attack_timer <= 0 && e.boss_shots_fired < _walkdown_shots)
                    {
                        e.enemy_gun_angle = point_direction(
                            e.enemy_x,
                            e.enemy_y - 10,
                            raid_player_x,
                            raid_player_y - 12
                        );
                        e = raid_enemy_fire_gun(e, e.enemy_gun_angle, 2.5, 10);
                        e.boss_shots_fired++;
                        e.boss_attack_timer = _walkdown_delay;
                    }

                    if (e.boss_shots_fired >= _walkdown_shots && e.boss_attack_timer <= 0)
                    {
                        e.boss_attack_timer = _phase2 ? 16 : 24;
                        e.boss_attack_state = BossAttackState.RECOVERY;
                    }
                    break;

                case BossAttackState.RECOVERY:
                    e.boss_attack_timer--;
                    if (e.boss_attack_timer <= 0)
                    {
                        e.boss_attack = BossAttackType.BONES_ATTACK_SHOOT_DASH_SHOOT;
                        e.boss_attack_state = BossAttackState.SELECT;
                    }
                    break;
            }
        }
        break;

        case BossAttackType.BOSS_ATTACK_ROOM_SHOCKWAVE:
        {
            var _center_x = (raid_room_x1 + raid_room_x2) * 0.5;
            var _center_y = (raid_room_y1 + raid_room_y2) * 0.5;

            switch (e.boss_attack_state)
            {
                case BossAttackState.SHOCKWAVE_MOVE:
                    var _center_dist = point_distance(e.enemy_x, e.enemy_y, _center_x, _center_y);
                    var _move_speed = _phase2 ? 4.5 : 3.5;

                    if (_center_dist > 10)
                    {
                        var _center_dir = point_direction(e.enemy_x, e.enemy_y, _center_x, _center_y);
                        e.enemy_x += lengthdir_x(min(_move_speed, _center_dist), _center_dir);
                        e.enemy_y += lengthdir_y(min(_move_speed, _center_dist), _center_dir);
                    }
                    else
                    {
                        e.enemy_x = _center_x;
                        e.enemy_y = _center_y;
                        e.boss_attack_timer = _phase2 ? 40 : 70;
                        ring_attack_create(
                            e.enemy_x,
                            e.enemy_y,
                            e.boss_attack_timer,
                            point_distance(_center_x, _center_y, raid_room_x2 * 0.95, raid_room_y2 * 0.95),
                            _phase2 ? 7 : 5,
                            11,
                            10,
                            make_color_rgb(255, 90, 90),
                            make_color_rgb(120, 0, 0)
                        );
                        e.boss_attack_state = BossAttackState.SHOCKWAVE_WINDUP;
                    }
                    break;

                case BossAttackState.SHOCKWAVE_WINDUP:
                    e.boss_attack_timer--;
                    if (e.boss_attack_timer <= 0)
                    {
                        e.boss_attack_timer = _phase2 ? 35 : 55;
                        e.boss_attack_state = BossAttackState.SHOCKWAVE_RECOVERY;
                    }
                    break;

                case BossAttackState.SHOCKWAVE_RECOVERY:
                    e.boss_attack_timer--;
                    if (e.boss_attack_timer <= 0)
                    {
                        e.boss_attack = BossAttackType.BONES_ATTACK_SHOOT_DASH_SHOOT;
                        e.boss_attack_state = BossAttackState.SELECT;
                    }
                    break;
            }
        }
        break;
    }

    return e;
}
