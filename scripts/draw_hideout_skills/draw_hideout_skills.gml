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

    var tree_top = info_top;
    var tree_height = panel_bottom - tree_top - 70;
    terminal_panel(info_left, tree_top, info_right - info_left, tree_height, "SKILL TREE");

    draw_set_halign(fa_center);
    draw_set_color(c_gray);
    draw_text((info_left + info_right) * 0.5, tree_top + tree_height * 0.5, "[ SKILL NODES PLACEHOLDER ]");

    draw_set_color(c_lime);
    draw_text((tabs_left + gui_w) * 0.5, gui_h - 40, "[W/S] SELECT TAB    [MOUSE] SELECT TAB    [ESC] BACK");
    draw_set_halign(fa_left);
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
