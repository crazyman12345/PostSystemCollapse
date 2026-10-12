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

    draw_set_color(c_black);
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

        draw_set_color(c_black);
        draw_rectangle(tab_x, tabs_top, tab_x + tab_width, tab_bottom, false);

        if (selected)
        {
            selected_tab_left = tab_x;
            selected_tab_right = tab_x + tab_width;
            draw_set_color(c_lime);
            draw_line(tab_x, panel_top, tab_x, tabs_top);
            draw_line(tab_x, tabs_top, tab_x + tab_width, tabs_top);
            draw_line(tab_x + tab_width, tabs_top, tab_x + tab_width, panel_top);
        }
        else
        {
            draw_set_color(c_green);
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
                draw_sprite_ext(skill.icon, 0, icon_left + icon_size * 0.5, tabs_top + tab_height * 0.5, icon_scale, icon_scale, 0, c_green, 1);
            }
            text_x += 48;
        }

        draw_text(text_x, tabs_top + 17, hideout_skill_tab_name(i));
        tab_x += tab_width + tab_gap;
    }

    draw_set_color(c_lime);
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

    draw_set_color(c_lime);
    draw_text(info_left, info_top, "LV. " + string(selected_progress.level));
    draw_set_halign(fa_right);
    draw_text(info_right, info_top, "XP: " + string(selected_progress.xp) + " / " + string(next_level_xp));
    draw_set_halign(fa_left);

    var progress_top = info_top + 30;
    draw_set_color(c_green);
    draw_rectangle(info_left, progress_top, info_right, progress_top + 12, true);
    draw_set_color(c_lime);
    draw_rectangle(info_left, progress_top, info_left + (info_right - info_left) * progress, progress_top + 12, false);

    var tree_top = info_top + 65;
    var tree_height = panel_bottom - tree_top - 70;
    terminal_panel(info_left, tree_top, info_right - info_left, tree_height, "SKILL TREE");

    var nodes = skill_node_get_nodes(selected_skill.key);
    var node_help = "[W/S] TAB    [A/D OR MOUSE] NODE    [ENTER] UNLOCK    [ESC] BACK";
    var detail_width = 390;
    var detail_left = info_right - detail_width;
    var graph_left = info_left + 45;
    var graph_right = detail_left - 35;
    var graph_top = tree_top + 65;
    var graph_bottom = tree_top + tree_height - 105;

    if (array_length(nodes) <= 0)
    {
        draw_set_halign(fa_center);
        draw_set_color(c_gray);
        draw_text((graph_left + graph_right) * 0.5, tree_top + tree_height * 0.5, "[ NO SKILL NODES ]");
    }
    else
    {
        hideout_skill_node_index = clamp(hideout_skill_node_index, 0, array_length(nodes) - 1);

        // Draw prerequisite connections before nodes.
        for (var node_index = 0; node_index < array_length(nodes); node_index++)
        {
            var node = nodes[node_index];
            var node_x = hideout_skill_node_x(node, graph_left, graph_right);
            var node_y = hideout_skill_node_y(node, nodes, graph_top, graph_bottom);
            for (var prerequisite_index = 0; prerequisite_index < array_length(node.prerequisites); prerequisite_index++)
            {
                var prerequisite = skill_node_find(nodes, node.prerequisites[prerequisite_index]);
                if (is_undefined(prerequisite)) continue;
                var prerequisite_x = hideout_skill_node_x(prerequisite, graph_left, graph_right);
                var prerequisite_y = hideout_skill_node_y(prerequisite, nodes, graph_top, graph_bottom);
                draw_set_color(skill_node_is_unlocked(selected_skill.key, prerequisite) ? c_green : c_dkgray);
                draw_line(prerequisite_x, prerequisite_y, node_x, node_y);
            }
        }

        for (var node_index = 0; node_index < array_length(nodes); node_index++)
        {
            var node = nodes[node_index];
            var node_x = hideout_skill_node_x(node, graph_left, graph_right);
            var node_y = hideout_skill_node_y(node, nodes, graph_top, graph_bottom);
            var unlocked = skill_node_is_unlocked(selected_skill.key, node);
            var available = skill_node_can_purchase(selected_skill.key, node);
            var selected = node_index == hideout_skill_node_index;
            var informational = node.unlock_type == SkillNodeUnlockType.INFO;
            var half_size = informational ? 30 : 34;

            draw_set_color(informational ? c_black : (unlocked ? c_green : c_black));
            draw_rectangle(node_x - half_size, node_y - half_size, node_x + half_size, node_y + half_size, false);
            draw_set_color(informational ? c_green : (unlocked || available ? c_lime : c_dkgray));
            draw_rectangle(node_x - half_size, node_y - half_size, node_x + half_size, node_y + half_size, true);
            if (selected)
            {
                draw_set_color(c_white);
                draw_rectangle(node_x - half_size - 4, node_y - half_size - 4, node_x + half_size + 4, node_y + half_size + 4, true);
            }

            if (node.icon == -1)
            {
                draw_set_color(informational ? c_green : (unlocked || available ? c_lime : c_gray));
                if (!informational) draw_rectangle(node_x - 14, node_y - 14, node_x + 14, node_y + 14, true);
                draw_set_halign(fa_center);
                draw_text(node_x, node_y - 10, informational ? "i" : "?");
            }
            else
            {
                var icon_scale = min(48 / sprite_get_width(node.icon), 48 / sprite_get_height(node.icon));
                draw_sprite_ext(node.icon, 0, node_x, node_y, icon_scale, icon_scale, 0, c_white, 1);
            }

            draw_set_halign(fa_center);
            draw_set_color(unlocked || available ? c_lime : c_gray);
            draw_text_ext(node_x, node_y + 43, node.name + "\nLV. " + string(node.required_level), 18, 175);
        }

        var selected_node = nodes[hideout_skill_node_index];
        var selected_informational = selected_node.unlock_type == SkillNodeUnlockType.INFO;
        if (selected_informational) node_help = "[W/S] TAB    [A/D OR MOUSE] NODE    [ESC] BACK";
        var selected_unlocked = skill_node_is_unlocked(selected_skill.key, selected_node);
        var selected_available = skill_node_can_purchase(selected_skill.key, selected_node);
        terminal_panel(detail_left, tree_top + 40, detail_width, tree_height - 60, "NODE DETAILS");
        draw_set_halign(fa_left);
        draw_set_color(c_lime);
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
        draw_set_color(selected_unlocked || selected_available ? c_lime : c_gray);
        draw_text(detail_left + 20, tree_top + 220, "STATUS: " + status);
        draw_set_color(c_gray);
        draw_text_ext(detail_left + 20, tree_top + 270, selected_node.description, 24, detail_width - 40);
    }

    draw_set_color(c_lime);
    draw_set_halign(fa_center);
    draw_text((tabs_left + gui_w) * 0.5, gui_h - 40, node_help);
    draw_set_halign(fa_left);
}

function hideout_skill_node_x(_node, _left, _right)
{
    var lane_spacing = min(190, (_right - _left) * 0.22);
    return (_left + _right) * 0.5 + _node.lane * lane_spacing;
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
