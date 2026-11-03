function rob_gnarley(_enemy)
{
    var e = _enemy;
    var _bullet_speed = 2.7;
    var _center_x = (raid_room_x1 + raid_room_x2) * 0.5;
    var _center_y = (raid_room_y1 + raid_room_y2) * 0.5;
    var _aim_direction = raid_predict_player_aim(e.enemy_x, e.enemy_y - 10, _bullet_speed * 1.15, e.lead_strength);
    var _phase_pace = e.boss_phase == 2 ? 1.3 : 1;
    var _phase_timer_scale = 1 / _phase_pace;

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
        e.rob_turrets = [];
        raid_bullets = [];
        raid_enemy_bullets = [];
    }

    if (e.enemy_state == RaidEnemyState.PHASE_TRANSITION)
    {
        switch (e.boss_transition_stage)
        {
            case 0:
                var _center_distance = point_distance(e.enemy_x, e.enemy_y, _center_x, _center_y);
                var _center_step = min(2 * frame_scale, _center_distance);

                if (_center_distance > _center_step)
                {
                    var _center_direction = point_direction(e.enemy_x, e.enemy_y, _center_x, _center_y);
                    e.enemy_x += lengthdir_x(_center_step, _center_direction);
                    e.enemy_y += lengthdir_y(_center_step, _center_direction);
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
                var _transition_line = "Ya tink dat was enough? Now tings get gnarly!";
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
                    e.rob_attack_state = 90;
                    e.rob_attack_timer = randomize_enemy_timer(55 / 1.3, 0.1);
                }
                break;
        }

        return e;
    }

    // Turrets continue winding up after Rob has moved on to his next attack.
    for (var _turret_index = array_length(e.rob_turrets) - 1; _turret_index >= 0; _turret_index--)
    {
        var _turret = e.rob_turrets[_turret_index];
        _turret.aim_direction = point_direction(_turret.x, _turret.y, raid_player_x, raid_player_y);
        _turret.timer -= frame_scale;

        if (_turret.timer <= 0)
        {
            raid_enemy_fire_bullet(_turret.x, _turret.y - 5, _turret.aim_direction, 3.2, 10);
            audio_play_sound(enemy_shot_sound, 0, false);
            array_delete(e.rob_turrets, _turret_index, 1);
        }
        else
        {
            e.rob_turrets[_turret_index] = _turret;
        }
    }

    if (e.rob_attack_state != 21)
        e.enemy_gun_angle = raid_smooth_aim_direction(e.enemy_gun_angle, _aim_direction, 0.3);

    switch (e.rob_attack_state)
    {
        // Pick one of the three attacks without immediately repeating one.
        case 0:
        {
            var _attack = irandom(2);
            if (_attack == e.rob_last_attack)
                _attack = (_attack + 1 + irandom(1)) mod 3;

            e.rob_attack = _attack;
            e.rob_last_attack = _attack;
            e.rob_shots_fired = 0;

            if (_attack == 0)
            {
                e.rob_dash_count = 0;
                e.rob_dash_direction = point_direction(e.enemy_x, e.enemy_y, raid_player_x, raid_player_y);
                e.rob_attack_state = 10;
                e.rob_attack_timer = randomize_enemy_timer(30 * _phase_timer_scale, 0.1);
                e.rob_dash_windup_total = e.rob_attack_timer;
            }
            else if (_attack == 1)
            {
                e.rob_attack_state = 20;
            }
            else
            {
                e.rob_attack_state = 30;
                e.rob_orbit_angle = point_direction(_center_x, _center_y, e.enemy_x, e.enemy_y);
                e.rob_orbit_progress = 0;
                e.rob_orbit_target = random_range(648, 792);
            }
        }
        break;

        // ATTACK 1: Wind up, rush into a wall, then immediately fire five shots.
        case 10:
        {
            e.rob_attack_timer -= frame_scale;
            if (e.rob_attack_timer <= 0)
            {
                e.rob_attack_state = 11;
            }
        }
        break;

        case 11:
        {
            var _next_x = e.enemy_x + lengthdir_x(e.rob_dash_speed * _phase_pace * frame_scale, e.rob_dash_direction);
            var _next_y = e.enemy_y + lengthdir_y(e.rob_dash_speed * _phase_pace * frame_scale, e.rob_dash_direction);
            var _hit_wall = false;
            var _next_bbox = raid_enemy_get_collision_bbox_at(e, _next_x, _next_y);

            if (_next_bbox.left <= raid_room_x1)
            {
                _next_x += raid_room_x1 - _next_bbox.left;
                _hit_wall = true;
            }

            _next_bbox = raid_enemy_get_collision_bbox_at(e, _next_x, _next_y);
            if (_next_bbox.right >= raid_room_x2)
            {
                _next_x -= _next_bbox.right - raid_room_x2;
                _hit_wall = true;
            }

            _next_bbox = raid_enemy_get_collision_bbox_at(e, _next_x, _next_y);
            if (_next_bbox.top <= raid_room_y1)
            {
                _next_y += raid_room_y1 - _next_bbox.top;
                _hit_wall = true;
            }

            _next_bbox = raid_enemy_get_collision_bbox_at(e, _next_x, _next_y);
            if (_next_bbox.bottom >= raid_room_y2)
            {
                _next_y -= _next_bbox.bottom - raid_room_y2;
                _hit_wall = true;
            }

            e.enemy_x = _next_x;
            e.enemy_y = _next_y;

            if (_hit_wall)
            {
                smoke_create(e.enemy_x - 30, e.enemy_y - 12, e.enemy_x + 30, e.enemy_y + 8, 12);
                var _wall_slam_sound = audio_play_sound(smoke_sound, 0, false);
                audio_sound_pitch(_wall_slam_sound, random_range(0.72, 0.82));
                raid_camera_shake_duration = 16;
                raid_camera_shake_timer = raid_camera_shake_duration;
                raid_camera_shake_strength = 4;

                e.rob_dash_count++;
                e.enemy_gun_angle = point_direction(e.enemy_x, e.enemy_y - 10, raid_player_x, raid_player_y);
                e = raid_enemy_fire_gun(e, e.enemy_gun_angle, _bullet_speed, 10);
                e.rob_shots_fired = 1;
                e.rob_attack_timer = randomize_enemy_timer(6 * _phase_timer_scale, 0.1);
                e.rob_attack_state = 12;
            }
        }
        break;

        case 12:
        {
            e.rob_attack_timer -= frame_scale;
            if (e.rob_attack_timer <= 0 && e.rob_shots_fired < 5)
            {
                e.enemy_gun_angle = point_direction(e.enemy_x, e.enemy_y - 10, raid_player_x, raid_player_y);
                e = raid_enemy_fire_gun(e, e.enemy_gun_angle, _bullet_speed, 10);
                e.rob_shots_fired++;
                e.rob_attack_timer += randomize_enemy_timer(6 * _phase_timer_scale, 0.1);
            }

            if (e.rob_shots_fired >= 5 && e.rob_attack_timer <= 0)
            {
                if (e.rob_dash_count < 4)
                {
                    e.rob_dash_direction = point_direction(e.enemy_x, e.enemy_y, raid_player_x, raid_player_y);
                    e.rob_shots_fired = 0;
                    e.rob_attack_timer = randomize_enemy_timer(30 * _phase_timer_scale, 0.1);
                    e.rob_dash_windup_total = e.rob_attack_timer;
                    e.rob_attack_state = 10;
                }
                else
                {
                    e.rob_attack_timer = randomize_enemy_timer(55 * _phase_timer_scale, 0.1);
                    e.rob_attack_state = 90;
                }
            }
        }
        break;

        // ATTACK 2: Move to the middle and fire rotating pairs in opposite directions.
        case 20:
        {
            var _center_distance = point_distance(e.enemy_x, e.enemy_y, _center_x, _center_y);
            var _center_step = min(e.enemy_speed * 1.5 * _phase_pace * frame_scale, _center_distance);

            if (_center_distance > 3)
            {
                var _center_direction = point_direction(e.enemy_x, e.enemy_y, _center_x, _center_y);
                e.enemy_x += lengthdir_x(_center_step, _center_direction);
                e.enemy_y += lengthdir_y(_center_step, _center_direction);
            }
            else
            {
                e.enemy_x = _center_x;
                e.enemy_y = _center_y;
                e.rob_spin_direction = point_direction(e.enemy_x, e.enemy_y, raid_player_x, raid_player_y);
                e.rob_shots_fired = 0;
                e.rob_attack_timer = 0;
                e.rob_attack_state = 21;
            }
        }
        break;

        case 21:
        {
            e.rob_spin_direction = (e.rob_spin_direction + 1.75 * _phase_pace * frame_scale) mod 360;
            e.enemy_gun_angle = e.rob_spin_direction;
            e.rob_attack_timer -= frame_scale;

            if (e.rob_attack_timer <= 0 && e.rob_shots_fired < 20)
            {
                e = raid_enemy_fire_gun(e, e.rob_spin_direction, 2.4, 10);
                e = raid_enemy_fire_gun(e, e.rob_spin_direction + 180, 2.4, 10);
                e.rob_shots_fired++;
                e.rob_attack_timer += randomize_enemy_timer(9.6 * _phase_timer_scale, 0.1);
            }

            if (e.rob_shots_fired >= 20 && e.rob_attack_timer <= 0)
            {
                e.rob_attack_timer = randomize_enemy_timer(55 * _phase_timer_scale, 0.1);
                e.rob_attack_state = 90;
            }
        }
        break;

        // ATTACK 3: Circle the arena, shoot at the player, and leave one-shot turrets.
        case 30:
        {
            var _orbit_radius = min(raid_room_x2 - raid_room_x1, raid_room_y2 - raid_room_y1) * 0.36;
            var _orbit_x = _center_x + lengthdir_x(_orbit_radius, e.rob_orbit_angle);
            var _orbit_y = _center_y + lengthdir_y(_orbit_radius, e.rob_orbit_angle);
            var _orbit_distance = point_distance(e.enemy_x, e.enemy_y, _orbit_x, _orbit_y);
            var _orbit_step = min(e.enemy_speed * 1.5 * _phase_pace * frame_scale, _orbit_distance);

            if (_orbit_distance > 3)
            {
                var _orbit_direction = point_direction(e.enemy_x, e.enemy_y, _orbit_x, _orbit_y);
                e.enemy_x += lengthdir_x(_orbit_step, _orbit_direction);
                e.enemy_y += lengthdir_y(_orbit_step, _orbit_direction);
            }
            else
            {
                e.enemy_x = _orbit_x;
                e.enemy_y = _orbit_y;
                e.rob_attack_timer = 0;
                e.rob_turret_timer = randomize_enemy_timer(35 * _phase_timer_scale, 0.1);
                e.rob_attack_state = 31;
            }
        }
        break;

        case 31:
        {
            var _orbit_radius = min(raid_room_x2 - raid_room_x1, raid_room_y2 - raid_room_y1) * 0.36;
            var _orbit_turn = min(0.75 * _phase_pace * frame_scale, e.rob_orbit_target - e.rob_orbit_progress);
            e.rob_orbit_angle = (e.rob_orbit_angle + _orbit_turn) mod 360;
            e.rob_orbit_progress += _orbit_turn;
            e.enemy_x = _center_x + lengthdir_x(_orbit_radius, e.rob_orbit_angle);
            e.enemy_y = _center_y + lengthdir_y(_orbit_radius, e.rob_orbit_angle);

            e.rob_attack_timer -= frame_scale;
            if (e.rob_attack_timer <= 0)
            {
                e = raid_enemy_fire_gun(e, e.enemy_gun_angle, _bullet_speed, 10);
                var _minigun_spinup = clamp(e.rob_orbit_progress / e.rob_orbit_target, 0, 1);
                var _orbit_shot_interval = lerp(55, 15, _minigun_spinup) * _phase_timer_scale;
                e.rob_attack_timer += randomize_enemy_timer(_orbit_shot_interval, 0.1);
            }

            e.rob_turret_timer -= frame_scale;
            if (e.rob_turret_timer <= 0 && array_length(e.rob_turrets) < 4)
            {
                var _turret_windup = randomize_enemy_timer(70 * _phase_timer_scale, 0.1);
                array_push(e.rob_turrets, {
                    x: e.enemy_x,
                    y: e.enemy_y,
                    timer: _turret_windup,
                    windup_total: _turret_windup,
                    aim_direction: point_direction(e.enemy_x, e.enemy_y, raid_player_x, raid_player_y)
                });
                e.rob_turret_timer += randomize_enemy_timer(105 * _phase_timer_scale, 0.1);
            }

            if (e.rob_orbit_progress >= e.rob_orbit_target)
            {
                e.rob_attack_timer = randomize_enemy_timer(55 * _phase_timer_scale, 0.1);
                e.rob_attack_state = 90;
            }
        }
        break;

        case 90:
        {
            e.rob_attack_timer -= frame_scale;
            if (e.rob_attack_timer <= 0)
                e.rob_attack_state = 0;
        }
        break;
    }

    return e;
}
