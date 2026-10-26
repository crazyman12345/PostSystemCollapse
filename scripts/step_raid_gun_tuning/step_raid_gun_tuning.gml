function step_raid_gun_tuning()
{
    var _weapon = item_get(raid_gun_tuning_weapon_key);
    if (!is_struct(_weapon)) return;

    raid_aim_dir = point_direction(
        raid_player_x,
        raid_player_y - 12,
        mouse_x,
        mouse_y
    );

    var _keys = variable_struct_get_names(global.items);
    var _weapons = [];
    for (var i = 0; i < array_length(_keys); i++)
    {
        var _item = variable_struct_get(global.items, _keys[i]);
        if (_item.category == ItemCategory.WEAPON) array_push(_weapons, _keys[i]);
    }

    if (keyboard_check_pressed(ord("G")) || keyboard_check_pressed(ord("H")))
    {
        var _index = 0;
        for (var w = 0; w < array_length(_weapons); w++)
        {
            if (_weapons[w] == raid_gun_tuning_weapon_key)
            {
                _index = w;
                break;
            }
        }
        var _step = keyboard_check_pressed(ord("H")) ? 1 : -1;
        _index = (_index + _step + array_length(_weapons)) mod array_length(_weapons);
        raid_gun_tuning_weapon_key = _weapons[_index];
        _weapon = item_get(raid_gun_tuning_weapon_key);
    }

    if (keyboard_check_pressed(vk_up)) raid_gun_tuning_value_index = max(0, raid_gun_tuning_value_index - 1);
    if (keyboard_check_pressed(vk_down)) raid_gun_tuning_value_index = min(9, raid_gun_tuning_value_index + 1);

    var _amount = keyboard_check(vk_shift) ? 5 : (keyboard_check(vk_control) ? 0.1 : 1);
    var _change = 0;
    if (keyboard_check(vk_left)) _change -= _amount * frame_scale;
    if (keyboard_check(vk_right)) _change += _amount * frame_scale;

    if (_change != 0)
    {
        var _tuning = raid_gun_tuning_get(raid_gun_tuning_weapon_key, _weapon);
        var _names = ["weapon_draw_width", "weapon_offset_x", "weapon_offset_y", "hand1_offset_x", "hand1_offset_y", "hand2_offset_x", "hand2_offset_y", "muzzle_offset_x", "muzzle_offset_y", "weapon_angle_offset"];
        var _name = _names[raid_gun_tuning_value_index];
        variable_struct_set(_tuning, _name, variable_struct_get(_tuning, _name) + _change);
    }

    if (keyboard_check_pressed(ord("P")))
    {
        var _tuning = raid_gun_tuning_get(raid_gun_tuning_weapon_key, _weapon);
        var _names = ["weapon_draw_width", "weapon_offset_x", "weapon_offset_y", "hand1_offset_x", "hand1_offset_y", "hand2_offset_x", "hand2_offset_y", "muzzle_offset_x", "muzzle_offset_y", "weapon_angle_offset"];
        var _output = "";
        for (var n = 0; n < array_length(_names); n++)
        {
            _output += _names[n] + ": " + string(variable_struct_get(_tuning, _names[n])) + ",\n";
        }
        show_debug_message(_output);
    }
}
