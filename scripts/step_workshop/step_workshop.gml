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
            var key = workshop_keys[workshop_station_index];
            var level = variable_struct_get(workshop_progress, key);

            workshop_focus = WorkshopFocus.CONTENT;
            workshop_content_index = 0;

            if (level > 0) workshop_tab = WorkshopTab.FUNCTION;
            else workshop_tab = WorkshopTab.UPGRADES;

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

        // SWITCH TABS
        if (keyboard_check_pressed(ord("A")))
        {
            workshop_tab = WorkshopTab.UPGRADES;
            workshop_content_index = 0;
        }

        if (keyboard_check_pressed(ord("D")))
        {
            workshop_tab = WorkshopTab.FUNCTION;
            workshop_content_index = 0;
        }

        // W/S ONLY SCROLLS CONTENT ON FUNCTION TAB
        if (workshop_tab == WorkshopTab.FUNCTION)
        {
            var count = workshop_get_function_count(workshop_keys[workshop_station_index]);
			log_add(string(count));
            if (keyboard_check_pressed(ord("W")) && count > 0)
            {
                workshop_content_index--;
                if (workshop_content_index < 0) workshop_content_index = count - 1;
            }

            if (keyboard_check_pressed(ord("S")) && count > 0)
            {
                workshop_content_index++;
                if (workshop_content_index >= count) workshop_content_index = 0;
            }
        }

        // INTERACT
        if (keyboard_check_pressed(vk_enter))
        {
            var key = workshop_keys[workshop_station_index];
            if (workshop_tab == WorkshopTab.UPGRADES) workshop_upgrade_interact(key);
            else workshop_function_interact(key);
        }
    }
}