function step_hideout_raid()
{

    // ==========================================
    // AREA SELECT
    // ==========================================

        var count = array_length(level_db);

        if (keyboard_check_pressed(ord("A")) && combat_area_index mod 2 == 1)
		{ 
			combat_area_index--;
			scroll_sound();
		}
        if (keyboard_check_pressed(ord("D")) && combat_area_index mod 2 == 0 && combat_area_index + 1 < count)
        {   
			combat_area_index++;
			scroll_sound();
		}
        if (keyboard_check_pressed(ord("W")) && combat_area_index - 2 >= 0)
		{
            combat_area_index -= 2;
			scroll_sound();
		}
        if (keyboard_check_pressed(ord("S")) && combat_area_index + 2 < count)
		{
            combat_area_index += 2;
			scroll_sound();
		}
        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);
        var hover_column = floor((_mouse_x - 320) / 805);
        var hover_row = floor((_mouse_y - 80) / ((950 / 6) + 10));
        var hover_index = hover_row * 2 + hover_column;
        var mouse_hover = _mouse_x >= 320 && _mouse_x < 1920 && _mouse_y >= 80 && _mouse_y < 1080
            && ((_mouse_x - 320) mod 805) < 795 && ((_mouse_y - 80) mod ((950 / 6) + 10)) < (950 / 6)
            && hover_index >= 0 && hover_index < count;

        if (mouse_hover && combat_area_index != hover_index)
        {
            combat_area_index = hover_index;
            scroll_sound();
        }

        if (keyboard_check_pressed(vk_enter) || (mouse_hover && mouse_check_button_pressed(mb_left)))
        {
            // STORE SELECTED RAID LOCATION
            raid.selected_area_index = combat_area_index;
            raid.selected_area = level_db[combat_area_index];

            // OPEN RAID EQUIPMENT SCREEN
            overlay_mode = OverlayMode.LOADOUT;
            loadout_focus = LoadoutFocus.START_RAID;

            equipment_slot_index = 0;
            equipment_item_index = 0;
            equipment_selecting_item = false;
			audio_play_sound(snd_interact, 0, false);
            return;
			
        }

        if (keyboard_check_pressed(vk_escape))
        {
            hideout_focus = HideoutFocus.SIDEBAR;
			audio_play_sound(snd_interact, 0, false);
            return;
        }

        return;

}
