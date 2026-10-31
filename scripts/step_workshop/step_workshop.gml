function step_workshop()
{
    var mouse_menu = terminal_menu_mouse_input(workshop_station_index, array_length(workshop_keys), 0, 320, 150, 560, 32);
    workshop_station_index = mouse_menu.index;
    if (mouse_menu.confirm)
    {
        workshop_focus = WorkshopFocus.CONTENT;
        workshop_content_index = 0;
        workshop_tab = WorkshopTab.UPGRADES;
    }

    var selected_key = workshop_keys[workshop_station_index];
    if (workshop_upgrade_button(selected_key, 940, 80, display_get_gui_width(), false))
    {
        audio_play_sound(snd_interact, 0, false);
        workshop_upgrade_interact(selected_key);
        return;
    }

    if (workshop_focus == WorkshopFocus.CONTENT)
    {
        // ESC RETURNS TO BENCH LIST
        if (keyboard_check_pressed(vk_escape))
        {
            audio_play_sound(snd_interact, 0, false);
            workshop_focus = WorkshopFocus.STATIONS;
            workshop_content_index = 0;
            return;
        }

        // INTERACT
        if (keyboard_check_pressed(vk_enter))
        {
            var key = workshop_keys[workshop_station_index];
            workshop_upgrade_interact(key);
        }
    }
}
