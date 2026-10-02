function overlay_close()
{
    switch (overlay_mode)
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

            equipment_slot_index = 0;
            equipment_item_index = 0;
            equipment_item_select_open = false;

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

    overlay_mode = OverlayMode.NONE;
}