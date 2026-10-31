function draw_raid_player(_lighting_mask = false, _mask_alpha = 1)
{
    if (raid.state == RaidState.DEATH)
    {
        if (raid_player_death_phase <= 1)
        {
            draw_sprite_ext(
                raid_player_death_sprite,
                raid_player_death_frame,
                round(raid_player_death_x),
                round(raid_player_death_y),
                raid_player_death_facing * raid_player_death_scale,
                raid_player_death_scale,
                0,
                c_red,
                _lighting_mask ? _mask_alpha : 1
            );
        }

        return;
    }

    var member = crew[0];
    var _head = raid_player_get_head_sprite(member.armor_head);
    var _body = raid_player_get_body_sprite(member.armor_chest);

    var _legs = raid_player_moving ? spr_player_leglayer_run : spr_player_leglayer_idle;
    var _frame =
        floor(raid_player_anim_frame)
        mod sprite_get_number(_legs);

    var _x = round(raid_player_x);
    var _y = round(raid_player_y);
    var _head_bounce = raid_player_moving ? 0 : dsin(raid_player_anim_frame * 30) * 0.75;

	var _player_alpha = 1;

	if (raid_player_invincible)
	{
	    if (
	        floor(
	            raid_player_invincible_timer / 5
	        )
	        mod 2 == 0
	    )
	    {
	        _player_alpha = 0.35;
	    }
	}

    // ==============================
    // DASH TRAIL - BEHIND PLAYER
    // ==============================

    for (var i = 0; !_lighting_mask && i < array_length(raid_player_dash_trail); i++)
    {
        var _trail = raid_player_dash_trail[i];
        var _trail_alpha =
            (_trail.trail_timer / raid_player_dash_trail_time)
            * 0.5;

        draw_raid_player_body_layers(
            spr_player_leglayer_run,
            _trail.trail_frame mod sprite_get_number(spr_player_leglayer_run),
            round(_trail.trail_x),
            round(_trail.trail_y),
            _trail.trail_facing,
            _trail_alpha,
            0,
            true,
            _head,
            _body
        );
    }

    // ==============================
    // BAG - BEHIND PLAYER
    // ==============================

    raid_draw_equipment_layer(
        member.bag,
        _frame,
        _x,
        _y,
        _lighting_mask ? _mask_alpha : 1
    );


    // ==============================
    // LEGS AND TORSO
    // ==============================

    draw_raid_player_body_layers(
        _legs,
        _frame,
        _x,
        _y,
        raid_player_facing,
        _lighting_mask ? _mask_alpha : _player_alpha,
        _head_bounce,
        false,
        _head,
        _body
    );


    // ==============================
    // CHEST ARMOR
    // ==============================

    raid_draw_equipment_layer(
        member.armor_chest,
        _frame,
        _x,
        _y,
        _lighting_mask ? _mask_alpha : 1
    );


    // ==============================
    // HEAD
    // ==============================

    draw_sprite_ext(
        _head,
        0,
        _x,
        _y + _head_bounce,
        raid_player_facing * 0.3125,
        0.3125,
        0,
        c_white,
        _lighting_mask ? _mask_alpha : _player_alpha
    );


    // ==============================
    // HELMET
    // ==============================

    raid_draw_equipment_layer(
        member.armor_head,
        _frame,
        _x,
        _y + _head_bounce,
        _lighting_mask ? _mask_alpha : 1
    );
}

function draw_raid_player_body_layers(_legs, _frame, _x, _y, _facing, _alpha, _head_bounce = 0, _draw_head = true, _head_sprite = base_head, _body_sprite = base_torso)
{
    var _scale = 0.3125;

    draw_sprite_ext(_legs, _frame, _x, _y, _facing * _scale, _scale, 0, c_white, _alpha);
    draw_sprite_ext(_body_sprite, 0, _x, _y, _facing * _scale, _scale, 0, c_white, _alpha);

    if (_draw_head)
        draw_sprite_ext(_head_sprite, 0, _x, _y + _head_bounce, _facing * _scale, _scale, 0, c_white, _alpha);
}

function raid_player_get_head_sprite(_item_key)
{
    if (_item_key == "") return base_head;

    var _item = item_get(_item_key);
    if (!is_struct(_item) || !variable_struct_exists(_item, "head_sprite")) return base_head;

    var _head_sprite = _item.head_sprite;
    if (is_undefined(_head_sprite) || _head_sprite == -1 || !sprite_exists(_head_sprite)) return base_head;

    return _head_sprite;
}

function raid_player_get_body_sprite(_item_key)
{
    if (_item_key == "") return base_torso;

    var _item = item_get(_item_key);
    if (!is_struct(_item) || !variable_struct_exists(_item, "body_sprite")) return base_torso;

    var _body_sprite = _item.body_sprite;
    if (is_undefined(_body_sprite) || _body_sprite == -1 || !sprite_exists(_body_sprite)) return base_torso;

    return _body_sprite;
}

function draw_raid_player_hit_region_debug()
{
    if (!raid_hit_region_debug_enabled || raid.state == RaidState.DEATH) return;

    var _bbox = raid_player_get_collision_bbox();
    var _height = max(1, _bbox.bottom - _bbox.top);
    var _head_bottom = _bbox.top + _height * health_config.hit_region_head_end;
    var _torso_bottom = _bbox.top + _height * health_config.hit_region_torso_end;

    draw_set_alpha(0.25);
    draw_set_color(c_red);
    draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _head_bottom, false);
    draw_set_color(c_yellow);
    draw_rectangle(_bbox.left, _head_bottom, _bbox.right, _torso_bottom, false);
    draw_set_color(global.ui_text_color);
    draw_rectangle(_bbox.left, _torso_bottom, _bbox.right, _bbox.bottom, false);

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);
    draw_line(_bbox.left, _head_bottom, _bbox.right, _head_bottom);
    draw_line(_bbox.left, _torso_bottom, _bbox.right, _torso_bottom);

    if (!is_undefined(raid_hit_region_debug_impact_x) && !is_undefined(raid_hit_region_debug_impact_y))
    {
        var _impact_x = raid_hit_region_debug_impact_x;
        var _impact_y = raid_hit_region_debug_impact_y;
        draw_set_color(c_aqua);
        draw_circle(_impact_x, _impact_y, 3, true);
        draw_line(_impact_x - 5, _impact_y, _impact_x + 5, _impact_y);
        draw_line(_impact_x, _impact_y - 5, _impact_x, _impact_y + 5);
    }

    draw_set_font(fnt_terminal_small);
    draw_set_color(c_white);
    draw_text(_bbox.right + 5, _bbox.top, "REGION: " + raid_hit_region_debug_region + "\nLIMB: " + raid_hit_region_debug_limb);
    draw_set_font(fnt_terminal);
}

function draw_player_health_treatment_progress()
{
    if (!player_health_treatment_is_active()) return;
    var _width = 36;
    var _height = 4;
    var _left = round(raid_player_x - (_width * 0.5));
    var _top = round(raid_player_y - 32);
    var _progress = 1 - (raid.treatment.remaining / max(0.001, raid.treatment.duration));

    draw_set_color(make_color_rgb(24, 24, 24));
    draw_rectangle(_left - 1, _top - 1, _left + _width + 1, _top + _height + 1, false);
    draw_set_color(c_white);
    draw_rectangle(_left, _top, _left + (_width * clamp(_progress, 0, 1)), _top + _height, false);
    draw_set_color(make_color_rgb(24, 24, 24));
    draw_rectangle(_left, _top, _left + _width, _top + _height, true);
    draw_set_color(c_white);
}

function draw_player_health_treatment_inventory_status()
{
    if (!player_health_treatment_is_active()) return;
    var _definition = item_get(raid.treatment.item_key);
    if (is_undefined(_definition)) return;
    draw_set_font(fnt_terminal_small);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(820, 98, "Using " + _definition.name + " — " + string_format(max(0, raid.treatment.remaining), 0, 1) + "s left");
}
