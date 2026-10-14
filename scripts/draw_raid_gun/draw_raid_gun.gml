function draw_raid_gun()
{
    var _weapon = raid_update_active_weapon();

    if (raid_gun_tuning_active)
    {
        _weapon = item_get(raid_gun_tuning_weapon_key);
    }

    if (!is_struct(_weapon))
    {
        var _pivot_x = raid_player_x;
        var _pivot_y = raid_player_y - 10;
        var _knife_raise = 90 * raid_player_facing;
        var _knife_dir = raid_aim_dir + _knife_raise;
        var _hand_dir = raid_aim_dir;
        var _stab_distance = 0;

        if (raid_knife_attack_timer > 0)
        {
            var _progress = 1 - (raid_knife_attack_timer / raid_knife_attack_time);
            var _raised_dir = raid_knife_attack_dir + _knife_raise;
            _hand_dir = raid_knife_attack_dir;

            if (_progress < 0.625)
            {
                _knife_dir = _raised_dir - (_knife_raise * min(1, _progress / 0.25));
            }
            else
            {
                _knife_dir = raid_knife_attack_dir + (_knife_raise * ((_progress - 0.625) / 0.375));
            }

            if (_progress < 0.5)
            {
                _stab_distance = clamp((_progress - 0.25) / 0.25, 0, 1) * 42;
            }
            else if (_progress < 0.625)
            {
                _stab_distance = 42;
            }
            else
            {
                _stab_distance = clamp(1 - ((_progress - 0.625) / 0.375), 0, 1) * 42;
            }
        }

        var _hand_x = _pivot_x + lengthdir_x(12, _hand_dir) + lengthdir_x(_stab_distance, _knife_dir);
        var _hand_y = _pivot_y + lengthdir_y(12, _hand_dir) + lengthdir_y(_stab_distance, _knife_dir);
        var _handle_end_x = _hand_x + lengthdir_x(7, _knife_dir);
        var _handle_end_y = _hand_y + lengthdir_y(7, _knife_dir);
        var _blade_base_x = _handle_end_x;
        var _blade_base_y = _handle_end_y;
        var _blade_tip_x = _hand_x + lengthdir_x(22, _knife_dir);
        var _blade_tip_y = _hand_y + lengthdir_y(22, _knife_dir);
        var _blade_side_x = lengthdir_x(3, _knife_dir + 90);
        var _blade_side_y = lengthdir_y(3, _knife_dir + 90);
        var _handle_side_x = lengthdir_x(3, _knife_dir + 90);
        var _handle_side_y = lengthdir_y(3, _knife_dir + 90);

        for (var i = 0; i < array_length(raid_knife_trail); i++)
        {
            var _trail = raid_knife_trail[i];
            var _trail_handle_end_x = _trail.trail_hand_x + lengthdir_x(7, _trail.trail_dir);
            var _trail_handle_end_y = _trail.trail_hand_y + lengthdir_y(7, _trail.trail_dir);
            var _trail_blade_tip_x = _trail.trail_hand_x + lengthdir_x(22, _trail.trail_dir);
            var _trail_blade_tip_y = _trail.trail_hand_y + lengthdir_y(22, _trail.trail_dir);
            var _trail_side_x = lengthdir_x(3, _trail.trail_dir + 90);
            var _trail_side_y = lengthdir_y(3, _trail.trail_dir + 90);

            draw_set_alpha((_trail.trail_timer / raid_knife_trail_time) * 0.35);
            draw_set_color(c_white);
            draw_triangle(
                _trail_handle_end_x + _trail_side_x,
                _trail_handle_end_y + _trail_side_y,
                _trail_handle_end_x - _trail_side_x,
                _trail_handle_end_y - _trail_side_y,
                _trail_blade_tip_x,
                _trail_blade_tip_y,
                false
            );
        }

        draw_set_alpha(1);
        draw_set_color(c_black);
        draw_triangle(
            _hand_x + _handle_side_x,
            _hand_y + _handle_side_y,
            _hand_x - _handle_side_x,
            _hand_y - _handle_side_y,
            _handle_end_x + _handle_side_x,
            _handle_end_y + _handle_side_y,
            false
        );
        draw_triangle(
            _hand_x - _handle_side_x,
            _hand_y - _handle_side_y,
            _handle_end_x - _handle_side_x,
            _handle_end_y - _handle_side_y,
            _handle_end_x + _handle_side_x,
            _handle_end_y + _handle_side_y,
            false
        );
        draw_set_color(make_color_rgb(100, 60, 35));
        draw_triangle(
            _hand_x + (_handle_side_x * 0.5),
            _hand_y + (_handle_side_y * 0.5),
            _hand_x - (_handle_side_x * 0.5),
            _hand_y - (_handle_side_y * 0.5),
            _handle_end_x + (_handle_side_x * 0.5),
            _handle_end_y + (_handle_side_y * 0.5),
            false
        );
        draw_triangle(
            _hand_x - (_handle_side_x * 0.5),
            _hand_y - (_handle_side_y * 0.5),
            _handle_end_x - (_handle_side_x * 0.5),
            _handle_end_y - (_handle_side_y * 0.5),
            _handle_end_x + (_handle_side_x * 0.5),
            _handle_end_y + (_handle_side_y * 0.5),
            false
        );

        draw_set_color(c_black);
        draw_triangle(
            _blade_base_x + _blade_side_x,
            _blade_base_y + _blade_side_y,
            _blade_base_x - _blade_side_x,
            _blade_base_y - _blade_side_y,
            _blade_tip_x,
            _blade_tip_y,
            false
        );
        draw_set_color(c_white);
        draw_triangle(
            _blade_base_x + (_blade_side_x * 0.6),
            _blade_base_y + (_blade_side_y * 0.6),
            _blade_base_x - (_blade_side_x * 0.6),
            _blade_base_y - (_blade_side_y * 0.6),
            _blade_tip_x,
            _blade_tip_y,
            false
        );

        draw_sprite_ext(spr_hand, 0, round(_hand_x), round(_hand_y), 1, 1, _knife_dir, c_white, 1);
        draw_set_color(c_white);
        return;
    }

    var _pivot_x = raid_player_x;
    var _pivot_y = raid_player_y - 10;

    var _tuning = raid_gun_tuning_get(raid_gun_tuning_weapon_key, _weapon);
    var _dir = raid_aim_dir + _tuning.weapon_angle_offset;


    // ==============================
    // GUN POSITION
    // ==============================

var _weapon_offset_x = variable_struct_exists(_weapon, "weapon_offset_x") ? _weapon.weapon_offset_x : _tuning.weapon_offset_x;
var _draw_offset = _weapon_offset_x - raid_gun_recoil;
var _draw_side_offset = _tuning.weapon_offset_y;

var _gun_x =
    _pivot_x
    + lengthdir_x(
        _draw_offset,
        _dir
    ) + lengthdir_x(_draw_side_offset, _dir + 90);

var _gun_y =
    _pivot_y
    + lengthdir_y(
        _draw_offset,
        _dir
    ) + lengthdir_y(_draw_side_offset, _dir + 90);


    // ==============================
    // DRAW GUN
    // ==============================
	
var _sprite = _weapon.weapon_sprite;

// Get the visible sprite width, excluding transparent padding
var _bbox_left = sprite_get_bbox_left(_sprite);
var _bbox_right = sprite_get_bbox_right(_sprite);
var _visible_width = max(1, _bbox_right - _bbox_left + 1);

// Calculate uniform scale
var _target_width = _tuning.weapon_draw_width;
var _weapon_scale = _target_width / _visible_width;

// Flip vertically when aiming left
var _flip_y = 1;

if (_dir > 90 && _dir < 270)
{
    _flip_y = -1;
}

var _muzzle_x = _gun_x
    + lengthdir_x(_tuning.muzzle_offset_x, _dir)
    + lengthdir_x(_tuning.muzzle_offset_y * _flip_y, _dir + 90);
var _muzzle_y = _gun_y
    + lengthdir_y(_tuning.muzzle_offset_x, _dir)
    + lengthdir_y(_tuning.muzzle_offset_y * _flip_y, _dir + 90);

draw_sprite_ext(
    _sprite,
    0,
    round(_gun_x),
    round(_gun_y),
    _weapon_scale,
    _weapon_scale * _flip_y,
    _dir,
    c_white,
    1
);

if (is_struct(raid_muzzle_flash_light) && raid_muzzle_flash_light.lifetime > 0)
{
    raid_muzzle_flash_light.x = _muzzle_x;
    raid_muzzle_flash_light.y = _muzzle_y;
    var _muzzle_flash_scale = variable_struct_exists(_weapon, "muzzle_flash_scale")
        ? _weapon.muzzle_flash_scale
        : 0.5;
    raid_muzzle_flash_light.flash_xscale = _muzzle_flash_scale * raid_muzzle_flash_light.flash_scale;
    raid_muzzle_flash_light.flash_yscale = _muzzle_flash_scale * raid_muzzle_flash_light.flash_scale * _flip_y * raid_muzzle_flash_light.flash_mirror;
    raid_muzzle_flash_light.flash_direction = _dir + raid_muzzle_flash_light.flash_rotation;
}

    // ==============================
    // MAIN HAND
    // ==============================

    var _hand1_x =
        _gun_x
        + lengthdir_x(
            _tuning.hand1_offset_x,
            _dir
        )
        + lengthdir_x(
            _tuning.hand1_offset_y * _flip_y,
            _dir + 90
        );

    var _hand1_y =
        _gun_y
        + lengthdir_y(
            _tuning.hand1_offset_x,
            _dir
        )
        + lengthdir_y(
            _tuning.hand1_offset_y * _flip_y,
            _dir + 90
        );

		draw_sprite_ext(
		    spr_hand,
		    0,
		    round(_hand1_x),
		    round(_hand1_y),
		    1,
		    _flip_y,
		    _dir,
		    c_white,
		    1
		);


    // ==============================
    // SECOND HAND
    // ==============================

    var _hand2_x = 0;
    var _hand2_y = 0;

    if (_weapon.has_second_hand)
    {
        _hand2_x =
            _gun_x
            + lengthdir_x(
                _tuning.hand2_offset_x,
                _dir
            )
            + lengthdir_x(
                _tuning.hand2_offset_y * _flip_y,
                _dir + 90
            );

        _hand2_y =
            _gun_y
            + lengthdir_y(
                _tuning.hand2_offset_x,
                _dir
            )
            + lengthdir_y(
                _tuning.hand2_offset_y * _flip_y,
                _dir + 90
            );

		      draw_sprite_ext(
		    spr_hand,
		    0,
		    round(_hand2_x),
		    round(_hand2_y),
		    1,
		    _flip_y,
		    _dir,
		    c_white,
		    1
		);
		    }

    if (raid_gun_tuning_active)
    {
		draw_set_font(fnt_terminal_tiny);
        draw_set_color(c_yellow);
        draw_circle(_gun_x, _gun_y, 3, false);
        draw_text(_gun_x + 7, _gun_y - 18, "origin / grip");
        draw_set_color(c_aqua);
        draw_circle(_hand1_x, _hand1_y, 3, false);
        draw_text(_hand1_x + 7, _hand1_y - 18, "Hand 1");
        if (_weapon.has_second_hand)
        {
            draw_set_color(c_lime);
            draw_circle(_hand2_x, _hand2_y, 3, false);
            draw_text(_hand2_x + 7, _hand2_y - 18, "Hand 2");
        }
        draw_set_color(c_red);
        draw_circle(_muzzle_x, _muzzle_y, 3, false);
        draw_text(_muzzle_x + 7, _muzzle_y - 18, "muzzle");
        draw_line(_gun_x, _gun_y, _gun_x + lengthdir_x(40, _dir), _gun_y + lengthdir_y(40, _dir));
        draw_text(_gun_x + lengthdir_x(44, _dir), _gun_y + lengthdir_y(44, _dir), "aim");
        draw_set_color(c_white);
    }
}
