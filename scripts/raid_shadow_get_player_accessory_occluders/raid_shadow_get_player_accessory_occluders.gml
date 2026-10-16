function raid_shadow_get_player_accessory_occluders(_feet_x, _feet_y)
{
    var _accessories = [];
    var _weapon = raid_update_active_weapon();
    if (raid_gun_tuning_active) _weapon = item_get(raid_gun_tuning_weapon_key);

    if (!is_struct(_weapon))
    {
        var _knife_raise = 90 * raid_player_facing;
        var _knife_dir = raid_aim_dir + _knife_raise;
        var _hand_dir = raid_aim_dir;
        var _stab_distance = 0;
        if (raid_knife_attack_timer > 0)
        {
            var _progress = 1 - (raid_knife_attack_timer / raid_knife_attack_time);
            _hand_dir = raid_knife_attack_dir;
            if (_progress < 0.5) _stab_distance = clamp((_progress - 0.25) / 0.25, 0, 1) * 42;
            else if (_progress < 0.625) _stab_distance = 42;
            else _stab_distance = clamp(1 - ((_progress - 0.625) / 0.375), 0, 1) * 42;

            if (_progress < 0.625) _knife_dir = raid_knife_attack_dir + _knife_raise - (_knife_raise * min(1, _progress / 0.25));
            else _knife_dir = raid_knife_attack_dir + (_knife_raise * ((_progress - 0.625) / 0.375));
        }

        var _hand_x = raid_player_x + lengthdir_x(12, _hand_dir) + lengthdir_x(_stab_distance, _knife_dir);
        var _hand_y = raid_player_y - 10 + lengthdir_y(12, _hand_dir) + lengthdir_y(_stab_distance, _knife_dir);
        array_push(_accessories, raid_shadow_character_accessory(
            spr_hand, _hand_x, _hand_y, 1, 1, _knife_dir,
            _feet_x, _feet_y, raid_shadow_hand_extra_offset_scale
        ));
        return _accessories;
    }

    if (_weapon.weapon_sprite < 0 || !sprite_exists(_weapon.weapon_sprite)) return _accessories;
    var _tuning = raid_gun_tuning_get(raid_gun_tuning_weapon_key, _weapon);
    var _dir = raid_aim_dir + _tuning.weapon_angle_offset;
    var _flip_y = (_dir > 90 && _dir < 270) ? -1 : 1;
    var _weapon_offset_x = variable_struct_exists(_weapon, "weapon_offset_x") ? _weapon.weapon_offset_x : _tuning.weapon_offset_x;
    var _gun_x = raid_player_x
        + lengthdir_x(_weapon_offset_x - raid_gun_recoil, _dir)
        + lengthdir_x(_tuning.weapon_offset_y, _dir + 90);
    var _gun_y = raid_player_y - 10
        + lengthdir_y(_weapon_offset_x - raid_gun_recoil, _dir)
        + lengthdir_y(_tuning.weapon_offset_y, _dir + 90);
    var _visible_width = max(1, sprite_get_bbox_right(_weapon.weapon_sprite) - sprite_get_bbox_left(_weapon.weapon_sprite) + 1);
    var _weapon_scale = _tuning.weapon_draw_width / _visible_width;
    array_push(_accessories, raid_shadow_character_accessory(
        _weapon.weapon_sprite, _gun_x, _gun_y, _weapon_scale, _weapon_scale * _flip_y, _dir,
        _feet_x, _feet_y, raid_shadow_gun_extra_offset_scale
    ));

    var _hand1_x = _gun_x + lengthdir_x(_tuning.hand1_offset_x, _dir) + lengthdir_x(_tuning.hand1_offset_y * _flip_y, _dir + 90);
    var _hand1_y = _gun_y + lengthdir_y(_tuning.hand1_offset_x, _dir) + lengthdir_y(_tuning.hand1_offset_y * _flip_y, _dir + 90);
    array_push(_accessories, raid_shadow_character_accessory(
        spr_hand, _hand1_x, _hand1_y, 1, _flip_y, _dir,
        _feet_x, _feet_y, raid_shadow_hand_extra_offset_scale
    ));

    if (_weapon.has_second_hand)
    {
        var _hand2_x = _gun_x + lengthdir_x(_tuning.hand2_offset_x, _dir) + lengthdir_x(_tuning.hand2_offset_y * _flip_y, _dir + 90);
        var _hand2_y = _gun_y + lengthdir_y(_tuning.hand2_offset_x, _dir) + lengthdir_y(_tuning.hand2_offset_y * _flip_y, _dir + 90);
        array_push(_accessories, raid_shadow_character_accessory(
            spr_hand, _hand2_x, _hand2_y, 1, _flip_y, _dir,
            _feet_x, _feet_y, raid_shadow_hand_extra_offset_scale
        ));
    }
    return _accessories;
}
