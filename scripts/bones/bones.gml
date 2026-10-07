function bones(_enemy)
{
    var e = _enemy;
    var _phase2 = e.boss_phase == 2;

    if (
        e.boss_phase == 1
        && e.enemy_state != RaidEnemyState.PHASE_TRANSITION
        && e.enemy_hp <= e.enemy_max_hp * 0.5
    )
    {
        e.enemy_state = RaidEnemyState.PHASE_TRANSITION;
        e.enemy_invulnerable = true;
        e.boss_transition_stage = 0;
        e.boss_transition_timer = 0;
        e.boss_transition_dialogue = "";
        e.boss_transition_transformed = false;
    }

    if (e.enemy_state == RaidEnemyState.PHASE_TRANSITION)
    {
        var _center_x = (raid_room_x1 + raid_room_x2) * 0.5;
        var _center_y = (raid_room_y1 + raid_room_y2) * 0.5;
        var _transition_fps = game_get_speed(gamespeed_fps);

        switch (e.boss_transition_stage)
        {
            case 0:
                var _center_dist = point_distance(e.enemy_x, e.enemy_y, _center_x, _center_y);
                var _move_speed = e.boss_pacing_phase1.shockwave_move_speed;

                if (_center_dist > _move_speed)
                {
                    var _center_dir = point_direction(e.enemy_x, e.enemy_y, _center_x, _center_y);
                    e.enemy_x += lengthdir_x(_move_speed, _center_dir);
                    e.enemy_y += lengthdir_y(_move_speed, _center_dir);
                }
                else
                {
                    e.enemy_x = _center_x;
                    e.enemy_y = _center_y;
                    e.boss_transition_stage = 1;
                    e.boss_transition_timer = round(_transition_fps * 0.5);
                }
                break;

            case 1:
                e.boss_transition_timer--;
                if (e.boss_transition_timer <= 0)
                {
                    e.boss_transition_dialogue = "Okay, now you really pissed me off!";
                    e.boss_transition_stage = 2;
                    e.boss_transition_timer = round(_transition_fps * 1.75);
                }
                break;

            case 2:
                e.boss_transition_timer--;

                if (!e.boss_transition_transformed && e.boss_transition_timer <= round(_transition_fps * 0.25))
                {
                    e.enemy_tint = make_color_rgb(255, 90, 90);
                    e.size_multiplier *= 1.1;
                    e.boss_transition_transformed = true;
                }

                if (e.boss_transition_timer <= 0)
                {
                    e.boss_phase = 2;
                    e.enemy_invulnerable = false;
                    e.boss_transition_dialogue = "";
                    e.enemy_state = RaidEnemyState.BOSS_ATTACK;
                    e.boss_attack = BossAttackType.BONES_ATTACK_SHOOT_DASH_SHOOT;
                    e.boss_attack_state = BossAttackState.RECOVERY;
                    e.boss_attack_timer = e.boss_pacing_phase2.attack_recovery;
                    e.boss_attack_repeat_count = 3;
                }
                break;
        }

        return e;
    }

    var _pacing = _phase2 ? e.boss_pacing_phase2 : e.boss_pacing_phase1;

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
                        e.boss_attack_timer = _pacing.walkdown_windup;
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
                    e.boss_attack_timer = _pacing.attack_windup;
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
                        e.boss_attack_timer = _pacing.burst_shot_interval;
                    }

                    if (e.boss_shots_fired >= 3 && e.boss_attack_timer <= 0)
                    {
                        e.boss_attack_timer = _pacing.pre_dash_windup;
                        e.boss_attack_state = BossAttackState.PRE_DASH;
                    }
                    break;

                case BossAttackState.PRE_DASH:
                    e.boss_attack_timer--;
                    if (e.boss_attack_timer <= 0)
                    {
                        e = bones_pick_dash_position(e);
                        e.boss_attack_state = BossAttackState.DASH;
                        e.boss_attack_timer = _pacing.dash_duration;
                    }
                    break;

                case BossAttackState.DASH:
                    var _dash_dist = point_distance(e.enemy_x, e.enemy_y, e.target_x, e.target_y);
                    var _dash_dir = point_direction(e.enemy_x, e.enemy_y, e.target_x, e.target_y);
                    e.enemy_x = clamp(e.enemy_x + lengthdir_x(_pacing.dash_speed, _dash_dir), raid_room_x1 + e.enemy_radius, raid_room_x2 - e.enemy_radius);
                    e.enemy_y = clamp(e.enemy_y + lengthdir_y(_pacing.dash_speed, _dash_dir), raid_room_y1 + e.enemy_radius, raid_room_y2 - e.enemy_radius);
                    e.boss_attack_timer--;

                    if (_dash_dist <= _pacing.dash_speed + 4 || e.boss_attack_timer <= 0)
                    {
                        e.boss_attack_timer = _pacing.post_dash_windup;
                        e.boss_attack_state = BossAttackState.POST_DASH;
                    }
                    break;

                case BossAttackState.POST_DASH:
                    e.boss_attack_timer--;
                    if (e.boss_attack_timer <= 0)
                    {
                        e.boss_shots_fired = 0;
                        e.boss_attack_state = BossAttackState.SHOOT_SECOND;
                        e.boss_attack_timer = _pacing.burst_shot_interval;
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
                        e.boss_attack_timer = _pacing.burst_shot_interval;
                    }

                    if (e.boss_shots_fired >= 3 && e.boss_attack_timer <= 0)
                    {
                        e.boss_attack_repeat_count++;
                        if (e.boss_attack_repeat_count < 3)
                        {
                            e.boss_attack_timer = _pacing.attack_recovery;
                            e.boss_attack_state = BossAttackState.RECOVERY;
                        }
                        else
                        {
                            e.boss_attack_timer = _pacing.attack_recovery;
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
                        e.enemy_x + lengthdir_x(_pacing.walkdown_speed, _walkdown_dir),
                        raid_room_x1 + e.enemy_radius,
                        raid_room_x2 - e.enemy_radius
                    );
                    e.enemy_y = clamp(
                        e.enemy_y + lengthdir_y(_pacing.walkdown_speed, _walkdown_dir),
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
                        e.boss_attack_timer = _pacing.walkdown_shot_interval;
                    }

                    if (e.boss_shots_fired >= _walkdown_shots && e.boss_attack_timer <= 0)
                    {
                        e.boss_attack_timer = _pacing.attack_recovery;
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

                    if (_center_dist > 10)
                    {
                        var _center_dir = point_direction(e.enemy_x, e.enemy_y, _center_x, _center_y);
                        e.enemy_x += lengthdir_x(min(_pacing.shockwave_move_speed, _center_dist), _center_dir);
                        e.enemy_y += lengthdir_y(min(_pacing.shockwave_move_speed, _center_dist), _center_dir);
                    }
                    else
                    {
                        e.enemy_x = _center_x;
                        e.enemy_y = _center_y;
                        e.boss_attack_timer = _pacing.shockwave_windup;
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
                        e.boss_attack_timer = _pacing.attack_recovery;
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
