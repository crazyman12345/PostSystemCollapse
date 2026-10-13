function step_hideout()
{
    if (hideout_focus == HideoutFocus.SIDEBAR)
    {
        if (keyboard_check_pressed(ord("W")))
        {
            repeat (array_length(hideout_menu_items))
            {
                hideout_menu_index--;
                if (hideout_menu_index < 0) hideout_menu_index = array_length(hideout_menu_items) - 1;

                var entry = hideout_menu_items[hideout_menu_index];
                if (entry.bench_key == "" || variable_struct_get(workshop_progress, entry.bench_key) > 0)
                    break;
            }
			scroll_sound();
        }

        if (keyboard_check_pressed(ord("S")))
        {
            repeat (array_length(hideout_menu_items))
            {
                hideout_menu_index++;
                if (hideout_menu_index >= array_length(hideout_menu_items)) hideout_menu_index = 0;

                var entry = hideout_menu_items[hideout_menu_index];
                if (entry.bench_key == "" || variable_struct_get(workshop_progress, entry.bench_key) > 0)
                    break;
            }
			scroll_sound();
        }

        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);
        var hover_index = -1;
        var item_y = 85;
        for (var i = 0; i < array_length(hideout_menu_items); i++)
        {
            var hover_entry = hideout_menu_items[i];
            if (hover_entry.header != "") item_y += 50;
            if (_mouse_x >= 25 && _mouse_x <= 295 && _mouse_y >= item_y && _mouse_y < item_y + 34
                && (hover_entry.bench_key == "" || variable_struct_get(workshop_progress, hover_entry.bench_key) > 0)) hover_index = i;
            item_y += 34;
            if (hover_entry.key == "workshop" || hover_entry.key == "drugmaking") item_y += 30;
        }

        if (hover_index != -1 && hideout_menu_index != hover_index)
        {
            hideout_menu_index = hover_index;
            scroll_sound();
        }

        var selected = hideout_menu_items[hideout_menu_index];
        hideout_page = selected.page;

        if (keyboard_check_pressed(vk_enter) || (hover_index != -1 && mouse_check_button_pressed(mb_left)))
        {
            if (selected.bench_key != "" && variable_struct_get(workshop_progress, selected.bench_key) <= 0)
                return;

            hideout_focus = HideoutFocus.CONTENT;

            if (variable_struct_exists(recipe_db, selected.key))
            {
                crafting_recipe_index = 0;
                crafting_recipe_scroll = 0;
                crafting_message = "";
            }
			audio_play_sound(snd_interact,0,false);
        }

        return;
    }

    switch (hideout_page)
    {
        case HideoutPage.TRADERS: step_hideout_traders(); break;
        case HideoutPage.STASH: step_hideout_stash(); break;
        case HideoutPage.SKILLS: step_hideout_skills(); break;
        case HideoutPage.SALVAGE: step_hideout_salvage(); break;

        case HideoutPage.GUNMAKING: step_hideout_crafting("gunmaking"); break;
        case HideoutPage.ARMORCRAFTING: step_hideout_crafting("armorcrafting"); break;
        case HideoutPage.DRUG_LAB: step_hideout_crafting("drugmaking"); break;
        case HideoutPage.MEDICAL_CRAFTING: step_hideout_crafting("medical_crafting"); break;

        case HideoutPage.RAIDS: step_hideout_raid(); break;
        case HideoutPage.WORKSHOP: step_workshop(); break;
    }
}

function step_hideout_skills()
{
    var previous_tab = hideout_skills_index;
    hideout_skills_index = terminal_menu_input(hideout_skills_index, array_length(hideout_skill_tabs));
    if (hideout_skills_index != previous_tab)
    {
        hideout_skill_tree_store_view(previous_tab);
        hideout_skill_node_index = 0;
        skill_tree_drag_active = false;
        skill_tree_dragging = false;
        hideout_skill_tree_load_view(hideout_skills_index);
    }

    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var tab_x = 340;
    for (var i = 0; i < array_length(hideout_skill_tabs); i++)
    {
        var tab_width = hideout_skill_tab_width(i);
        if (_mouse_x >= tab_x && _mouse_x <= tab_x + tab_width && _mouse_y >= 80 && _mouse_y <= 138
            && mouse_check_button_pressed(mb_left) && hideout_skills_index != i)
        {
            hideout_skill_tree_store_view(hideout_skills_index);
            hideout_skills_index = i;
            hideout_skill_node_index = 0;
            skill_tree_drag_active = false;
            skill_tree_dragging = false;
            hideout_skill_tree_load_view(hideout_skills_index);
            scroll_sound();
            break;
        }
        tab_x += tab_width + 8;
    }

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
        if (keyboard_check_pressed(ord("A")))
        {
            hideout_skill_node_index--;
            if (hideout_skill_node_index < 0) hideout_skill_node_index = array_length(nodes) - 1;
            scroll_sound();
        }
        if (keyboard_check_pressed(ord("D")))
        {
            hideout_skill_node_index++;
            if (hideout_skill_node_index >= array_length(nodes)) hideout_skill_node_index = 0;
            scroll_sound();
        }

        if (mouse_in_tree && mouse_check_button_pressed(mb_left))
        {
            skill_tree_drag_active = true;
            skill_tree_dragging = false;
            skill_tree_drag_start_x = _mouse_x;
            skill_tree_drag_start_y = _mouse_y;
            skill_tree_drag_last_x = _mouse_x;
            skill_tree_drag_last_y = _mouse_y;
            skill_tree_pressed_node = -1;
            for (var node_index = 0; node_index < array_length(nodes); node_index++)
            {
                var node = nodes[node_index];
                var node_x = hideout_skill_tree_world_to_screen_x(hideout_skill_node_world_x(node), tree_viewport);
                var node_y = hideout_skill_tree_world_to_screen_y(hideout_skill_node_world_y(node), tree_viewport);
                var node_half_size = (node.unlock_type == SkillNodeUnlockType.INFO ? 30 : 34) * skill_tree_zoom;
                if (point_in_rectangle(_mouse_x, _mouse_y, node_x - node_half_size, node_y - node_half_size,
                    node_x + node_half_size, node_y + node_half_size))
                {
                    skill_tree_pressed_node = node_index;
                    break;
                }
            }
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
                    if (hideout_skill_node_index != skill_tree_pressed_node) scroll_sound();
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
