function step_loadout_overlay()
{
    if (overlay_mode != OverlayMode.LOADOUT)
    {
        return;
    }

    if (raid.active)
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

    if (!raid.active)
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

    // ======================================================
    // EQUIPMENT ITEM SELECTION POPUP
    // ======================================================

    if (equipment_selecting_item)
    {
        var current_slot =
            equipment_slot_index;

        var valid_items =
            equipment_get_valid_items(
                current_slot
            );

        // +1 because index 0 = NONE
        var option_count =
            array_length(valid_items) + 1;

        equipment_item_index =
            terminal_menu_input(
                equipment_item_index,
                option_count
            );

        var mouse_menu = terminal_menu_mouse_input(equipment_item_index, option_count, 0, 1260, 260, 520, 50);
        equipment_item_index = mouse_menu.index;

        // --------------------------------------------------
        // SELECT EQUIPMENT
        // --------------------------------------------------

        if (keyboard_check_pressed(vk_enter) || mouse_menu.confirm)
        {
            // NONE / UNEQUIP
            if (equipment_item_index == 0)
            {
                var old_item_key =
                    equipment_get_slot_item(
                        raid.crew_index,
                        current_slot
                    );

                if (old_item_key != "")
                {
                    if (raid.active)
                    {
                        equipment_equip_item(
                            raid.crew_index,
                            current_slot,
                            ""
                        );
                    }
                }
            }

            // EQUIP ITEM
            else
            {
                var selected_item_key =
                    valid_items[
                        equipment_item_index - 1
                    ];

                equipment_equip_item(
                    raid.crew_index,
                    current_slot,
                    selected_item_key
                );
            }

            equipment_selecting_item = false;
            equipment_item_index = 0;
        }

        // --------------------------------------------------
        // CLOSE POPUP
        // --------------------------------------------------

        if (keyboard_check_pressed(vk_escape))
        {
            audio_play_sound(snd_interact, 0, false);
            equipment_selecting_item = false;
            equipment_item_index = 0;
        }

        exit;
    }

    // ======================================================
    // SWITCH PANELS
    // ======================================================

    if (keyboard_check_pressed(ord("A")))
    {
        loadout_focus--;

        if (loadout_focus < LoadoutFocus.EQUIPMENT)
        {
            loadout_focus =
                LoadoutFocus.RAID_BAG;
        }
        scroll_sound();
    }

    if (keyboard_check_pressed(ord("D")))
    {
        loadout_focus++;

        if (loadout_focus > LoadoutFocus.RAID_BAG)
        {
            loadout_focus =
                LoadoutFocus.EQUIPMENT;
        }
        scroll_sound();
    }

    // ======================================================
    // EQUIPMENT PANEL
    // ======================================================

    if (loadout_focus == LoadoutFocus.EQUIPMENT)
    {
        // Reverse W/S navigation for equipment slots

        if (keyboard_check_pressed(ord("W")))
        {
            equipment_slot_index++;

            if (equipment_slot_index >= 5)
            {
                equipment_slot_index = 0;
            }
            scroll_sound();
        }

        if (keyboard_check_pressed(ord("S")))
        {
            equipment_slot_index--;

            if (equipment_slot_index < 0)
            {
                equipment_slot_index = 4;
            }
            scroll_sound();
        }

        if (keyboard_check_pressed(vk_enter))
        {
            equipment_selecting_item = true;
            equipment_item_index = 0;
        }
    }

    // ======================================================
    // RAID BAG PANEL
    // ======================================================

    else if (loadout_focus == LoadoutFocus.RAID_BAG)
    {
        var bag_items =
            raid_bag_get_visible_items();

        var bag_item_count =
            array_length(bag_items);

        if (bag_item_count > 0)
        {
            raid_bag_index =
                terminal_menu_input(
                    raid_bag_index,
                    bag_item_count
                );

            // ----------------------------------------------
            // IN RAID:
            // X DROPS ONE ITEM
            // SHIFT + X DROPS ENTIRE STACK
            // ----------------------------------------------

            if (keyboard_check_pressed(ord("X")))
            {
                var selected_bag_item =
                    bag_items[
                        raid_bag_index
                    ];

                var quantity =
                    raid_bag_get_quantity(
                        selected_bag_item
                    );

                // DROP FULL STACK
                if (keyboard_check(vk_shift))
                {
                    raid_bag_remove(
                        selected_bag_item,
                        quantity
                    );

                    log_add(
                        "Dropped "
                        + string(quantity)
                        + "x "
                        + selected_bag_item
                        + "."
                    );
                }

                // DROP ONE
                else
                {
                    raid_bag_remove(
                        selected_bag_item,
                        1
                    );

                    log_add(
                        "Dropped 1x "
                        + selected_bag_item
                        + "."
                    );
                }

                // Clamp selection after item removal
                var updated_bag_items =
                    raid_bag_get_visible_items();

                if (array_length(updated_bag_items) > 0)
                {
                    raid_bag_index =
                        min(
                            raid_bag_index,
                            array_length(updated_bag_items) - 1
                        );
                }
                else
                {
                    raid_bag_index = 0;
                }
            }

        }
        else
        {
            raid_bag_index = 0;
        }
    }

    // ======================================================
    // CLOSE LOADOUT
    // ======================================================

    if (keyboard_check_pressed(vk_escape))
    {
        audio_play_sound(snd_interact, 0, false);
        overlay_mode = OverlayMode.NONE;

        equipment_selecting_item = false;
        equipment_slot_index = 0;
        equipment_item_index = 0;

        raid_bag_index = 0;
        loadout_inventory_index = 0;

        loadout_focus =
            LoadoutFocus.EQUIPMENT;

        loadout_confirm_start = false;
        loadout_confirm_index = 0;
    }

    // Prevent underlying menus / raid controls from firing
    exit;
}
