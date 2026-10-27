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
        e.boss_transition_character_count = 0;
        e.boss_transition_transformed = false;
        e.boss_transition_shake_started = false;
    }

    if (e.enemy_state == RaidEnemyState.PHASE_TRANSITION)
    {
        var _center_x = (raid_room_x1 + raid_room_x2) * 0.5;
        var _center_y = (raid_room_y1 + raid_room_y2) * 0.5;

        switch (e.boss_transition_stage)
        {
            case 0:
                var _center_dist = point_distance(e.enemy_x, e.enemy_y, _center_x, _center_y);
                var _move_speed = e.boss_pacing_phase1.shockwave_move_speed;

                var _move_step = min(_move_speed * frame_scale, _center_dist);

                if (_center_dist > _move_step)
                {
                    var _center_dir = point_direction(e.enemy_x, e.enemy_y, _center_x, _center_y);
                    e.enemy_x += lengthdir_x(_move_step, _center_dir);
                    e.enemy_y += lengthdir_y(_move_step, _center_dir);
                }
                else
                {
                    e.enemy_x = _center_x;
                    e.enemy_y = _center_y;
                    e.boss_transition_stage = 1;
                    e.boss_transition_timer = 30;
                }
                break;

            case 1:
                e.boss_transition_timer -= frame_scale;
                if (e.boss_transition_timer <= 0)
                {
                    e.boss_transition_stage = 2;
                    e.boss_transition_timer = 55;
                }
                break;

            case 2:
                e.boss_transition_timer -= frame_scale;

                if (!e.boss_transition_shake_started && e.boss_transition_timer <= 55)
                {
                    raid_camera_shake_duration = 40;
                    raid_camera_shake_timer = raid_camera_shake_duration;
                    raid_camera_shake_strength = 6;
                    e.boss_transition_shake_started = true;
                }

                if (!e.boss_transition_transformed && e.boss_transition_timer <= 15)
                {
                    e.enemy_tint = make_color_rgb(255, 150, 150);
                    e.size_multiplier *= 1.1;
                    e.boss_transition_transformed = true;
                    smoke_create(e.enemy_x - 40, e.enemy_y - 12, e.enemy_x + 40, e.enemy_y + 12, 20);
                    audio_play_sound(smoke_sound, 0, false);
                    e.boss_transition_stage = 3;
                    e.boss_transition_character_count = 0;
                }
                break;

            case 3:
                var _transition_line = "Okay, now you really pissed me off!";
                e.boss_transition_character_count = min(
                    string_length(_transition_line),
                    e.boss_transition_character_count + 0.5 * frame_scale
                );
                e.boss_transition_dialogue = string_copy(_transition_line, 1, floor(e.boss_transition_character_count));

                if (e.boss_transition_character_count >= string_length(_transition_line))
                {
                    e.boss_transition_stage = 4;
                    e.boss_transition_timer = 90;
                }
                break;

            case 4:
                e.boss_transition_timer -= frame_scale;
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

    var _bullet_speed = 2.5;
    var _predicted_direction = raid_predict_player_aim(e.enemy_x, e.enemy_y - 10, _bullet_speed * 1.15, e.lead_strength);
    e.enemy_gun_angle = raid_smooth_aim_direction(e.enemy_gun_angle, _predicted_direction);

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
                    e.boss_attack_timer -= frame_scale;
                    if (e.boss_attack_timer <= 0 && e.boss_shots_fired < 3)
                    {
                        e = raid_enemy_fire_gun(e, e.enemy_gun_angle, _bullet_speed, 10);
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
                    e.boss_attack_timer -= frame_scale;
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
                    var _dash_bbox = raid_enemy_get_collision_bbox(e);
                    var _dash_step = min(frame_scale, e.boss_attack_timer);
                    var _dash_move = _pacing.dash_speed * _dash_step;
                    e.enemy_x = clamp(e.enemy_x + lengthdir_x(_dash_move, _dash_dir), raid_room_x1 + e.enemy_x - _dash_bbox.left, raid_room_x2 - (_dash_bbox.right - e.enemy_x));
                    e.enemy_y = clamp(e.enemy_y + lengthdir_y(_dash_move, _dash_dir), raid_room_y1 + e.enemy_y - _dash_bbox.top, raid_room_y2 - (_dash_bbox.bottom - e.enemy_y));
                    e.boss_attack_timer -= frame_scale;

                    if (_dash_dist <= _dash_move + 4 || e.boss_attack_timer <= 0)
                    {
                        e.boss_attack_timer = _pacing.post_dash_windup;
                        e.boss_attack_state = BossAttackState.POST_DASH;
                    }
                    break;

                case BossAttackState.POST_DASH:
                    e.boss_attack_timer -= frame_scale;
                    if (e.boss_attack_timer <= 0)
                    {
                        e.boss_shots_fired = 0;
                        e.boss_attack_state = BossAttackState.SHOOT_SECOND;
                        e.boss_attack_timer = _pacing.burst_shot_interval;
                    }
                    break;

                case BossAttackState.SHOOT_SECOND:
                    e.boss_attack_timer -= frame_scale;
                    if (e.boss_attack_timer <= 0 && e.boss_shots_fired < 3)
                    {
                        e = raid_enemy_fire_gun(e, e.enemy_gun_angle, _bullet_speed, 10);
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
                    e.boss_attack_timer -= frame_scale;
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

                    var _walkdown_bbox = raid_enemy_get_collision_bbox(e);
                    e.enemy_x = clamp(e.enemy_x + lengthdir_x(_pacing.walkdown_speed * frame_scale, _walkdown_dir), raid_room_x1 + e.enemy_x - _walkdown_bbox.left, raid_room_x2 - (_walkdown_bbox.right - e.enemy_x));
                    e.enemy_y = clamp(e.enemy_y + lengthdir_y(_pacing.walkdown_speed * frame_scale, _walkdown_dir), raid_room_y1 + e.enemy_y - _walkdown_bbox.top, raid_room_y2 - (_walkdown_bbox.bottom - e.enemy_y));

                    e.boss_attack_timer -= frame_scale;
                    if (e.boss_attack_timer <= 0 && e.boss_shots_fired < _walkdown_shots)
                    {
                        e = raid_enemy_fire_gun(e, e.enemy_gun_angle, _bullet_speed, 10);
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
                    e.boss_attack_timer -= frame_scale;
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
                        var _center_step = min(_pacing.shockwave_move_speed * frame_scale, _center_dist);
                        e.enemy_x += lengthdir_x(_center_step, _center_dir);
                        e.enemy_y += lengthdir_y(_center_step, _center_dir);
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
                            make_color_rgb(120, 70, 20)
                        );
                        e.boss_attack_state = BossAttackState.SHOCKWAVE_WINDUP;
                    }
                    break;

                case BossAttackState.SHOCKWAVE_WINDUP:
                    e.boss_attack_timer -= frame_scale;
                    if (e.boss_attack_timer <= 0)
                    {
                        e.boss_attack_timer = _pacing.attack_recovery;
                        e.boss_attack_state = BossAttackState.SHOCKWAVE_RECOVERY;
                    }
                    break;

                case BossAttackState.SHOCKWAVE_RECOVERY:
                    e.boss_attack_timer -= frame_scale;
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
