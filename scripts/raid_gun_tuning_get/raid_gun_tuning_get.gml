function raid_gun_tuning_get(_weapon_key, _weapon)
{
    if (_weapon_key == "")
    {
        _weapon_key = _weapon.item_key;
    }

    if (!variable_struct_exists(raid_gun_tuning_values, _weapon_key))
    {
        var _width = variable_struct_exists(_weapon, "weapon_draw_width") ? _weapon.weapon_draw_width : 32;
        var _hand1_x = variable_struct_exists(_weapon, "hand1_x") ? _weapon.hand1_x : 0;
        var _hand1_y = variable_struct_exists(_weapon, "hand1_y") ? _weapon.hand1_y : 0;
        var _hand2_x = variable_struct_exists(_weapon, "hand2_x") ? _weapon.hand2_x : 0;
        var _hand2_y = variable_struct_exists(_weapon, "hand2_y") ? _weapon.hand2_y : 0;
        var _muzzle_x = variable_struct_exists(_weapon, "muzzle_x") ? _weapon.muzzle_x : 0;
        var _muzzle_y = variable_struct_exists(_weapon, "muzzle_y") ? _weapon.muzzle_y : 0;

        variable_struct_set(raid_gun_tuning_values, _weapon_key, {
            weapon_draw_width: _width,
            weapon_offset_x: raid_gun_offset,
            weapon_offset_y: 0,
            hand1_offset_x: _hand1_x,
            hand1_offset_y: _hand1_y,
            hand2_offset_x: _hand2_x,
            hand2_offset_y: _hand2_y,
            muzzle_offset_x: _muzzle_x,
            muzzle_offset_y: _muzzle_y,
            weapon_angle_offset: 0
        });
    }

    return variable_struct_get(raid_gun_tuning_values, _weapon_key);
}
