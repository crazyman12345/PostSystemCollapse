function step_loadout_overlay()
{
    if (overlay_mode != OverlayMode.LOADOUT)
    {
        return;
    }

    // ======================================================
    // START RAID CONFIRMATION
    // ======================================================

    if (loadout_confirm_start)
    {
        loadout_confirm_index =
            terminal_menu_input(
                loadout_confirm_index,
                2
            );

        if (keyboard_check_pressed(vk_enter))
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
            loadout_confirm_start = false;
            loadout_confirm_index = 0;

            exit;
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

        // --------------------------------------------------
        // SELECT EQUIPMENT
        // --------------------------------------------------

        if (keyboard_check_pressed(vk_enter))
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

        // --------------------------------------------------
        // IN RAID
        // EQUIPMENT <-> RAID BAG
        // --------------------------------------------------

        if (raid.active)
        {
            if (loadout_focus < LoadoutFocus.EQUIPMENT)
            {
                loadout_focus =
                    LoadoutFocus.RAID_BAG;
            }
        }

        // --------------------------------------------------
        // PRE-RAID
        // EQUIPMENT -> RAID BAG -> INVENTORY -> START RAID
        // --------------------------------------------------

        else
        {
            if (loadout_focus < LoadoutFocus.EQUIPMENT)
            {
                loadout_focus =
                    LoadoutFocus.START_RAID;
            }
        }
    }

    if (keyboard_check_pressed(ord("D")))
    {
        loadout_focus++;

        // --------------------------------------------------
        // IN RAID
        // EQUIPMENT <-> RAID BAG
        // --------------------------------------------------

        if (raid.active)
        {
            if (loadout_focus > LoadoutFocus.RAID_BAG)
            {
                loadout_focus =
                    LoadoutFocus.EQUIPMENT;
            }
        }

        // --------------------------------------------------
        // PRE-RAID
        // EQUIPMENT -> RAID BAG -> INVENTORY -> START RAID
        // --------------------------------------------------

        else
        {
            if (loadout_focus > LoadoutFocus.START_RAID)
            {
                loadout_focus =
                    LoadoutFocus.EQUIPMENT;
            }
        }
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
        }

        if (keyboard_check_pressed(ord("S")))
        {
            equipment_slot_index--;

            if (equipment_slot_index < 0)
            {
                equipment_slot_index = 4;
            }
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

            if (
                raid.active
                && keyboard_check_pressed(ord("X"))
            )
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

            // ----------------------------------------------
            // PRE-RAID:
            // ENTER RETURNS ITEM TO HIDEOUT INVENTORY
            // ----------------------------------------------

            if (
                !raid.active
                && keyboard_check_pressed(vk_enter)
            )
            {
                var selected_bag_item =
                    bag_items[
                        raid_bag_index
                    ];

                if (keyboard_check(vk_shift))
                {
                    var quantity =
                        raid_bag_get_quantity(
                            selected_bag_item
                        );

                    for (var i = 0; i < quantity; i++)
                    {
                        loadout_move_to_inventory(
                            selected_bag_item
                        );
                    }
                }
                else
                {
                    loadout_move_to_inventory(
                        selected_bag_item
                    );
                }

                // Clamp selection after removing item
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
    // HIDEOUT INVENTORY
    // PRE-RAID ONLY
    // ======================================================

    else if (
        loadout_focus == LoadoutFocus.INVENTORY
        && !raid.active
    )
    {
        var inventory_items =
            inventory_get_visible_items();

        var inventory_item_count =
            array_length(inventory_items);

        if (inventory_item_count > 0)
        {
            loadout_inventory_index =
                terminal_menu_input(
                    loadout_inventory_index,
                    inventory_item_count
                );

            // ----------------------------------------------
            // PUT ITEM INTO RAID BAG
            // ----------------------------------------------

            if (keyboard_check_pressed(vk_enter))
            {
                var selected_inventory_item =
                    inventory_items[
                        loadout_inventory_index
                    ];

                if (keyboard_check(vk_shift))
                {
                    var quantity =
                        inventory_get_quantity(
                            selected_inventory_item
                        );

                    for (var i = 0; i < quantity; i++)
                    {
                        loadout_move_to_bag(
                            selected_inventory_item
                        );
                    }
                }
                else
                {
                    loadout_move_to_bag(
                        selected_inventory_item
                    );
                }

                // Clamp selection after item was removed
                var updated_inventory_items =
                    inventory_get_visible_items();

                if (array_length(updated_inventory_items) > 0)
                {
                    loadout_inventory_index =
                        min(
                            loadout_inventory_index,
                            array_length(updated_inventory_items) - 1
                        );
                }
                else
                {
                    loadout_inventory_index = 0;
                }
            }
        }
        else
        {
            loadout_inventory_index = 0;
        }
    }

    // ======================================================
    // START RAID
    // PRE-RAID ONLY
    // ======================================================

    else if (
        loadout_focus == LoadoutFocus.START_RAID
        && !raid.active
    )
    {
        if (keyboard_check_pressed(vk_enter))
        {
            loadout_confirm_start = true;
            loadout_confirm_index = 0;

            exit;
        }
    }

    // ======================================================
    // CLOSE LOADOUT
    // ======================================================

    if (keyboard_check_pressed(vk_escape))
    {
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
