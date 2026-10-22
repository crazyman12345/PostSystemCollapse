function step_workshop()
{
    tutorial_callout_hide();
    var selected_key = workshop_keys[workshop_station_index];
    if (workshop_upgrade_button(selected_key, 940, 80, display_get_gui_width(), false))
    {
        audio_play_sound(snd_interact, 0, false);
        workshop_upgrade_interact(selected_key);
        return;
    }

    // LEFT SIDE - BENCH SELECTION
    if (workshop_focus == WorkshopFocus.STATIONS)
    {
        if (keyboard_check_pressed(ord("W")))
        {
            workshop_station_index--;
            if (workshop_station_index < 0) workshop_station_index = array_length(workshop_keys) - 1;
            scroll_sound();
        }

        if (keyboard_check_pressed(ord("S")))
        {
            workshop_station_index++;
            if (workshop_station_index >= array_length(workshop_keys)) workshop_station_index = 0;
            scroll_sound();
        }

        var mouse_menu = terminal_menu_mouse_input(workshop_station_index, array_length(workshop_keys), 0, 320, 150, 560, 32);
        workshop_station_index = mouse_menu.index;

        if (keyboard_check_pressed(vk_enter) || mouse_menu.confirm)
        {
            workshop_focus = WorkshopFocus.CONTENT;
            workshop_content_index = 0;
            workshop_tab = WorkshopTab.UPGRADES;

            return;
        }

        if (keyboard_check_pressed(vk_escape))
        {
             audio_play_sound(snd_interact, 0, false);
             hideout_focus = HideoutFocus.SIDEBAR;
			 return;
        }

        return;
    }

    // RIGHT SIDE
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
