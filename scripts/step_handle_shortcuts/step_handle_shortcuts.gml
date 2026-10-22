function step_handle_shortcuts(){
	if (keyboard_check_pressed(ord("K")))
	{
	    overlay_toggle(
	        OverlayMode.SKILLS
	    );
	} 
	if (keyboard_check_pressed(ord("J")))
	{
		overlay_toggle(OverlayMode.QUESTS);
	}
	if (keyboard_check_pressed(ord("L")))
	{
	    overlay_toggle(
	        OverlayMode.LOADOUT
	    );
	}
}
