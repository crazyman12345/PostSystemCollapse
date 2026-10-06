function step_handle_shortcuts(){
	if (keyboard_check_pressed(ord("O")))
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

	if (keyboard_check_pressed(ord("I")))
	{
	    overlay_toggle(
	        OverlayMode.INVENTORY
	    );
	}
}