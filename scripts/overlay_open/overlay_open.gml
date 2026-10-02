function overlay_open(_mode)
{
    if (!overlay_can_open(_mode))
        return;

    overlay_mode = _mode;

    switch (_mode)
    {
        case OverlayMode.SKILLS:
        {
            //skill_index = 0;
            break;
        }

        case OverlayMode.CREW_SKILLS:
        {
            //crew_skill_index = 0;
            //crew_skill_crew_index = 0;
            break;
        }

        case OverlayMode.LOADOUT:
        {
            loadout_focus =
                LoadoutFocus.EQUIPMENT;

 	        equipment_selecting_item = false;

	        equipment_slot_index = 0;
	        equipment_item_index = 0;

	        raid_bag_index = 0;
	        loadout_inventory_index = 0;

            break;
        }

        case OverlayMode.INVENTORY:
        {
            inventory_index = 0;
            inventory_scroll = 0;

            break;
        }
    }
}