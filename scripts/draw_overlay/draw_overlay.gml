function draw_overlay(_overlay){
	switch(_overlay){
		case OverlayMode.NONE:
			break;
		case OverlayMode.INVENTORY:
			draw_inventory_overlay();
			break;
		case OverlayMode.LOADOUT:
			draw_crew_equipment_overlay();
			break;
		case OverlayMode.CREW_SKILLS:
			draw_crew_skills();
			break;
		case OverlayMode.SKILLS:
			draw_skills_overlay();
			break;		
	}
}