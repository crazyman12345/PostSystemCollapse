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
    if (hideout_skills_index != previous_tab) hideout_skill_node_index = 0;

    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var tab_x = 340;
    for (var i = 0; i < array_length(hideout_skill_tabs); i++)
    {
        var tab_width = hideout_skill_tab_width(i);
        if (_mouse_x >= tab_x && _mouse_x <= tab_x + tab_width && _mouse_y >= 80 && _mouse_y <= 138
            && mouse_check_button_pressed(mb_left) && hideout_skills_index != i)
        {
            hideout_skills_index = i;
            hideout_skill_node_index = 0;
            scroll_sound();
            break;
        }
        tab_x += tab_width + 8;
    }

    var selected_skill = hideout_skill_tabs[hideout_skills_index];
    var nodes = skill_node_get_nodes(selected_skill.key);
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

        var gui_h = display_get_gui_height();
        var info_left = 375;
        var info_right = display_get_gui_width() - 55;
        var tree_top = 268;
        var tree_height = gui_h - 408;
        var detail_left = info_right - 390;
        var graph_left = info_left + 45;
        var graph_right = detail_left - 35;
        var graph_top = tree_top + 65;
        var graph_bottom = tree_top + tree_height - 105;
        if (mouse_check_button_pressed(mb_left))
        {
            for (var node_index = 0; node_index < array_length(nodes); node_index++)
            {
                var node = nodes[node_index];
                var node_x = hideout_skill_node_x(node, graph_left, graph_right);
                var node_y = hideout_skill_node_y(node, nodes, graph_top, graph_bottom);
                if (_mouse_x >= node_x - 38 && _mouse_x <= node_x + 38
                    && _mouse_y >= node_y - 38 && _mouse_y <= node_y + 38)
                {
                    if (hideout_skill_node_index != node_index) scroll_sound();
                    hideout_skill_node_index = node_index;
                    break;
                }
            }
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
