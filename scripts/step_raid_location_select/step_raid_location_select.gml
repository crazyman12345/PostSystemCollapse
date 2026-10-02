function step_raid_location_select(){
	// ========================================================
		// GET RAID LOCATIONS
		// ========================================================
		var location_keys =
		    raid_location_get_all_keys();
		var location_count =
		    array_length(location_keys);
		// ========================================================
		// NO LOCATIONS
		// ========================================================
		if (location_count <= 0)
		{
		    if (keyboard_check_pressed(vk_escape))
		    {
		        state =
		            RaidPrep.PREP;

		        menu_index = 0;
		    }

		    return;
		}
		// ========================================================
		// LOCATION SELECTION
		// ========================================================
		menu_index =
		    terminal_menu_input(
		        menu_index,
		        location_count
		    );
		// ========================================================
		// START RAID
		// ========================================================
		if (keyboard_check_pressed(vk_enter))
		{
		    var selected_location_key =
		        location_keys[
		            menu_index
		        ];
		    var selected_location =
		        raid_location_get(
		            selected_location_key
		        );
		    // ----------------------------------------------------
		    // CHECK DANGER LEVEL
		    // ----------------------------------------------------
		    var location_unlocked =
		        selected_location.danger_level
		        <= global.progress.danger_level;
		    if (location_unlocked)
		    {
		        raid_start(
		            selected_location_key
		        );
		        exit;
		    }
		    else
		    {
		        log_add(
		            "Location locked. Requires Danger Level "
		            + string(
		                selected_location.danger_level
		            )
		            + "."
		        );
		    }
		}
		// ========================================================
		// BACK
		// ========================================================
		if (keyboard_check_pressed(vk_escape))
		{
		    raid_prep_mode =
		        RaidPrep.PREP;

		    menu_index = 0;
		}
}