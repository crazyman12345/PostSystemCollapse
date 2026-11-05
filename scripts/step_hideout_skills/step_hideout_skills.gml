function step_hideout_skills()
{
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var tab_x = 340;
    var _hovered_tab = -1;
    for (var i = 0; i < array_length(hideout_skill_tabs); i++)
    {
        var tab_width = hideout_skill_tab_width(i);
        var _tab_hovered = _mouse_x >= tab_x && _mouse_x <= tab_x + tab_width && _mouse_y >= 80 && _mouse_y <= 138;
        if (_tab_hovered) _hovered_tab = i;
        if (_tab_hovered && mouse_check_button_pressed(mb_left) && hideout_skills_index != i)
        {
            hideout_skill_tree_store_view(hideout_skills_index);
            hideout_skills_index = i;
            hideout_skill_node_index = 0;
            skill_tree_drag_active = false;
            skill_tree_dragging = false;
            hideout_skill_tree_load_view(hideout_skills_index);
            audio_play_sound(snd_interact, 0, false);
            break;
        }
        tab_x += tab_width + 8;
    }
    ui_hover_sound("hideout_skill_tabs", _hovered_tab == -1 ? "" : string(_hovered_tab));

    var selected_skill = hideout_skill_tabs[hideout_skills_index];
    var nodes = skill_node_get_nodes(selected_skill.key);
    var tree_viewport = hideout_skill_tree_viewport();
    if (!skill_tree_views[hideout_skills_index].initialized)
        hideout_skill_tree_reset_view(nodes, tree_viewport);

    var mouse_in_tree = point_in_rectangle(_mouse_x, _mouse_y, tree_viewport.left, tree_viewport.top, tree_viewport.right, tree_viewport.bottom);
    if (mouse_in_tree)
    {
        var old_zoom = skill_tree_zoom;
        if (mouse_wheel_up()) skill_tree_zoom = min(1.6, skill_tree_zoom + 0.1);
        if (mouse_wheel_down()) skill_tree_zoom = max(0.65, skill_tree_zoom - 0.1);
        if (skill_tree_zoom != old_zoom)
        {
            var cursor_world_x = hideout_skill_tree_screen_to_world_x(_mouse_x, tree_viewport, old_zoom);
            var cursor_world_y = hideout_skill_tree_screen_to_world_y(_mouse_y, tree_viewport, old_zoom);
            skill_tree_camera_x = cursor_world_x - (_mouse_x - tree_viewport.left) / skill_tree_zoom;
            skill_tree_camera_y = cursor_world_y - (_mouse_y - tree_viewport.top) / skill_tree_zoom;
            hideout_skill_tree_clamp_camera(nodes, tree_viewport);
            hideout_skill_tree_store_view(hideout_skills_index);
        }
    }

    if (array_length(nodes) > 0)
    {
        hideout_skill_node_index = clamp(hideout_skill_node_index, 0, array_length(nodes) - 1);
        var _hovered_node = -1;
        if (mouse_in_tree)
        {
            for (var _hover_node_index = 0; _hover_node_index < array_length(nodes); _hover_node_index++)
            {
                var _hover_node = nodes[_hover_node_index];
                var _hover_node_x = hideout_skill_tree_world_to_screen_x(hideout_skill_node_world_x(_hover_node), tree_viewport);
                var _hover_node_y = hideout_skill_tree_world_to_screen_y(hideout_skill_node_world_y(_hover_node), tree_viewport);
                var _hover_half_size = (_hover_node.unlock_type == SkillNodeUnlockType.INFO ? 30 : 34) * skill_tree_zoom;
                if (point_in_rectangle(_mouse_x, _mouse_y, _hover_node_x - _hover_half_size, _hover_node_y - _hover_half_size,
                    _hover_node_x + _hover_half_size, _hover_node_y + _hover_half_size))
                {
                    _hovered_node = _hover_node_index;
                    break;
                }
            }
        }
        ui_hover_sound("hideout_skill_nodes", _hovered_node == -1 ? "" : string(_hovered_node));
        if (mouse_in_tree && mouse_check_button_pressed(mb_left))
        {
            skill_tree_drag_active = true;
            skill_tree_dragging = false;
            skill_tree_drag_start_x = _mouse_x;
            skill_tree_drag_start_y = _mouse_y;
            skill_tree_drag_last_x = _mouse_x;
            skill_tree_drag_last_y = _mouse_y;
            skill_tree_pressed_node = -1;
            skill_tree_pressed_node = _hovered_node;
        }

        if (skill_tree_drag_active && mouse_check_button(mb_left))
        {
            if (!skill_tree_dragging && point_distance(skill_tree_drag_start_x, skill_tree_drag_start_y, _mouse_x, _mouse_y) >= 6)
            {
                skill_tree_dragging = true;
                skill_tree_camera_x -= (_mouse_x - skill_tree_drag_start_x) / skill_tree_zoom;
                skill_tree_camera_y -= (_mouse_y - skill_tree_drag_start_y) / skill_tree_zoom;
            }
            else if (skill_tree_dragging)
            {
                skill_tree_camera_x -= (_mouse_x - skill_tree_drag_last_x) / skill_tree_zoom;
                skill_tree_camera_y -= (_mouse_y - skill_tree_drag_last_y) / skill_tree_zoom;
            }

            if (skill_tree_dragging)
            {
                hideout_skill_tree_clamp_camera(nodes, tree_viewport);
                hideout_skill_tree_store_view(hideout_skills_index);
            }
            skill_tree_drag_last_x = _mouse_x;
            skill_tree_drag_last_y = _mouse_y;
        }

        if (skill_tree_drag_active && mouse_check_button_released(mb_left))
        {
            if (!skill_tree_dragging && mouse_in_tree && skill_tree_pressed_node >= 0)
            {
                var pressed_node = nodes[skill_tree_pressed_node];
                var pressed_x = hideout_skill_tree_world_to_screen_x(hideout_skill_node_world_x(pressed_node), tree_viewport);
                var pressed_y = hideout_skill_tree_world_to_screen_y(hideout_skill_node_world_y(pressed_node), tree_viewport);
                var pressed_half_size = (pressed_node.unlock_type == SkillNodeUnlockType.INFO ? 30 : 34) * skill_tree_zoom;
                if (point_in_rectangle(_mouse_x, _mouse_y, pressed_x - pressed_half_size, pressed_y - pressed_half_size,
                    pressed_x + pressed_half_size, pressed_y + pressed_half_size))
                {
                    if (hideout_skill_node_index != skill_tree_pressed_node) audio_play_sound(snd_interact, 0, false);
                    hideout_skill_node_index = skill_tree_pressed_node;
                }
            }
            skill_tree_drag_active = false;
            skill_tree_dragging = false;
            skill_tree_pressed_node = -1;
        }

        if (keyboard_check_pressed(vk_enter))
            skill_node_purchase(selected_skill.key, nodes[hideout_skill_node_index]);
    }

    if (keyboard_check_pressed(vk_escape))
    {
        audio_play_sound(snd_interact, 0, false);
        hideout_focus = HideoutFocus.SIDEBAR;
    }
}
