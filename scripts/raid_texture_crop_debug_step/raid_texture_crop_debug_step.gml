function raid_texture_crop_debug_step()
{
    if (keyboard_check_pressed(vk_f7))
    {
        raid_texture_crop_debug_active = !raid_texture_crop_debug_active;
        raid_texture_crop_debug_drag_row = -1;
    }
    if (!raid_texture_crop_debug_active) return false;

    if (keyboard_check_pressed(vk_tab))
    {
        raid_texture_crop_debug_tab = (raid_texture_crop_debug_tab + 1) mod 5;
        if (raid_texture_crop_debug_selection < 20)
            raid_texture_crop_debug_selection = min(raid_texture_crop_debug_selection,
                raid_texture_crop_debug_tab == 2 ? 12 : (raid_texture_crop_debug_tab == 3 ? 2 : (raid_texture_crop_debug_tab == 4 ? 3 : 9)));
    }
    var _row_count = raid_texture_crop_debug_tab == 2 ? 13 : (raid_texture_crop_debug_tab == 3 ? 3 : (raid_texture_crop_debug_tab == 4 ? 4 : 10));
    if (keyboard_check_pressed(vk_up))
    {
        if (raid_texture_crop_debug_selection == 20) raid_texture_crop_debug_selection = _row_count - 1;
        else raid_texture_crop_debug_selection = max(0, raid_texture_crop_debug_selection - 1);
    }
    if (keyboard_check_pressed(vk_down))
    {
        if (raid_texture_crop_debug_selection == _row_count - 1) raid_texture_crop_debug_selection = 20;
        else raid_texture_crop_debug_selection = min(23, raid_texture_crop_debug_selection + 1);
    }

    var _names = ["crop_left", "crop_right", "crop_top", "crop_bottom", "offset_x", "offset_y", "uv_offset_u", "uv_offset_v", "scale_x", "scale_y"];
    if (raid_texture_crop_debug_selection < _row_count)
    {
        var _change = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
        if (_change != 0)
        {
            if (raid_texture_crop_debug_tab == 4)
            {
                var _environment_fields = ["vertical_projection", "perspective_strength_x", "perspective_strength_y", "perspective_smoothing"];
                var _environment_field = raid_texture_crop_debug_selection;
                var _environment_change = _change * (_environment_field == 0 || _environment_field == 3 ? 0.05 : 0.25);
                raid_texture_crop_debug_environment_set(_environment_field,
                    variable_struct_get(raid_environment, _environment_fields[_environment_field]) + _environment_change);
            }
            else if (raid_texture_crop_debug_tab == 3)
            {
                var _shadow_value = raid_texture_crop_debug_selection == 0 ? raid_player_projected_shadow_offset_x
                    : (raid_texture_crop_debug_selection == 1 ? raid_player_projected_shadow_offset_y : raid_shadow_gun_extra_offset_scale);
                var _shadow_change = raid_texture_crop_debug_selection == 2 ? _change * 0.05 : _change;
                raid_texture_crop_debug_shadow_set(raid_texture_crop_debug_selection, _shadow_value + _shadow_change);
            }
            else if (raid_texture_crop_debug_tab == 2)
            {
                var _door_value = raid_texture_crop_debug_door_value(raid_texture_crop_debug_selection);
                raid_texture_crop_debug_door_set(raid_texture_crop_debug_selection, _door_value + _change);
            }
            else
            {
                var _material = raid_texture_crop_debug_material();
                var _name = _names[raid_texture_crop_debug_selection];
                raid_texture_crop_debug_material_set(raid_texture_crop_debug_tab, _name, variable_struct_get(_material, _name) + _change);
            }
        }
    }
    else if (keyboard_check_pressed(vk_enter))
    {
        raid_texture_crop_debug_action(raid_texture_crop_debug_selection - 20);
    }

    raid_texture_crop_debug_mouse_input();
    return true;
}


function raid_texture_crop_debug_mouse_input()
{
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var _pressed = mouse_check_button_pressed(mb_left);

    if (_pressed && point_in_rectangle(_mouse_x, _mouse_y, 50, 110, 146, 140))
    {
        raid_texture_crop_debug_tab = 0;
        raid_texture_crop_debug_selection = min(raid_texture_crop_debug_selection, 9);
    }
    if (_pressed && point_in_rectangle(_mouse_x, _mouse_y, 149, 110, 245, 140))
    {
        raid_texture_crop_debug_tab = 1;
        raid_texture_crop_debug_selection = min(raid_texture_crop_debug_selection, 9);
    }
    if (_pressed && point_in_rectangle(_mouse_x, _mouse_y, 248, 110, 344, 140))
    {
        raid_texture_crop_debug_tab = 2;
        raid_texture_crop_debug_selection = min(raid_texture_crop_debug_selection, 12);
    }
    if (_pressed && point_in_rectangle(_mouse_x, _mouse_y, 347, 110, 443, 140))
    {
        raid_texture_crop_debug_tab = 3;
        raid_texture_crop_debug_selection = min(raid_texture_crop_debug_selection, 2);
    }
    if (_pressed && point_in_rectangle(_mouse_x, _mouse_y, 446, 110, 542, 140))
    {
        raid_texture_crop_debug_tab = 4;
        raid_texture_crop_debug_selection = min(raid_texture_crop_debug_selection, 3);
    }

    var _material = raid_texture_crop_debug_tab >= 2 ? undefined : raid_texture_crop_debug_material();
    var _names = ["crop_left", "crop_right", "crop_top", "crop_bottom", "offset_x", "offset_y", "uv_offset_u", "uv_offset_v", "scale_x", "scale_y"];
    var _environment_names = ["vertical_projection", "perspective_strength_x", "perspective_strength_y", "perspective_smoothing"];
    var _row_count = raid_texture_crop_debug_tab == 2 ? 13 : (raid_texture_crop_debug_tab == 3 ? 3 : (raid_texture_crop_debug_tab == 4 ? 4 : 10));
    for (var _row = 0; _row < _row_count; _row++)
    {
        var _row_spacing = raid_texture_crop_debug_tab == 2 ? 30 : 40;
        var _row_y = 165 + _row * _row_spacing;
        if (_pressed && point_in_rectangle(_mouse_x, _mouse_y, 210, _row_y, 390, _row_y + 24))
        {
            raid_texture_crop_debug_selection = _row;
            raid_texture_crop_debug_drag_row = _row;
        }
        if (_pressed && point_in_rectangle(_mouse_x, _mouse_y, 410, _row_y, 442, _row_y + 24))
        {
            raid_texture_crop_debug_selection = _row;
            if (raid_texture_crop_debug_tab == 4)
            {
                var _environment_minus_step = _row == 0 || _row == 3 ? 0.05 : 0.25;
                raid_texture_crop_debug_environment_set(_row,
                    variable_struct_get(raid_environment, _environment_names[_row]) - _environment_minus_step);
            }
            else if (raid_texture_crop_debug_tab == 3)
            {
                var _shadow_minus_value = _row == 0 ? raid_player_projected_shadow_offset_x
                    : (_row == 1 ? raid_player_projected_shadow_offset_y : raid_shadow_gun_extra_offset_scale);
                raid_texture_crop_debug_shadow_set(_row, _shadow_minus_value - (_row == 2 ? 0.05 : 1));
            }
            else if (raid_texture_crop_debug_tab == 2)
            {
                var _door_minus_value = raid_texture_crop_debug_door_value(_row);
                raid_texture_crop_debug_door_set(_row, _door_minus_value - 1);
            }
            else raid_texture_crop_debug_material_set(raid_texture_crop_debug_tab, _names[_row], variable_struct_get(_material, _names[_row]) - 1);
        }
        if (_pressed && point_in_rectangle(_mouse_x, _mouse_y, 510, _row_y, 542, _row_y + 24))
        {
            raid_texture_crop_debug_selection = _row;
            if (raid_texture_crop_debug_tab == 4)
            {
                var _environment_plus_step = _row == 0 || _row == 3 ? 0.05 : 0.25;
                raid_texture_crop_debug_environment_set(_row,
                    variable_struct_get(raid_environment, _environment_names[_row]) + _environment_plus_step);
            }
            else if (raid_texture_crop_debug_tab == 3)
            {
                var _shadow_plus_value = _row == 0 ? raid_player_projected_shadow_offset_x
                    : (_row == 1 ? raid_player_projected_shadow_offset_y : raid_shadow_gun_extra_offset_scale);
                raid_texture_crop_debug_shadow_set(_row, _shadow_plus_value + (_row == 2 ? 0.05 : 1));
            }
            else if (raid_texture_crop_debug_tab == 2)
            {
                var _door_plus_value = raid_texture_crop_debug_door_value(_row);
                raid_texture_crop_debug_door_set(_row, _door_plus_value + 1);
            }
            else raid_texture_crop_debug_material_set(raid_texture_crop_debug_tab, _names[_row], variable_struct_get(_material, _names[_row]) + 1);
        }
    }

    if (raid_texture_crop_debug_drag_row >= 0 && mouse_check_button(mb_left))
    {
        var _drag_value;
        if (raid_texture_crop_debug_tab == 4)
        {
            var _environment_max = raid_texture_crop_debug_drag_row == 3 ? 1
                : (raid_texture_crop_debug_drag_row == 0 ? 2 : 20);
            _drag_value = ((_mouse_x - 210) / 180) * _environment_max;
        }
        else if (raid_texture_crop_debug_tab == 3 && raid_texture_crop_debug_drag_row == 2)
            _drag_value = ((_mouse_x - 210) / 180) * 2;
        else if (raid_texture_crop_debug_tab == 3)
            _drag_value = ((_mouse_x - 210) / 180) * 200 - 100;
        else if (raid_texture_crop_debug_tab == 2 && raid_texture_crop_debug_drag_row < 6)
            _drag_value = ((_mouse_x - 210) / 180) * 90 - 45;
        else if (raid_texture_crop_debug_tab == 2 && raid_texture_crop_debug_drag_row < 8)
            _drag_value = ((_mouse_x - 210) / 180) * 200 - 100;
        else if (raid_texture_crop_debug_tab == 2 && raid_texture_crop_debug_drag_row < 10)
            _drag_value = 10 + ((_mouse_x - 210) / 180) * 190;
        else if (raid_texture_crop_debug_tab == 2 && raid_texture_crop_debug_drag_row < 12)
            _drag_value = ((_mouse_x - 210) / 180) * 200 - 100;
        else if (raid_texture_crop_debug_tab == 2)
            _drag_value = ((_mouse_x - 210) / 180) * raid_environment.wall_height;
        else if (raid_texture_crop_debug_drag_row < 6)
            _drag_value = ((_mouse_x - 210) / 180) * 90 - 45;
        else if (raid_texture_crop_debug_drag_row < 8)
            _drag_value = ((_mouse_x - 210) / 180) * 200 - 100;
        else
            _drag_value = 10 + ((_mouse_x - 210) / 180) * 190;
        if (raid_texture_crop_debug_tab == 4)
            raid_texture_crop_debug_environment_set(raid_texture_crop_debug_drag_row, _drag_value);
        else if (raid_texture_crop_debug_tab == 3)
            raid_texture_crop_debug_shadow_set(raid_texture_crop_debug_drag_row, _drag_value);
        else if (raid_texture_crop_debug_tab == 2)
            raid_texture_crop_debug_door_set(raid_texture_crop_debug_drag_row, _drag_value);
        else raid_texture_crop_debug_material_set(raid_texture_crop_debug_tab, _names[raid_texture_crop_debug_drag_row], _drag_value);
    }
    if (mouse_check_button_released(mb_left)) raid_texture_crop_debug_drag_row = -1;

    if (_pressed)
    {
        if (point_in_rectangle(_mouse_x, _mouse_y, 60, 585, 285, 613)) raid_texture_crop_debug_action(0);
        if (point_in_rectangle(_mouse_x, _mouse_y, 305, 585, 530, 613)) raid_texture_crop_debug_action(1);
        if (point_in_rectangle(_mouse_x, _mouse_y, 60, 625, 285, 653)) raid_texture_crop_debug_action(2);
        if (point_in_rectangle(_mouse_x, _mouse_y, 305, 625, 530, 653)) raid_texture_crop_debug_action(3);
    }
}


function raid_texture_crop_debug_action(_action)
{
    raid_texture_crop_debug_selection = 20 + _action;
    switch (_action)
    {
        case 0:
            raid_texture_crop_debug_reset(raid_texture_crop_debug_tab);
            raid_texture_crop_debug_status = raid_texture_crop_debug_tab == 4 ? "ENVIRONMENT RESET"
                : (raid_texture_crop_debug_tab == 3 ? "PLAYER SHADOW RESET"
                : (raid_texture_crop_debug_tab == 2 ? "DOOR VALUES RESET" : "CURRENT MATERIAL RESET"));
        break;
        case 1:
            raid_texture_crop_debug_reset(0);
            raid_texture_crop_debug_reset(1);
            raid_texture_crop_debug_reset(2);
            raid_texture_crop_debug_reset(3);
            raid_texture_crop_debug_reset(4);
            raid_texture_crop_debug_status = "ALL VALUES RESET";
        break;
        case 2: raid_texture_crop_debug_save(); break;
        case 3: raid_texture_crop_debug_copy(); break;
    }
}
