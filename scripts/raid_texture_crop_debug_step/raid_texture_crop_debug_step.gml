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
        raid_texture_crop_debug_tab = 1 - raid_texture_crop_debug_tab;
        raid_texture_crop_debug_selection = min(raid_texture_crop_debug_selection, 9);
    }
    if (keyboard_check_pressed(vk_up)) raid_texture_crop_debug_selection = max(0, raid_texture_crop_debug_selection - 1);
    if (keyboard_check_pressed(vk_down)) raid_texture_crop_debug_selection = min(13, raid_texture_crop_debug_selection + 1);

    var _names = ["crop_left", "crop_right", "crop_top", "crop_bottom", "offset_x", "offset_y", "uv_offset_u", "uv_offset_v", "scale_x", "scale_y"];
    if (raid_texture_crop_debug_selection < 10)
    {
        var _material = raid_texture_crop_debug_material();
        var _name = _names[raid_texture_crop_debug_selection];
        var _change = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
        if (_change != 0)
            raid_texture_crop_debug_set(_material, _name, variable_struct_get(_material, _name) + _change);
    }
    else if (keyboard_check_pressed(vk_enter))
    {
        raid_texture_crop_debug_action(raid_texture_crop_debug_selection - 10);
    }

    raid_texture_crop_debug_mouse_input();
    return true;
}


function raid_texture_crop_debug_mouse_input()
{
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var _pressed = mouse_check_button_pressed(mb_left);

    if (_pressed && point_in_rectangle(_mouse_x, _mouse_y, 60, 110, 290, 140))
    {
        raid_texture_crop_debug_tab = 0;
        raid_texture_crop_debug_selection = min(raid_texture_crop_debug_selection, 9);
    }
    if (_pressed && point_in_rectangle(_mouse_x, _mouse_y, 300, 110, 530, 140))
    {
        raid_texture_crop_debug_tab = 1;
        raid_texture_crop_debug_selection = min(raid_texture_crop_debug_selection, 9);
    }

    var _material = raid_texture_crop_debug_material();
    var _names = ["crop_left", "crop_right", "crop_top", "crop_bottom", "offset_x", "offset_y", "uv_offset_u", "uv_offset_v", "scale_x", "scale_y"];
    for (var _row = 0; _row < 10; _row++)
    {
        var _row_y = 165 + _row * 40;
        if (_pressed && point_in_rectangle(_mouse_x, _mouse_y, 210, _row_y, 390, _row_y + 24))
        {
            raid_texture_crop_debug_selection = _row;
            raid_texture_crop_debug_drag_row = _row;
        }
        if (_pressed && point_in_rectangle(_mouse_x, _mouse_y, 410, _row_y, 442, _row_y + 24))
        {
            raid_texture_crop_debug_selection = _row;
            raid_texture_crop_debug_set(_material, _names[_row], variable_struct_get(_material, _names[_row]) - 1);
        }
        if (_pressed && point_in_rectangle(_mouse_x, _mouse_y, 510, _row_y, 542, _row_y + 24))
        {
            raid_texture_crop_debug_selection = _row;
            raid_texture_crop_debug_set(_material, _names[_row], variable_struct_get(_material, _names[_row]) + 1);
        }
    }

    if (raid_texture_crop_debug_drag_row >= 0 && mouse_check_button(mb_left))
    {
        var _drag_name = _names[raid_texture_crop_debug_drag_row];
        var _drag_value;
        if (raid_texture_crop_debug_drag_row < 6)
            _drag_value = ((_mouse_x - 210) / 180) * 90 - 45;
        else if (raid_texture_crop_debug_drag_row < 8)
            _drag_value = ((_mouse_x - 210) / 180) * 200 - 100;
        else
            _drag_value = 10 + ((_mouse_x - 210) / 180) * 190;
        raid_texture_crop_debug_set(_material, _drag_name, _drag_value);
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
    raid_texture_crop_debug_selection = 10 + _action;
    switch (_action)
    {
        case 0:
            raid_texture_crop_debug_reset(raid_texture_crop_debug_tab);
            raid_texture_crop_debug_status = "CURRENT MATERIAL RESET";
        break;
        case 1:
            raid_texture_crop_debug_reset(0);
            raid_texture_crop_debug_reset(1);
            raid_texture_crop_debug_status = "ALL MATERIALS RESET";
        break;
        case 2: raid_texture_crop_debug_save(); break;
        case 3: raid_texture_crop_debug_copy(); break;
    }
}
