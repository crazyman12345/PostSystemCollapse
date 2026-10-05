function step_hideout_stash(){

    var stash_right_margin = 25;
    var grid_top = 150;
    var cell_size = 60;
    var grid_left = 1920 - stash_right_margin - (stash.grid_width * cell_size);
    var middle_left = 815;
    var container_cell_size = 60;
    var backpack_grid_left = middle_left + 165;
    var backpack_grid_top = grid_top;
    var secure_grid_left = middle_left + 165;
    var secure_grid_top = backpack_grid_top + 320;
    var backpack_slot_w = 150;
    var backpack_slot_h = 220;
    var member = crew[0];

    var grids = [{ key: "stash", storage: stash, left: grid_left, top: grid_top, cell_size: cell_size }];

    if (member.bag != "")
    {
        var backpack_definition = item_get(member.bag);

        if (!is_undefined(backpack_definition))
        {
            stash.backpack.grid_width = backpack_definition.grid_width;
            stash.backpack.grid_height = backpack_definition.grid_height;
            array_push(grids, { key: "backpack", storage: stash.backpack, left: backpack_grid_left, top: backpack_grid_top, cell_size: container_cell_size });
            secure_grid_top = backpack_grid_top + (stash.backpack.grid_height * container_cell_size) + 150;
        }
    }

    array_push(grids, { key: "secure", storage: stash.secure_container, left: secure_grid_left, top: secure_grid_top + 48, cell_size: cell_size });

    var gui_mouse_x = device_mouse_x_to_gui(0);
    var gui_mouse_y = device_mouse_y_to_gui(0);
    var equipment_center = 575;
    var equipment_slot = -1;

    if (gui_mouse_x >= equipment_center - 45 && gui_mouse_x < equipment_center + 45
    && gui_mouse_y >= grid_top + 5 && gui_mouse_y < grid_top + 95)
    {
        equipment_slot = EquipmentSlot.HEAD;
    }
    else if (gui_mouse_x >= equipment_center - 75 && gui_mouse_x < equipment_center + 75
    && gui_mouse_y >= grid_top + 100 && gui_mouse_y < grid_top + 320)
    {
        equipment_slot = EquipmentSlot.CHEST;
    }
    else if (gui_mouse_x >= equipment_center - 180 && gui_mouse_x < equipment_center + 180
    && gui_mouse_y >= grid_top + 350 && gui_mouse_y < grid_top + 450)
    {
        equipment_slot = EquipmentSlot.WEAPON;
    }
    else if (gui_mouse_x >= equipment_center - 180 && gui_mouse_x < equipment_center + 180
    && gui_mouse_y >= grid_top + 470 && gui_mouse_y < grid_top + 570)
    {
        equipment_slot = EquipmentSlot.WEAPON_2;
    }

    var backpack_slot_hovered = gui_mouse_x >= middle_left
    && gui_mouse_x < middle_left + backpack_slot_w
    && gui_mouse_y >= grid_top
    && gui_mouse_y < grid_top + backpack_slot_h;
    var hovered_grid = undefined;
    var mouse_grid_x = -1;
    var mouse_grid_y = -1;

    for (var grid_index = 0; grid_index < array_length(grids); grid_index++)
    {
        var grid = grids[grid_index];
        var grid_x = floor((gui_mouse_x - grid.left) / grid.cell_size);
        var grid_y = floor((gui_mouse_y - grid.top) / grid.cell_size);

        if (grid_x >= 0 && grid_x < grid.storage.grid_width && grid_y >= 0 && grid_y < grid.storage.grid_height)
        {
            hovered_grid = grid;
            mouse_grid_x = grid_x;
            mouse_grid_y = grid_y;
            break;
        }
    }

    if (!is_undefined(stash.held_item))
    {
        stash.hover_x = is_undefined(hovered_grid) ? -1 : mouse_grid_x;
        stash.hover_y = is_undefined(hovered_grid) ? -1 : mouse_grid_y;
        stash.hover_container = is_undefined(hovered_grid) ? "" : hovered_grid.key;

        if (keyboard_check_pressed(ord("R")))
        {
            stash.held_item.rotation = stash.held_item.rotation == 90 ? 0 : 90;
        }

        var held_definition = item_get(stash.held_item.item_key);
        var held_source = variable_struct_exists(stash, "held_source") ? stash.held_source : "";
        var equipment_slot_item = "";
        var equipment_slot_valid = false;

        switch (equipment_slot)
        {
            case EquipmentSlot.WEAPON:
            case EquipmentSlot.WEAPON_2:
                equipment_slot_item = equipment_slot == EquipmentSlot.WEAPON ? member.weapon : member.weapon_2;
                equipment_slot_valid = !is_undefined(held_definition) && held_definition.category == ItemCategory.WEAPON;
                break;

            case EquipmentSlot.HEAD:
                equipment_slot_item = member.armor_head;
                equipment_slot_valid = !is_undefined(held_definition) && held_definition.category == ItemCategory.HEAD_ARMOR;
                break;

            case EquipmentSlot.CHEST:
                equipment_slot_item = member.armor_chest;
                equipment_slot_valid = !is_undefined(held_definition) && held_definition.category == ItemCategory.BODY_ARMOR;
                break;
        }

        if (equipment_slot != -1
        && (held_source == "stash" || held_source == "equipment")
        && equipment_slot_item == ""
        && equipment_slot_valid
        && mouse_check_button_pressed(mb_left))
        {
            switch (equipment_slot)
            {
                case EquipmentSlot.WEAPON:
                    member.weapon = stash.held_item.item_key;
                    stash.equipped_weapon_item = stash.held_item;
                    break;

                case EquipmentSlot.WEAPON_2:
                    member.weapon_2 = stash.held_item.item_key;
                    stash.equipped_weapon_2_item = stash.held_item;
                    break;

                case EquipmentSlot.HEAD:
                    member.armor_head = stash.held_item.item_key;
                    stash.equipped_armor_head_item = stash.held_item;
                    break;

                case EquipmentSlot.CHEST:
                    member.armor_chest = stash.held_item.item_key;
                    stash.equipped_armor_chest_item = stash.held_item;
                    break;
            }

            crew[0] = member;
            stash.held_item = undefined;
            stash.held_source = "";
            stash.hover_x = -1;
            stash.hover_y = -1;
            stash.hover_container = "";
        }
        else if (backpack_slot_hovered
        && (member.bag == "" || is_undefined(hovered_grid))
        && mouse_check_button_pressed(mb_left))
        {
            if (held_source == "stash"
            && member.bag == ""
            && !is_undefined(held_definition)
            && held_definition.category == ItemCategory.BAG)
            {
                member.bag = stash.held_item.item_key;
                crew[0] = member;
                stash.equipped_bag_item = stash.held_item;
                stash.held_item = undefined;
                stash.held_source = "";
                stash.hover_x = -1;
                stash.hover_y = -1;
                stash.hover_container = "";
            }
        }
        else if (!is_undefined(hovered_grid) && mouse_check_button_pressed(mb_left)
        && stash_item_fits(stash.held_item.item_key, mouse_grid_x, mouse_grid_y, stash.held_item.rotation, hovered_grid.storage))
        {
            stash.held_item.x = mouse_grid_x;
            stash.held_item.y = mouse_grid_y;
            array_push(hovered_grid.storage.items, stash.held_item);
            stash.held_item = undefined;
            stash.held_source = "";
            stash.hover_x = -1;
            stash.hover_y = -1;
            stash.hover_container = "";

            if (hovered_grid.key == "stash") stash_index = array_length(stash.items) - 1;
        }
    }
    else if (equipment_slot != -1 && mouse_check_button_pressed(mb_left))
    {
        var equipped_item = undefined;
        var equipped_item_key = "";

        switch (equipment_slot)
        {
            case EquipmentSlot.WEAPON:
                equipped_item = variable_struct_exists(stash, "equipped_weapon_item") ? stash.equipped_weapon_item : undefined;
                equipped_item_key = member.weapon;
                break;

            case EquipmentSlot.WEAPON_2:
                equipped_item = variable_struct_exists(stash, "equipped_weapon_2_item") ? stash.equipped_weapon_2_item : undefined;
                equipped_item_key = member.weapon_2;
                break;

            case EquipmentSlot.HEAD:
                equipped_item = variable_struct_exists(stash, "equipped_armor_head_item") ? stash.equipped_armor_head_item : undefined;
                equipped_item_key = member.armor_head;
                break;

            case EquipmentSlot.CHEST:
                equipped_item = variable_struct_exists(stash, "equipped_armor_chest_item") ? stash.equipped_armor_chest_item : undefined;
                equipped_item_key = member.armor_chest;
                break;
        }

        if (equipped_item_key != "")
        {
            if (is_undefined(equipped_item) || equipped_item.item_key != equipped_item_key)
            {
                equipped_item = { item_key: equipped_item_key, quantity: 1, x: 0, y: 0, rotation: 0 };
            }

            var stash_has_space = false;

            for (var stash_y = 0; stash_y < stash.grid_height && !stash_has_space; stash_y++)
            {
                for (var stash_x = 0; stash_x < stash.grid_width; stash_x++)
                {
                    if (stash_item_fits(equipped_item.item_key, stash_x, stash_y, equipped_item.rotation, stash))
                    {
                        stash_has_space = true;
                        break;
                    }
                }
            }

            if (stash_has_space)
            {
                stash.held_item = equipped_item;
                stash.held_source = "equipment";

                switch (equipment_slot)
                {
                    case EquipmentSlot.WEAPON:
                        member.weapon = "";
                        stash.equipped_weapon_item = undefined;
                        break;

                    case EquipmentSlot.WEAPON_2:
                        member.weapon_2 = "";
                        stash.equipped_weapon_2_item = undefined;
                        break;

                    case EquipmentSlot.HEAD:
                        member.armor_head = "";
                        stash.equipped_armor_head_item = undefined;
                        break;

                    case EquipmentSlot.CHEST:
                        member.armor_chest = "";
                        stash.equipped_armor_chest_item = undefined;
                        break;
                }

                crew[0] = member;
                stash.hover_x = -1;
                stash.hover_y = -1;
                stash.hover_container = "";
            }
        }
    }
    else if (backpack_slot_hovered
    && is_undefined(hovered_grid)
    && member.bag != ""
    && mouse_check_button_pressed(mb_left))
    {
        if (array_length(stash.backpack.items) == 0)
        {
            var equipped_bag_item = variable_struct_exists(stash, "equipped_bag_item") ? stash.equipped_bag_item : undefined;

            if (is_undefined(equipped_bag_item)
            || equipped_bag_item.item_key != member.bag)
            {
                equipped_bag_item = { item_key: member.bag, quantity: 1, x: 0, y: 0, rotation: 0 };
            }

            var stash_has_space = false;

            for (var stash_y = 0; stash_y < stash.grid_height && !stash_has_space; stash_y++)
            {
                for (var stash_x = 0; stash_x < stash.grid_width; stash_x++)
                {
                    if (stash_item_fits(equipped_bag_item.item_key, stash_x, stash_y, equipped_bag_item.rotation, stash))
                    {
                        stash_has_space = true;
                        break;
                    }
                }
            }

            if (stash_has_space)
            {
                stash.held_item = equipped_bag_item;
                stash.held_source = "equipment";
                stash.equipped_bag_item = undefined;
                member.bag = "";
                crew[0] = member;
                stash.hover_x = -1;
                stash.hover_y = -1;
                stash.hover_container = "";
            }
        }
    }
    else if (!is_undefined(hovered_grid) && mouse_check_button_pressed(mb_left))
    {
        for (var i = array_length(hovered_grid.storage.items) - 1; i >= 0; i--)
        {
            var item = hovered_grid.storage.items[i];
            var definition = item_get(item.item_key);
            var item_width = definition.grid_width;
            var item_height = definition.grid_height;

            if (item.rotation == 90)
            {
                var size = item_width;
                item_width = item_height;
                item_height = size;
            }

            if (mouse_grid_x >= item.x && mouse_grid_x < item.x + item_width
            && mouse_grid_y >= item.y && mouse_grid_y < item.y + item_height)
            {
                stash.held_item = item;
                stash_remove_item(item, hovered_grid.storage);
                stash.held_source = hovered_grid.key;
                stash.hover_x = mouse_grid_x;
                stash.hover_y = mouse_grid_y;
                stash.hover_container = hovered_grid.key;
                stash_index = clamp(stash_index, 0, max(0, array_length(stash.items) - 1));
                break;
            }
        }
    }

    var item_count = array_length(stash.items);
    if (item_count > 0) {
        stash_index = clamp(stash_index, 0, item_count - 1);
        stash_index = terminal_menu_input(stash_index, item_count);
    } else {
        stash_index = 0;
    }
    if (keyboard_check_pressed(vk_escape)) {
        audio_play_sound(snd_interact, 0, false);
        hideout_focus = HideoutFocus.SIDEBAR;
    }
}
