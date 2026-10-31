function draw_hideout_skills()
{
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    var tabs_left = 340;
    var tabs_top = 80;
    var tab_height = 58;
    var tab_gap = 8;
    var panel_top = tabs_top + tab_height;
    var panel_bottom = gui_h - 70;
    var content_left = tabs_left;
    var content_width = gui_w - content_left - 20;
    var panel_height = panel_bottom - panel_top;
    var selected_skill = hideout_skill_tabs[hideout_skills_index];

    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_color(global.hideout_panel_color);
    draw_rectangle(content_left, panel_top, content_left + content_width, panel_bottom, false);

    var tab_x = tabs_left;
    var selected_tab_left = tabs_left;
    var selected_tab_right = tabs_left;
    for (var i = 0; i < array_length(hideout_skill_tabs); i++)
    {
        var skill = hideout_skill_tabs[i];
        var selected = i == hideout_skills_index;
        var tab_width = hideout_skill_tab_width(i);
        var tab_bottom = selected ? panel_top : panel_top - tab_gap;

        draw_set_color(global.hideout_background_color);
        draw_rectangle(tab_x, tabs_top, tab_x + tab_width, tab_bottom, false);

        if (selected)
        {
            selected_tab_left = tab_x;
            selected_tab_right = tab_x + tab_width;
            draw_set_color(global.ui_interactive_color);
            draw_line(tab_x, panel_top, tab_x, tabs_top);
            draw_line(tab_x, tabs_top, tab_x + tab_width, tabs_top);
            draw_line(tab_x + tab_width, tabs_top, tab_x + tab_width, panel_top);
        }
        else
        {
            draw_set_color(global.ui_interactive_color);
            draw_rectangle(tab_x, tabs_top, tab_x + tab_width, tab_bottom, true);
        }

        var text_x = tab_x + 16;
        if (selected)
        {
            var icon_size = 36;
            var icon_left = tab_x + 14;
            if (skill.icon != -1)
            {
                var icon_scale = min(icon_size / sprite_get_width(skill.icon), icon_size / sprite_get_height(skill.icon));
                draw_sprite_ext(skill.icon, icon_spin_frame(skill.icon), icon_left + icon_size * 0.5, tabs_top + tab_height * 0.5, icon_scale, icon_scale, 0, global.hideout_secondary_color, 1);
            }
            text_x += 48;
        }

        draw_text(text_x, tabs_top + 17, hideout_skill_tab_name(i));
        tab_x += tab_width + tab_gap;
    }

    draw_set_color(global.ui_text_color);
    draw_line(content_left, panel_top, selected_tab_left, panel_top);
    draw_line(selected_tab_right, panel_top, content_left + content_width, panel_top);
    draw_line(content_left, panel_top, content_left, panel_bottom);
    draw_line(content_left + content_width, panel_top, content_left + content_width, panel_bottom);
    draw_line(content_left, panel_bottom, content_left + content_width, panel_bottom);

    draw_set_halign(fa_center);
    draw_text(content_left + content_width * 0.5, panel_top + 7, "[ " + selected_skill.name + " ]");
    draw_set_halign(fa_left);

    var info_left = content_left + 35;
    var info_right = content_left + content_width - 35;
    var info_top = panel_top + 65;

    var selected_progress = variable_struct_get(player_skills, selected_skill.key);
    var level_xp_start = skill_xp_for_level(selected_progress.level);
    var next_level_xp = skill_xp_for_level(selected_progress.level + 1);
    var progress = (selected_progress.xp - level_xp_start) / (next_level_xp - level_xp_start);
    progress = clamp(progress, 0, 1);

    draw_set_color(global.ui_text_color);
    draw_text(info_left, info_top, "LV. " + string(selected_progress.level));
    draw_set_halign(fa_right);
    draw_text(info_right, info_top, "XP: " + string(selected_progress.xp) + " / " + string(next_level_xp));
    draw_set_halign(fa_left);

    var progress_top = info_top + 30;
    draw_set_color(global.hideout_border_subtle_color);
    draw_rectangle(info_left, progress_top, info_right, progress_top + 12, true);
    draw_set_color(global.ui_text_color);
    draw_rectangle(info_left, progress_top, info_left + (info_right - info_left) * progress, progress_top + 12, false);

    var tree_top = info_top + 65;
    var tree_height = panel_bottom - tree_top - 70;
    terminal_panel(info_left, tree_top, info_right - info_left, tree_height, "SKILL TREE");

    var nodes = skill_node_get_nodes(selected_skill.key);
    var detail_width = 390;
    var detail_left = info_right - detail_width;
    var graph_left = info_left + 45;
    var graph_right = detail_left - 35;
    var graph_top = tree_top + 65;
    var graph_bottom = tree_top + tree_height - 105;
    var tree_viewport = hideout_skill_tree_viewport();

    if (array_length(nodes) <= 0)
    {
        draw_set_halign(fa_center);
        draw_set_color(c_gray);
        draw_text((graph_left + graph_right) * 0.5, tree_top + tree_height * 0.5, "[ NO SKILL NODES ]");
    }
    else
    {
        hideout_skill_node_index = clamp(hideout_skill_node_index, 0, array_length(nodes) - 1);
        if (!skill_tree_views[hideout_skills_index].initialized)
            hideout_skill_tree_reset_view(nodes, tree_viewport);

        var previous_scissor = hideout_skill_tree_begin_clip(tree_viewport);

        // Draw prerequisite connections before nodes.
        for (var node_index = 0; node_index < array_length(nodes); node_index++)
        {
            var node = nodes[node_index];
            var node_x = hideout_skill_tree_world_to_screen_x(hideout_skill_node_world_x(node), tree_viewport);
            var node_y = hideout_skill_tree_world_to_screen_y(hideout_skill_node_world_y(node), tree_viewport);
            for (var prerequisite_index = 0; prerequisite_index < array_length(node.prerequisites); prerequisite_index++)
            {
                var prerequisite = skill_node_find(nodes, node.prerequisites[prerequisite_index]);
                if (is_undefined(prerequisite)) continue;
                var prerequisite_x = hideout_skill_tree_world_to_screen_x(hideout_skill_node_world_x(prerequisite), tree_viewport);
                var prerequisite_y = hideout_skill_tree_world_to_screen_y(hideout_skill_node_world_y(prerequisite), tree_viewport);
                draw_set_color(skill_node_is_unlocked(selected_skill.key, prerequisite) ? global.hideout_border_color : global.hideout_muted_color);
                draw_line(prerequisite_x, prerequisite_y, node_x, node_y);
            }
        }

        for (var node_index = 0; node_index < array_length(nodes); node_index++)
        {
            var node = nodes[node_index];
            var node_x = hideout_skill_tree_world_to_screen_x(hideout_skill_node_world_x(node), tree_viewport);
            var node_y = hideout_skill_tree_world_to_screen_y(hideout_skill_node_world_y(node), tree_viewport);
            var unlocked = skill_node_is_unlocked(selected_skill.key, node);
            var available = skill_node_can_purchase(selected_skill.key, node);
            var selected = node_index == hideout_skill_node_index;
            var informational = node.unlock_type == SkillNodeUnlockType.INFO;
            var half_size = (informational ? 30 : 34) * skill_tree_zoom;

            draw_set_color(informational ? global.hideout_background_color : (unlocked ? global.hideout_raised_color : global.hideout_background_color));
            draw_rectangle(node_x - half_size, node_y - half_size, node_x + half_size, node_y + half_size, false);
            draw_set_color(informational ? global.ui_interactive_color : (unlocked || available ? global.ui_interactive_color : c_dkgray));
            draw_rectangle(node_x - half_size, node_y - half_size, node_x + half_size, node_y + half_size, true);
            if (selected)
            {
                draw_set_color(c_white);
                var selection_border = 4 * skill_tree_zoom;
                draw_rectangle(node_x - half_size - selection_border, node_y - half_size - selection_border,
                    node_x + half_size + selection_border, node_y + half_size + selection_border, true);
            }

            if (node.icon == -1)
            {
                draw_set_color(informational ? global.ui_interactive_color : (unlocked || available ? global.ui_interactive_color : c_gray));
                if (!informational) draw_rectangle(node_x - 14 * skill_tree_zoom, node_y - 14 * skill_tree_zoom,
                    node_x + 14 * skill_tree_zoom, node_y + 14 * skill_tree_zoom, true);
                draw_set_halign(fa_center);
                draw_text_transformed(node_x, node_y - 10 * skill_tree_zoom, informational ? "i" : "?", skill_tree_zoom, skill_tree_zoom, 0);
            }
            else
            {
                var icon_scale = min(48 / sprite_get_width(node.icon), 48 / sprite_get_height(node.icon));
                draw_sprite_ext(node.icon, icon_spin_frame(node.icon), node_x, node_y, icon_scale * skill_tree_zoom, icon_scale * skill_tree_zoom, 0, c_white, 1);
            }

            draw_set_halign(fa_center);
            draw_set_color(unlocked || available ? global.ui_interactive_color : c_gray);
            draw_set_font(fnt_terminal_tiny);
            draw_text_ext_transformed(node_x, node_y + 43 * skill_tree_zoom, node.name + "\nLV. " + string(node.required_level),
                18, 175, skill_tree_zoom, skill_tree_zoom, 0);
            draw_set_font(fnt_terminal_small);
        }

        hideout_skill_tree_end_clip(previous_scissor);

        var selected_node = nodes[hideout_skill_node_index];
        var selected_informational = selected_node.unlock_type == SkillNodeUnlockType.INFO;
        var selected_unlocked = skill_node_is_unlocked(selected_skill.key, selected_node);
        var selected_available = skill_node_can_purchase(selected_skill.key, selected_node);
        terminal_panel(detail_left, tree_top + 40, detail_width, tree_height - 60, "NODE DETAILS");
        draw_set_halign(fa_left);
        draw_set_color(global.ui_text_color);
        draw_text(detail_left + 20, tree_top + 85, selected_node.name);
        draw_set_color(c_gray);
        draw_text(detail_left + 20, tree_top + 120, "REQUIRED LEVEL: " + string(selected_node.required_level));
        var node_type = selected_informational ? "INFO" : (selected_node.unlock_type == SkillNodeUnlockType.LEVEL ? "LEVEL" : "MONEY");
        draw_text(detail_left + 20, tree_top + 150, "TYPE: " + node_type);
        if (selected_node.unlock_type == SkillNodeUnlockType.MONEY)
            draw_text(detail_left + 20, tree_top + 180, "COST: $" + string(selected_node.cost));

        var status = "LOCKED";
        if (selected_unlocked) status = "UNLOCKED";
        else if (selected_available) status = get_cash() >= selected_node.cost ? "AVAILABLE" : "NEED MORE CASH";
        else if (skill_get_level(selected_skill.key) < selected_node.required_level) status = "LEVEL TOO LOW";
        else status = "PREREQUISITE LOCKED";
        draw_set_color(selected_unlocked || selected_available ? global.ui_text_color : c_gray);
        draw_text(detail_left + 20, tree_top + 220, "STATUS: " + status);
        draw_set_color(c_gray);
        draw_text_ext(detail_left + 20, tree_top + 270, selected_node.description, 24, detail_width - 40);
    }

    draw_set_halign(fa_left);
}

function hideout_skill_node_x(_node, _left, _right)
{
    var lane_spacing = min(190, (_right - _left) * 0.22);
    return (_left + _right) * 0.5 + _node.lane * lane_spacing;
}

function hideout_skill_node_world_x(_node)
{
    return _node.lane * 190;
}

function hideout_skill_node_world_y(_node)
{
    return -(_node.required_level - 1) * 32;
}

function hideout_skill_tree_viewport()
{
    var info_left = 375;
    var info_right = display_get_gui_width() - 55;
    var tree_top = 268;
    var tree_height = display_get_gui_height() - 408;
    var detail_left = info_right - 390;
    return {
        left: info_left + 10,
        top: tree_top + 35,
        right: detail_left - 10,
        bottom: tree_top + tree_height - 10,
        width: detail_left - info_left - 20,
        height: tree_height - 45
    };
}

function hideout_skill_tree_world_to_screen_x(_world_x, _viewport)
{
    return _viewport.left + (_world_x - skill_tree_camera_x) * skill_tree_zoom;
}

function hideout_skill_tree_world_to_screen_y(_world_y, _viewport)
{
    return _viewport.top + (_world_y - skill_tree_camera_y) * skill_tree_zoom;
}

function hideout_skill_tree_screen_to_world_x(_screen_x, _viewport, _zoom = skill_tree_zoom)
{
    return skill_tree_camera_x + (_screen_x - _viewport.left) / _zoom;
}

function hideout_skill_tree_screen_to_world_y(_screen_y, _viewport, _zoom = skill_tree_zoom)
{
    return skill_tree_camera_y + (_screen_y - _viewport.top) / _zoom;
}

function hideout_skill_tree_get_bounds(_nodes)
{
    var min_x = 0;
    var max_x = 0;
    var min_y = 0;
    var max_y = 0;
    for (var i = 0; i < array_length(_nodes); i++)
    {
        var node_x = hideout_skill_node_world_x(_nodes[i]);
        var node_y = hideout_skill_node_world_y(_nodes[i]);
        min_x = min(min_x, node_x);
        max_x = max(max_x, node_x);
        min_y = min(min_y, node_y);
        max_y = max(max_y, node_y);
    }
    return { left: min_x - 180, right: max_x + 180, top: min_y - 140, bottom: max_y + 140 };
}

function hideout_skill_tree_clamp_camera(_nodes, _viewport)
{
    var bounds = hideout_skill_tree_get_bounds(_nodes);
    var visible_width = _viewport.width / skill_tree_zoom;
    var visible_height = _viewport.height / skill_tree_zoom;

    if (visible_width >= bounds.right - bounds.left)
        skill_tree_camera_x = (bounds.left + bounds.right - visible_width) * 0.5;
    else
        skill_tree_camera_x = clamp(skill_tree_camera_x, bounds.left, bounds.right - visible_width);

    if (visible_height >= bounds.bottom - bounds.top)
        skill_tree_camera_y = (bounds.top + bounds.bottom - visible_height) * 0.5;
    else
        skill_tree_camera_y = clamp(skill_tree_camera_y, bounds.top, bounds.bottom - visible_height);
}

function hideout_skill_tree_reset_view(_nodes, _viewport)
{
    skill_tree_zoom = 1;
    var center_x = 0;
    var center_y = 0;
    if (array_length(_nodes) > 0)
    {
        center_x = hideout_skill_node_world_x(_nodes[0]);
        center_y = hideout_skill_node_world_y(_nodes[0]);
    }
    skill_tree_camera_x = center_x - _viewport.width * 0.5;
    skill_tree_camera_y = center_y - _viewport.height * 0.5;
    hideout_skill_tree_clamp_camera(_nodes, _viewport);
    hideout_skill_tree_store_view(hideout_skills_index);
}

function hideout_skill_tree_store_view(_skill_index)
{
    skill_tree_views[_skill_index].camera_x = skill_tree_camera_x;
    skill_tree_views[_skill_index].camera_y = skill_tree_camera_y;
    skill_tree_views[_skill_index].zoom = skill_tree_zoom;
    skill_tree_views[_skill_index].initialized = true;
}

function hideout_skill_tree_load_view(_skill_index)
{
    var view = skill_tree_views[_skill_index];
    if (!view.initialized)
    {
        hideout_skill_tree_reset_view(skill_node_get_nodes(hideout_skill_tabs[_skill_index].key), hideout_skill_tree_viewport());
        return;
    }
    skill_tree_camera_x = view.camera_x;
    skill_tree_camera_y = view.camera_y;
    skill_tree_zoom = view.zoom;
    hideout_skill_tree_clamp_camera(skill_node_get_nodes(hideout_skill_tabs[_skill_index].key), hideout_skill_tree_viewport());
}

function hideout_skill_tree_begin_clip(_viewport)
{
    var previous_scissor = gpu_get_scissor();
    gpu_set_scissor(_viewport.left, _viewport.top, _viewport.width, _viewport.height);
    return previous_scissor;
}

function hideout_skill_tree_end_clip(_previous_scissor)
{
    gpu_set_scissor(_previous_scissor.x, _previous_scissor.y, _previous_scissor.w, _previous_scissor.h);
}

function hideout_skill_node_y(_node, _nodes, _top, _bottom)
{
    var max_level = 1;
    for (var i = 0; i < array_length(_nodes); i++) max_level = max(max_level, _nodes[i].required_level);
    if (max_level <= 1) return _bottom;
    return lerp(_bottom, _top, (_node.required_level - 1) / (max_level - 1));
}

function hideout_skill_tab_width(_index)
{
    draw_set_font(fnt_terminal_small);
    var tab_width = string_width(hideout_skill_tab_name(_index)) + 32;
    if (_index == hideout_skills_index) tab_width += 48;
    return tab_width;
}

function hideout_skill_tab_name(_index)
{
    var skill = hideout_skill_tabs[_index];
    if (_index == hideout_skills_index) return skill.name;

    switch (skill.key)
    {
        case "marksmanship": return "MRK";
        case "vitality": return "VIT";
        case "athleticism": return "ATH";
        case "strength": return "STR";
        case "scavenging": return "SCV";
        case "medical_crafting": return "MED";
        case "gunmaking": return "GUN";
        case "armorcrafting": return "ARM";
        case "drugmaking": return "DRG";
    }

    return string_upper(string_copy(skill.name, 1, 3));
}
