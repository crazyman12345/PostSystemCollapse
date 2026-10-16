function overlay_close()
{
    switch (overlay_mode)
    {
        case OverlayMode.SKILLS:
        {
            //skill_index = 0;
            break;
        }


        case OverlayMode.LOADOUT:
        {
            if (raid.state != RaidState.INACTIVE && raid.state != RaidState.RESULT)
            {
                raid_inventory_clear_held();
                raid.active_loot_container = undefined;
            }

            loadout_focus =
                LoadoutFocus.EQUIPMENT;

            equipment_slot_index = 0;
            equipment_item_index = 0;
            equipment_item_select_open = false;

            raid_bag_index = 0;
            loadout_inventory_index = 0;

            break;
        }

    }

    overlay_mode = OverlayMode.NONE;
}
