function step_loadout_overlay()
{
    if (overlay_mode != OverlayMode.LOADOUT)
    {
        return;
    }

    if (raid.state != RaidState.INACTIVE && raid.state != RaidState.RESULT)
    {
        step_raid_inventory();
        return;
    }

    // ======================================================
    // START RAID CONFIRMATION
    // ======================================================

    if (loadout_confirm_start)
    {
        var confirm_left = (display_get_gui_width() - 600) * 0.5;
        var confirm_top = (display_get_gui_height() - 300) * 0.5;

        loadout_confirm_index =
            terminal_menu_input(
                loadout_confirm_index,
                2
            );

        var mouse_menu = terminal_menu_mouse_input(loadout_confirm_index, 2, 0, confirm_left + 100, confirm_top + 140, 400, 40);
        loadout_confirm_index = mouse_menu.index;

        if (keyboard_check_pressed(vk_enter) || mouse_menu.confirm)
        {
            switch (loadout_confirm_index)
            {
                // YES
                case 0:
                {
                    loadout_confirm_start = false;
                    loadout_confirm_index = 0;

                    overlay_mode = OverlayMode.NONE;

                    raid_start(
                        raid.selected_area
                    );

                    exit;
                }

                // NO
                case 1:
                {
                    loadout_confirm_start = false;
                    loadout_confirm_index = 0;

                    exit;
                }
            }
        }

        if (keyboard_check_pressed(vk_escape))
        {
            audio_play_sound(snd_interact, 0, false);
            loadout_confirm_start = false;
            loadout_confirm_index = 0;

            exit;
        }

        exit;
    }

    // ======================================================
    // PRE-RAID LOADOUT
    // ======================================================

    if (raid.state == RaidState.INACTIVE || raid.state == RaidState.RESULT)
    {
        loadout_focus = LoadoutFocus.START_RAID;

        var mouse_gui_x = device_mouse_x_to_gui(0);
        var mouse_gui_y = device_mouse_y_to_gui(0);

        var mouse_start = mouse_check_button_pressed(mb_left)
            && mouse_gui_x >= 1420 && mouse_gui_x <= 1890
            && mouse_gui_y >= 920 && mouse_gui_y <= 1015;

        if (keyboard_check_pressed(vk_enter) || mouse_start)
        {
            if (mouse_start) audio_play_sound(snd_interact, 0, false);
            loadout_confirm_start = true;
            loadout_confirm_index = 0;
            exit;
        }

        if (keyboard_check_pressed(vk_escape))
        {
            audio_play_sound(snd_interact, 0, false);
            overlay_mode = OverlayMode.NONE;
            equipment_selecting_item = false;
            equipment_slot_index = 0;
            equipment_item_index = 0;
            raid_bag_index = 0;
            loadout_inventory_index = 0;
            loadout_focus = LoadoutFocus.EQUIPMENT;
            loadout_confirm_start = false;
            loadout_confirm_index = 0;
        }

        exit;
    }

}
