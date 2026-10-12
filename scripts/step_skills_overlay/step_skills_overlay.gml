function step_skills_overlay()
{
    var skill_count = array_length(hideout_skill_tabs);

    if (keyboard_check_pressed(vk_escape))
    {
        overlay_close();
        return;
    }

    if (skill_count <= 0) return;

    skills_index = clamp(skills_index, 0, skill_count - 1);
    skills_index = terminal_menu_input(skills_index, skill_count);

    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    var panel_w = min(1000, gui_w - 60);
    var list_x = gui_w - panel_w + 5;
    var list_y = 140;
    var row_h = min(58, floor((gui_h - 120 - list_y) / skill_count));
    var gui_mouse_x = device_mouse_x_to_gui(0);
    var gui_mouse_y = device_mouse_y_to_gui(0);

    if (gui_mouse_x >= list_x - 8 && gui_mouse_x <= list_x + 390
    && gui_mouse_y >= list_y - 4 && gui_mouse_y < list_y + skill_count * row_h)
    {
        var hover_index = floor((gui_mouse_y - list_y) / row_h);
        if (hover_index != skills_index)
        {
            skills_index = hover_index;
            scroll_sound();
        }
    }
}
