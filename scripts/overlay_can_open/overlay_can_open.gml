function overlay_can_open(_mode)
{
	if state = GameState.MAIN_MENU{
		return false;
	}
	
    switch (_mode)
    {
        case OverlayMode.INVENTORY:
        {
            // Hideout inventory cannot be opened during raid
            return raid.state == RaidState.INACTIVE || raid.state == RaidState.RESULT;
        }

        case OverlayMode.LOADOUT:
        {
            // Loadout works both pre-raid and in raid
            return true;
        }

        case OverlayMode.SKILLS:
        {
            return true;
        }

        case OverlayMode.CREW_SKILLS:
        {
            return true;
        }
    }

    return false;
}
