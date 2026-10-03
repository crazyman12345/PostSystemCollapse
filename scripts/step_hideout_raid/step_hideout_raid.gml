function step_hideout_raid()
{

    // ==========================================
    // AREA SELECT
    // ==========================================

        var count = array_length(combat_area_db);

        if (keyboard_check_pressed(ord("A")) && combat_area_index mod 2 == 1) combat_area_index--;

        if (keyboard_check_pressed(ord("D")) && combat_area_index mod 2 == 0 && combat_area_index + 1 < count)
            combat_area_index++;

        if (keyboard_check_pressed(ord("W")) && combat_area_index - 2 >= 0)
            combat_area_index -= 2;

        if (keyboard_check_pressed(ord("S")) && combat_area_index + 2 < count)
            combat_area_index += 2;

        if (keyboard_check_pressed(vk_enter))
        {
            // STORE SELECTED RAID LOCATION
            raid.selected_area_index = combat_area_index;
            raid.selected_area = combat_area_db[combat_area_index];

            // OPEN RAID EQUIPMENT SCREEN
            overlay_mode = OverlayMode.LOADOUT;

            equipment_slot_index = 0;
            equipment_item_index = 0;
            equipment_selecting_item = false;

            return;
        }

        if (keyboard_check_pressed(vk_escape))
        {
            hideout_focus = HideoutFocus.SIDEBAR;
            return;
        }

        return;

}