function step_handle_shortcuts(){
	if (keyboard_check_pressed(ord("K")))
	{
	    overlay_toggle(
	        OverlayMode.SKILLS
	    );
	} 
	if (keyboard_check_pressed(ord("L")))
	{
	    overlay_toggle(
	        OverlayMode.LOADOUT
	    );
	}
}
