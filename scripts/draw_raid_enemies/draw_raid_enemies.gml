// TEST
function draw_raid_enemies(_lighting_mask = false, _mask_alpha = 1)
{
    draw_set_font(fnt_terminal_small);

    for (var i = 0; i < array_length(raid_enemies); i++)
    {
        var e = raid_enemies[i];

        // ==============================
        // ENEMY BODY
        // ==============================

        var _enemy_color = e.enemy_tint;
        var _total_flash_duration = 8;
        var _second_flash_duration = floor(_total_flash_duration / 2);
        var _bbox_height =
            sprite_get_bbox_bottom(e.enemy_sprite)
            - sprite_get_bbox_top(e.enemy_sprite)
            + 1;
        var _normalize_scale = 40 / _bbox_height;
        var _draw_scale =
            0.75
            * _normalize_scale
            * e.size_multiplier;

        if (
            e.enemy_hit_flash_timer > 0
            && (
                e.enemy_hit_flash_timer > _total_flash_duration
                || e.enemy_hit_flash_timer <= _second_flash_duration
            )
        )
            _enemy_color = c_red;

        draw_sprite_ext(
            e.enemy_sprite,
            floor(e.enemy_frame),
            e.enemy_x,
            e.enemy_y,
            e.enemy_facing * _draw_scale,
            _draw_scale,
            0,
            _enemy_color,
            _lighting_mask ? _mask_alpha : 1
        );

        if (
            e.enemy_type == RaidEnemyType.GRENADE_THROWER
            && (e.grenade_held || e.grenade_in_flight)
        )
        {
            var _grenade_x = e.grenade_in_flight
                ? e.grenade_x
                : e.enemy_x + e.enemy_facing * 10;
            var _grenade_y = e.grenade_in_flight
                ? e.grenade_y
                : e.enemy_y - 17;
            var _grenade_rotation = e.grenade_in_flight ? e.grenade_rotation : 0;
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
