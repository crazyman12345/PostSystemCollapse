function draw_overlay(_overlay){
	switch(_overlay){
		case OverlayMode.NONE:
			break;
		case OverlayMode.LOADOUT:
			draw_loadout_overlay();
			break;
		case OverlayMode.SKILLS:
			draw_skills_overlay();
			break;
		case OverlayMode.QUESTS:
			draw_quests_overlay();
			break;		
	}
}
