function overlay_can_open(_mode)
{
	if state = GameState.MAIN_MENU{
		return false;
	}
	if (state == GameState.HIDEOUT && onboarding_is_active()) return false;
	
    switch (_mode)
    {

        case OverlayMode.LOADOUT:
        {
            // Loadout works both pre-raid and in raid
            return true;
        }

        case OverlayMode.SKILLS:
        {
            return true;
        }

		case OverlayMode.QUESTS:
		{
			return true;
		}

    }

    return false;
}
