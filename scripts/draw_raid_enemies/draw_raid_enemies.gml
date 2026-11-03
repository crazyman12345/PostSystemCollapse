// TEST
function draw_raid_enemies(_lighting_mask = false, _mask_alpha = 1)
{
    draw_set_font(fnt_terminal_small);

    for (var i = 0; i < array_length(raid_enemies); i++)
    {
        var e = raid_enemies[i];

        // Temporary turret art for Rob Gnarley. This can be replaced by a sprite later.
        if (!_lighting_mask && e.enemy_type == RaidEnemyType.ROB_GNARLEY)
        {
            for (var _turret_index = 0; _turret_index < array_length(e.rob_turrets); _turret_index++)
            {
                var _turret = e.rob_turrets[_turret_index];
                var _windup = 1 - clamp(_turret.timer / _turret.windup_total, 0, 1);

                draw_set_alpha(0.2 + 0.6 * _windup);
                draw_set_color(make_color_rgb(255, 35, 35));
                draw_line(_turret.x, _turret.y - 5, raid_player_x, raid_player_y);
                draw_set_alpha(1);
                draw_set_color(make_color_rgb(45, 45, 45));
                draw_circle(_turret.x, _turret.y, 6, false);
                draw_set_color(make_color_rgb(210, 30, 30));
                draw_circle(_turret.x, _turret.y - 2, 3, false);
            }
        }

        // ==============================
        // ENEMY BODY
        // ==============================

        var _enemy_color = e.enemy_tint;
        var _bbox_height =
            sprite_get_bbox_bottom(e.enemy_sprite)
            - sprite_get_bbox_top(e.enemy_sprite)
            + 1;
        var _normalize_scale = 40 / _bbox_height;
        var _draw_scale =
            0.75
            * _normalize_scale
            * e.size_multiplier;
		var _impact_deformation = 0;
		var _impact_offset_x = 0;
		var _impact_offset_y = 0;

		if (e.enemy_impact_wiggle_timer > 0)
		{
			var _impact_strength = e.enemy_impact_wiggle_timer / e.enemy_impact_wiggle_duration;
			var _impact_progress = 1 - _impact_strength;
			_impact_deformation = cos(_impact_progress * 540) * _impact_strength;
			_impact_offset_x = lengthdir_x(5 * _impact_deformation, e.enemy_knockback_direction);
			_impact_offset_y = lengthdir_y(5 * _impact_deformation, e.enemy_knockback_direction);
		}

		var _impact_scale_x = 1 - (0.15 * _impact_deformation);
		var _impact_scale_y = 1 + (0.09 * _impact_deformation);

        if (e.enemy_hit_flash_timer > 0)
            _enemy_color = merge_colour(c_white, c_red, 0.35);

        draw_sprite_ext(
            e.enemy_sprite,
            floor(e.enemy_frame),
            e.enemy_x,
            e.enemy_y,
            e.enemy_facing * _draw_scale * _impact_scale_x,
            _draw_scale * _impact_scale_y,
			0,
            _enemy_color,
            _lighting_mask ? _mask_alpha : 1
        );

        if (!_lighting_mask && e.enemy_type == RaidEnemyType.BOMBER && e.enemy_state == RaidEnemyState.ATTACK)
        {
            var _flash_rate = lerp(0.012, 0.04, 1 - clamp(e.bomb_windup_timer / e.bomb_windup_total, 0, 1));
            var _flash_alpha = 0.15 + 0.5 * (0.5 + 0.5 * sin(current_time * _flash_rate));
            gpu_set_blendmode(bm_add);
            draw_sprite_ext(
                e.enemy_sprite,
                floor(e.enemy_frame),
                e.enemy_x,
                e.enemy_y,
                e.enemy_facing * _draw_scale * _impact_scale_x,
                _draw_scale * _impact_scale_y,
				0,
                c_white,
                _flash_alpha
            );
            gpu_set_blendmode(bm_normal);
        }

        if (!_lighting_mask)
        {
            var _bullet_hole_bbox = raid_enemy_get_collision_bbox(e);
            var _bullet_hole_width = _bullet_hole_bbox.right - _bullet_hole_bbox.left;
            var _bullet_hole_height = _bullet_hole_bbox.bottom - _bullet_hole_bbox.top;

            for (var _bullet_hole_index = 0; _bullet_hole_index < array_length(e.enemy_bullet_holes); _bullet_hole_index++)
            {
                var _bullet_hole = e.enemy_bullet_holes[_bullet_hole_index];
                var _bullet_hole_normalized_x = e.enemy_facing < 0 ? 1 - _bullet_hole.x : _bullet_hole.x;
                var _bullet_hole_base_x = _bullet_hole_bbox.left + _bullet_hole_width * _bullet_hole_normalized_x;
                var _bullet_hole_base_y = _bullet_hole_bbox.top + _bullet_hole_height * _bullet_hole.y;
                var _bullet_hole_x = e.enemy_x + (_bullet_hole_base_x - e.enemy_x) * _impact_scale_x;
                var _bullet_hole_y = e.enemy_y + (_bullet_hole_base_y - e.enemy_y) * _impact_scale_y;

                draw_sprite_ext(
                    spr_enemy_bullet_hole,
                    0,
                    _bullet_hole_x,
                    _bullet_hole_y,
                    _bullet_hole.scale * _impact_scale_x,
                    _bullet_hole.scale * _impact_scale_y,
                    _bullet_hole.angle,
                    c_white,
                    1
                );
            }
        }

        if (e.enemy_type == RaidEnemyType.GRENADE_THROWER)
        {
            var _grenade_x = e.grenade_x;
            var _grenade_y = e.grenade_y;
            var _grenade_rotation = e.grenade_in_flight ? e.grenade_rotation : 0;
            var _grenade_in_hand = e.grenade_held && !e.grenade_landed;
            var _hand_x = e.enemy_x + e.enemy_facing * 6 + _impact_offset_x;
            var _hand_y = e.enemy_y - 14 + _impact_offset_y;
            var _hand_rotation = 0;

            if (_grenade_in_hand)
            {
                var _throw_progress = e.enemy_state == RaidEnemyState.ATTACK
                    ? 1 - (e.grenade_throw_timer / e.grenade_throw_total)
                    : 0;

                if (_throw_progress < 0.45)
                {
                    var _windup_progress = _throw_progress / 0.45;
                    _grenade_x = e.enemy_x + e.enemy_facing * lerp(10, -5, _windup_progress) + _impact_offset_x;
                    _grenade_y = e.enemy_y + lerp(-17, -28, _windup_progress) + _impact_offset_y;
                }
                else
                {
                    var _release_progress = (_throw_progress - 0.45) / 0.55;
                    _grenade_x = e.enemy_x + e.enemy_facing * lerp(-5, 16, _release_progress) + _impact_offset_x;
                    _grenade_y = e.enemy_y + lerp(-28, -20, _release_progress) + _impact_offset_y;
                }

                _grenade_rotation = e.enemy_facing * _throw_progress * 90;
                _hand_x = _grenade_x - e.enemy_facing * 4;
                _hand_y = _grenade_y + 3;
                _hand_rotation = _grenade_rotation;
            }

            draw_sprite_ext(
                spr_hand,
                0,
                round(_hand_x),
                round(_hand_y),
                1,
                e.enemy_facing,
                _hand_rotation,
                c_white,
                _lighting_mask ? _mask_alpha : 1
            );

            if (e.grenade_held || e.grenade_in_flight || e.grenade_landed)
            {
                var _grenade_scale = 0.009;
                var _grenade_center_x = sprite_get_width(spr_frag_grenade) * _grenade_scale * 0.5;
                var _grenade_center_y = sprite_get_height(spr_frag_grenade) * _grenade_scale * 0.5;
                var _grenade_center_distance = point_distance(0, 0, _grenade_center_x, _grenade_center_y);
                var _grenade_center_direction = point_direction(0, 0, _grenade_center_x, _grenade_center_y);

                draw_sprite_ext(
                    spr_frag_grenade,
                    0,
                    _grenade_x - lengthdir_x(_grenade_center_distance, _grenade_center_direction + _grenade_rotation),
                    _grenade_y - lengthdir_y(_grenade_center_distance, _grenade_center_direction + _grenade_rotation),
                    _grenade_scale,
                    _grenade_scale,
                    _grenade_rotation,
                    c_white,
                    _lighting_mask ? _mask_alpha : 1
                );
            }
        }

        if (_lighting_mask)
        {
            draw_raid_enemy_gun_and_hands(e, true, _mask_alpha);
            continue;
        }

        if (
            variable_struct_exists(e, "boss_transition_dialogue")
            && e.boss_transition_dialogue != ""
        )
        {
            var _dialogue_y = raid_enemy_get_collision_bbox(e).top - 12;

            draw_set_color(c_white);
            draw_set_halign(fa_center);
            draw_set_valign(fa_bottom);
            draw_text_transformed(e.enemy_x, _dialogue_y, e.boss_transition_dialogue, 0.45, 0.45, 0);
        }

        if (
            variable_struct_exists(e, "boss_intro_dialogue")
            && e.boss_intro_dialogue != ""
        )
        {
            var _intro_dialogue_y = raid_enemy_get_collision_bbox(e).top - 12;

            draw_set_color(c_white);
            draw_set_halign(fa_center);
            draw_set_valign(fa_bottom);
            draw_text_transformed(e.enemy_x, _intro_dialogue_y, e.boss_intro_dialogue, 0.45, 0.45, 0);
        }


        // ==============================
        // ENEMY TYPE
        // ==============================

        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
		if e.enemy_sprite = -1{
	        draw_text_transformed(
	            e.enemy_x,
	            e.enemy_y + 20,
	            raid_enemy_type_name(e.enemy_type),
	            0.32,
	            0.32,
	            0
	        );
		}

        if (!e.enemy_boss)
        {
            // ==============================
            // HEALTH BAR
            // ==============================

            var _enemy_bbox = raid_enemy_get_collision_bbox(e);
            var _bar_w = (_enemy_bbox.right - _enemy_bbox.left) + 4;
            var _bar_h = 2;

            var _bar_x = _enemy_bbox.left - 2;


            // ==============================
            // POSITION BELOW SPRITE
            // ==============================

            var _bar_y;

            _bar_y = _enemy_bbox.bottom + 3;


            var _hp_percent =
                e.enemy_hp
                / e.enemy_max_hp;


            // ==============================
            // BLACK BACKGROUND / OUTLINE
            // ==============================

            draw_set_color(c_black);

            draw_rectangle(
                _bar_x - 1,
                _bar_y - 1,
                _bar_x + _bar_w + 1,
                _bar_y + _bar_h + 1,
                false
            );


            // ==============================
            // DARK EMPTY BAR
            // ==============================

            draw_set_color(
                make_color_rgb(
                    50,
                    50,
                    50
                )
            );

            draw_rectangle(
                _bar_x,
                _bar_y,
                _bar_x + _bar_w,
                _bar_y + _bar_h,
                false
            );


            // ==============================
            // RED HEALTH
            // ==============================

            draw_set_color(c_red);

            draw_rectangle(
                _bar_x,
                _bar_y,
                _bar_x
                + (_bar_w * _hp_percent),
                _bar_y + _bar_h,
                false
            );

        }

        draw_raid_enemy_gun_and_hands(e);

    }


    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

function draw_raid_dash_indicator(_x, _y, _direction, _dash_distance, _windup_progress, _lane_half_width = 10)
{
    if (_dash_distance < 0)
    {
        var _dash_dir_x = lengthdir_x(1, _direction);
        var _dash_dir_y = lengthdir_y(1, _direction);
        _dash_distance = 100000;

        if (_dash_dir_x > 0.001)
            _dash_distance = min(_dash_distance, (raid_room_x2 - _x) / _dash_dir_x);
        else if (_dash_dir_x < -0.001)
            _dash_distance = min(_dash_distance, (raid_room_x1 - _x) / _dash_dir_x);

        if (_dash_dir_y > 0.001)
            _dash_distance = min(_dash_distance, (raid_room_y2 - _y) / _dash_dir_y);
        else if (_dash_dir_y < -0.001)
            _dash_distance = min(_dash_distance, (raid_room_y1 - _y) / _dash_dir_y);
    }

    var _lane_start = 18;
    var _lane_end = max(_lane_start, _dash_distance - 3);
    var _lane_offset_x = lengthdir_x(_lane_half_width, _direction + 90);
    var _lane_offset_y = lengthdir_y(_lane_half_width, _direction + 90);
    var _lane_start_x = _x + lengthdir_x(_lane_start, _direction);
    var _lane_start_y = _y + lengthdir_y(_lane_start, _direction);
    var _lane_end_x = _x + lengthdir_x(_lane_end, _direction);
    var _lane_end_y = _y + lengthdir_y(_lane_end, _direction);

    draw_set_alpha(0.35 + 0.5 * _windup_progress);
    draw_raid_dash_indicator_segment(_lane_start_x + _lane_offset_x, _lane_start_y + _lane_offset_y,
        _lane_end_x + _lane_offset_x, _lane_end_y + _lane_offset_y);
    draw_raid_dash_indicator_segment(_lane_start_x - _lane_offset_x, _lane_start_y - _lane_offset_y,
        _lane_end_x - _lane_offset_x, _lane_end_y - _lane_offset_y);
    draw_raid_dash_indicator_segment(_lane_end_x + _lane_offset_x, _lane_end_y + _lane_offset_y,
        _lane_end_x - _lane_offset_x, _lane_end_y - _lane_offset_y);

    var _arrow_local_x = [-12, 1, 1, 14, 1, 1, -12];
    var _arrow_local_y = [-4, -4, -8, 0, 8, 4, 4];
    var _arrow_count = max(1, floor((_lane_end - _lane_start) / 42));
    var _arrow_spacing = (_lane_end - _lane_start) / (_arrow_count + 1);

    for (var _arrow_index = 0; _arrow_index < _arrow_count; _arrow_index++)
    {
        var _arrow_distance = _lane_start + _arrow_spacing * (_arrow_index + 1);
        var _arrow_center_x = _x + lengthdir_x(_arrow_distance, _direction);
        var _arrow_center_y = _y + lengthdir_y(_arrow_distance, _direction);

        for (var _point_index = 0; _point_index < array_length(_arrow_local_x); _point_index++)
        {
            var _next_point = (_point_index + 1) mod array_length(_arrow_local_x);
            var _point_x1 = _arrow_center_x
                + lengthdir_x(_arrow_local_x[_point_index], _direction)
                + lengthdir_x(_arrow_local_y[_point_index], _direction + 90);
            var _point_y1 = _arrow_center_y
                + lengthdir_y(_arrow_local_x[_point_index], _direction)
                + lengthdir_y(_arrow_local_y[_point_index], _direction + 90);
            var _point_x2 = _arrow_center_x
                + lengthdir_x(_arrow_local_x[_next_point], _direction)
                + lengthdir_x(_arrow_local_y[_next_point], _direction + 90);
            var _point_y2 = _arrow_center_y
                + lengthdir_y(_arrow_local_x[_next_point], _direction)
                + lengthdir_y(_arrow_local_y[_next_point], _direction + 90);
            draw_raid_dash_indicator_segment(_point_x1, _point_y1, _point_x2, _point_y2);
        }
    }

    draw_set_alpha(1);
}

function draw_raid_dash_indicator_segment(_x1, _y1, _x2, _y2)
{
    var _line_direction = point_direction(_x1, _y1, _x2, _y2);
    var _thickness_x = lengthdir_x(1, _line_direction + 90);
    var _thickness_y = lengthdir_y(1, _line_direction + 90);

    draw_set_color(make_color_rgb(125, 12, 20));
    draw_line(_x1 + _thickness_x, _y1 + _thickness_y, _x2 + _thickness_x, _y2 + _thickness_y);
    draw_line(_x1 - _thickness_x, _y1 - _thickness_y, _x2 - _thickness_x, _y2 - _thickness_y);
    draw_set_color(make_color_rgb(255, 45, 45));
    draw_line(_x1, _y1, _x2, _y2);
}

function draw_raid_dash_indicators()
{
    for (var _enemy_index = 0; _enemy_index < array_length(raid_enemies); _enemy_index++)
    {
        var _enemy = raid_enemies[_enemy_index];

        if (_enemy.enemy_type == RaidEnemyType.ROB_GNARLEY && _enemy.rob_attack_state == 10)
        {
            var _rob_windup = 1 - clamp(_enemy.rob_attack_timer / _enemy.rob_dash_windup_total, 0, 1);
            var _rob_bbox = raid_enemy_get_collision_bbox(_enemy);
            var _rob_lane_half_width = (_rob_bbox.right - _rob_bbox.left) * 0.5;
            draw_raid_dash_indicator(_enemy.enemy_x, _enemy.enemy_y, _enemy.rob_dash_direction,
                -1, _rob_windup, _rob_lane_half_width);
        }
        else if (_enemy.enemy_type == RaidEnemyType.KNIFE_DASHER && _enemy.enemy_state == RaidEnemyState.PAUSE)
        {
            var _knife_windup = 1 - clamp(_enemy.state_timer / _enemy.dash_windup_total, 0, 1);
            draw_raid_dash_indicator(_enemy.enemy_x, _enemy.enemy_y, _enemy.dash_dir,
                _enemy.dash_speed * _enemy.dash_duration, _knife_windup);
        }
        else if (_enemy.enemy_type == RaidEnemyType.WALL_RUSHER && _enemy.enemy_state == RaidEnemyState.PAUSE)
        {
            var _rusher_windup = 1 - clamp(_enemy.state_timer / _enemy.dash_windup_total, 0, 1);
            draw_raid_dash_indicator(_enemy.enemy_x, _enemy.enemy_y, _enemy.dash_dir, -1, _rusher_windup);
        }
    }

    draw_set_color(c_white);
    draw_set_alpha(1);
}
