// TEST
function draw_raid_enemies()
{
    draw_set_font(fnt_terminal_small);

    for (var i = 0; i < array_length(raid_enemies); i++)
    {
        var e = raid_enemies[i];

        // ==============================
        // ENEMY BODY
        // ==============================

        if (e.enemy_sprite != -1)
        {
            var _enemy_color = e.enemy_tint;
            var _total_flash_duration = max(2, round(game_get_speed(gamespeed_fps) / 8));
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
                1
            );
        }
        else
        {
            draw_set_color(c_red);

            draw_circle(
                e.enemy_x,
                e.enemy_y,
                e.enemy_radius,
                false
            );
        }


        draw_raid_enemy_gun_and_hands(e);

        if (
            variable_struct_exists(e, "boss_transition_dialogue")
            && e.boss_transition_dialogue != ""
        )
        {
            var _dialogue_y = e.enemy_y - e.enemy_radius - 20;

            if (e.enemy_sprite != -1)
            {
                var _dialogue_bbox_height = sprite_get_bbox_bottom(e.enemy_sprite) - sprite_get_bbox_top(e.enemy_sprite) + 1;
                var _dialogue_scale = 0.75 * (40 / _dialogue_bbox_height) * e.size_multiplier;
                _dialogue_y = e.enemy_y - (sprite_get_yoffset(e.enemy_sprite) * _dialogue_scale) - 12;
            }

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

            var _bar_w = 32;
            var _bar_h = 4;

            var _bar_x =
                e.enemy_x
                - (_bar_w * 0.5);


            // ==============================
            // POSITION ABOVE SPRITE
            // ==============================

            var _bar_y;

            if (e.enemy_sprite != -1)
            {
                var _origin_y =
                    sprite_get_yoffset(
                        e.enemy_sprite
                    )
                    * _draw_scale;

                var _sprite_top =
                    e.enemy_y
                    - _origin_y;

                _bar_y =
                    _sprite_top
                    - 15;
            }
            else
            {
                _bar_y =
                    e.enemy_y
                    - e.enemy_radius
                    - 15;
            }


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


            // ==============================
            // HP NUMBER
            // ==============================

            draw_set_color(c_white);
            draw_set_halign(fa_center);
            draw_set_valign(fa_bottom);

            draw_text_transformed(
                e.enemy_x,
                _bar_y - 2,
                string(ceil(e.enemy_hp)),
                0.4,
                0.4,
                0
            );
        }

    }


    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
