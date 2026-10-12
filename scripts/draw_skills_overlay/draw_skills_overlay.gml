function draw_skills_overlay()
{
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    var panel_w = min(1000, gui_w - 60);
    var x1 = gui_w - panel_w - 30;
    var y1 = 40;
    var x2 = gui_w - 30;
    var y2 = gui_h - 40;
    var skill_count = array_length(hideout_skill_tabs);

    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_rectangle(x1, y1, x2, y2, false);
    draw_set_color(c_lime);
    draw_ascii_rectangle(x1, y1, x2, y2);

    draw_text(x1 + 30, y1 + 25, "PLAYER SKILLS");
    draw_text(x1 + 30, y1 + 55, "--------------------------------------------------");

    if (skill_count <= 0)
    {
        draw_text(x1 + 35, y1 + 105, "NO SKILLS AVAILABLE");
        draw_text(x1 + 35, y2 - 50, "[K/ESC] CLOSE");
        return;
    }

    skills_index = clamp(skills_index, 0, skill_count - 1);

    var list_x = x1 + 35;
    var list_y = y1 + 100;
    var list_w = 390;
    var row_h = min(58, floor((y2 - list_y - 80) / skill_count));

    for (var i = 0; i < skill_count; i++)
    {
        var skill = hideout_skill_tabs[i];
        var progress = variable_struct_get(player_skills, skill.key);
        var row_y = list_y + i * row_h;
        var selected = i == skills_index;

        if (selected)
        {
            draw_set_color(c_green);
            draw_rectangle(list_x - 8, row_y - 4, list_x + list_w, row_y + row_h - 6, false);
            draw_set_color(c_lime);
            draw_rectangle(list_x - 8, row_y - 4, list_x + list_w, row_y + row_h - 6, true);
        }

        var text_x = list_x + 28;
        var icon_size = max(16, row_h - 16);
        if (skill.icon != -1)
        {
            var icon_scale = min(icon_size / sprite_get_width(skill.icon), icon_size / sprite_get_height(skill.icon));
            draw_sprite_ext(skill.icon, 0, list_x + icon_size * 0.5, row_y + icon_size * 0.5, icon_scale, icon_scale, 0, selected ? c_lime : c_green, 1);
            text_x = list_x + icon_size + 14;
        }

        draw_set_color(selected ? c_lime : c_green);
        draw_set_font(fnt_ascii);
        draw_text(text_x, row_y + 8, skill.name);
        draw_set_font(fnt_terminal_small);
        draw_set_halign(fa_right);
        draw_text(list_x + list_w - 12, row_y + 8, "LV. " + string(progress.level));
        draw_set_halign(fa_left);
    }

    var detail_x = list_x + list_w + 55;
    var detail_right = x2 - 35;
    var selected_skill = hideout_skill_tabs[skills_index];
    var selected_def = skill_db_get(selected_skill.key);
    var selected_progress = variable_struct_get(player_skills, selected_skill.key);
    var level_xp_start = skill_xp_for_level(selected_progress.level);
    var next_level_xp = skill_xp_for_level(selected_progress.level + 1);
    var level_xp = selected_progress.xp - level_xp_start;
    var level_xp_required = next_level_xp - level_xp_start;
    var progress_percent = clamp(level_xp / level_xp_required, 0, 1);

    draw_set_color(c_green);
    draw_line(detail_x - 28, list_y - 15, detail_x - 28, y2 - 80);
    draw_set_color(c_lime);
    draw_text(detail_x, list_y, selected_def.name);
    draw_text(detail_x, list_y + 45, "LEVEL " + string(selected_progress.level));

    var progress_y = list_y + 95;
    draw_set_color(c_green);
    draw_rectangle(detail_x, progress_y, detail_right, progress_y + 14, true);
    draw_set_color(c_lime);
    draw_rectangle(detail_x, progress_y, detail_x + (detail_right - detail_x) * progress_percent, progress_y + 14, false);
    draw_text(detail_x, progress_y + 28, "LEVEL XP: " + string(level_xp) + " / " + string(level_xp_required));
    draw_text(detail_x, progress_y + 63, "TOTAL XP: " + string(selected_progress.xp));

    draw_set_color(c_green);
    draw_text(detail_x, progress_y + 120, "DESCRIPTION");
    draw_set_color(c_lime);
    draw_text_ext(detail_x, progress_y + 155, selected_def.description, 28, detail_right - detail_x);

    draw_set_color(c_lime);
    draw_text(x1 + 30, y2 - 85, "--------------------------------------------------");
    draw_text(x1 + 35, y2 - 50, "[W/S] SELECT    [MOUSE] SELECT    [K/ESC] CLOSE");
}
