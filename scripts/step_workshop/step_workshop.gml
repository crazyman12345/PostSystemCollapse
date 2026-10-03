function step_workshop()
{
    // LEFT SIDE - BENCH SELECTION
    if (workshop_focus == WorkshopFocus.STATIONS)
    {
        if (keyboard_check_pressed(ord("W")))
        {
            workshop_station_index--;
            if (workshop_station_index < 0) workshop_station_index = array_length(workshop_keys) - 1;
        }

        if (keyboard_check_pressed(ord("S")))
        {
            workshop_station_index++;
            if (workshop_station_index >= array_length(workshop_keys)) workshop_station_index = 0;
        }

        if (keyboard_check_pressed(vk_enter))
        {
            workshop_focus = WorkshopFocus.CONTENT;
            workshop_content_index = 0;
            workshop_tab = WorkshopTab.UPGRADES;

            return;
        }

        if (keyboard_check_pressed(vk_escape))
        {
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
