function step_raid_inventory()
{
    if (mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right) || keyboard_check_pressed(ord("R"))) save_mark_dirty();
    if (inventory_context_menu_step()) return;
    if (keyboard_check_pressed(vk_escape))
    {
        raid_inventory_clear_held();
        raid.active_loot_container = undefined;
        overlay_mode = OverlayMode.NONE;
        return;
    }

    if (!is_undefined(raid.inventory_item)
    && is_undefined(raid.inventory_container)
    && raid.inventory_equipment_slot == -1)
        raid_inventory_clear_held();

    if (mouse_check_button_pressed(mb_right))
    {
        if (!is_undefined(raid.inventory_item))
        {
            raid.medical_selected_item = undefined;
            raid_inventory_clear_held();
            return;
        }
        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);
        var _equipment_slot = inventory_character_tab == InventoryCharacterTab.EQUIPMENT
            ? raid_inventory_get_equipment_slot(_mouse_x, _mouse_y)
            : -1;
        if (_equipment_slot != -1)
        {
            var _equipped_key = equipment_get_slot_item(raid.crew_index, _equipment_slot);
            var _equipped_item = raid_inventory_get_equipped_item(_equipment_slot);
            if (_equipped_key != "")
            {
                if (is_undefined(_equipped_item) || _equipped_item.item_key != _equipped_key)
                    _equipped_item = { item_key: _equipped_key, quantity: 1, x: 0, y: 0, rotation: 0 };
                if (inventory_context_menu_open(_equipped_item, undefined, _equipment_slot, false, false, true)) return;
            }
        }

        var _context_grids = raid_inventory_get_grids();
        for (var _grid_index = 0; _grid_index < array_length(_context_grids); _grid_index++)
        {
            var _grid = _context_grids[_grid_index];
            var _cell_size = variable_struct_exists(_grid, "cell_size") ? _grid.cell_size : 60;
            var _stride = variable_struct_exists(_grid, "cell_stride") ? _grid.cell_stride : _cell_size;
            var _local_x = _mouse_x - _grid.left;
            var _local_y = _mouse_y - _grid.top;
            var _grid_x = floor(_local_x / _stride);
            var _grid_y = floor(_local_y / _stride);
            if (_grid_x < 0 || _grid_y < 0 || _grid_x >= _grid.storage.grid_width || _grid_y >= _grid.storage.grid_height
            || (_local_x mod _stride) >= _cell_size || (_local_y mod _stride) >= _cell_size) continue;
            var _context_item = inventory_find_item_at(_grid.storage, _grid_x, _grid_y);
            if (inventory_context_menu_open(_context_item, _grid.storage, -1, false, true, true)) return;
            break;
        }
        raid.medical_selected_item = undefined;
        raid_inventory_clear_held();
    }
    if (!is_undefined(raid.inventory_item)
    && keyboard_check_pressed(ord("R")))
    {
        var rotation_definition = item_get(raid.inventory_item.item_key);
        if (!is_undefined(rotation_definition))
        {
            if (rotation_definition.grid_width == rotation_definition.grid_height)
                raid.inventory_rotation = 0;
            else
                raid.inventory_rotation = raid.inventory_rotation == 90 ? 0 : 90;

            raid.inventory_item.rotation = raid.inventory_rotation;
        }
    }

    if (!mouse_check_button_pressed(mb_left)) return;
    var gui_mouse_x = device_mouse_x_to_gui(0);
    var gui_mouse_y = device_mouse_y_to_gui(0);
    if (inventory_character_tab_input(20)) return;
    if (inventory_character_tab == InventoryCharacterTab.HEALTH && !is_undefined(raid.medical_selected_item))
    {
        var _medical_target = player_health_treatment_get_manual_target(gui_mouse_x, gui_mouse_y);
        if (!is_undefined(_medical_target))
        {
            if (player_health_treatment_start(raid.medical_selected_item, _medical_target.type, _medical_target.limb))
                raid.medical_selected_item = undefined;
            return;
        }
    }
    else if (inventory_character_tab == InventoryCharacterTab.HEALTH && !is_undefined(raid.inventory_item))
    {
        var _held_medical_target = player_health_treatment_get_manual_target(gui_mouse_x, gui_mouse_y);
        if (!is_undefined(_held_medical_target)
        && player_health_treatment_start_held(raid.inventory_item, raid.inventory_container, _held_medical_target.type, _held_medical_target.limb))
        {
            raid.inventory_item = undefined;
            raid.inventory_container = undefined;
            raid.inventory_equipment_slot = -1;
            return;
        }
    }
    var equipment_slot = inventory_character_tab == InventoryCharacterTab.EQUIPMENT
        ? raid_inventory_get_equipment_slot(gui_mouse_x, gui_mouse_y)
        : -1;
    if (equipment_slot != -1)
    {
        if (!is_undefined(raid.inventory_item))
        {
            if (raid_inventory_item_fits_equipment(raid.inventory_item, equipment_slot))
            {
                raid_inventory_set_equipped_item(equipment_slot, raid.inventory_item);
                raid.inventory_item = undefined;
                raid.inventory_container = undefined;
                raid.inventory_equipment_slot = -1;
            }
        }
        else
        {
            var equipped_item = raid_inventory_get_equipped_item(equipment_slot);
            var equipped_key = equipment_get_slot_item(raid.crew_index, equipment_slot);
            if (equipped_key != ""
            && (equipment_slot != EquipmentSlot.BAG || array_length(stash.backpack.items) == 0))
            {
                if (is_undefined(equipped_item) || equipped_item.item_key != equipped_key)
                    equipped_item = { item_key: equipped_key, quantity: 1, x: 0, y: 0, rotation: 0 };

                raid.inventory_item = equipped_item;
                raid.inventory_container = undefined;
                raid.inventory_equipment_slot = equipment_slot;
                raid.inventory_rotation = equipped_item.rotation;
                raid_inventory_set_equipped_item(equipment_slot, undefined);
            }
        }
        return;
    }
    var hotbar_rect = raid_inventory_get_hotbar_rect();
    if (device_mouse_x_to_gui(0) >= hotbar_rect.left
    && device_mouse_x_to_gui(0) < hotbar_rect.left + hotbar_rect.width
    && device_mouse_y_to_gui(0) >= hotbar_rect.top
    && device_mouse_y_to_gui(0) < hotbar_rect.top + hotbar_rect.height)
    {
        var hotbar_slot = floor((device_mouse_x_to_gui(0) - hotbar_rect.left) / 72);
        if (hotbar_slot >= 0 && hotbar_slot < 6)
        {
            if (!is_undefined(raid.inventory_item))
            {
                var definition = item_get(raid.inventory_item.item_key);
                if (raid_hotbar_is_usable(definition))
                {
                    raid.hotbar[hotbar_slot] = raid.inventory_item;
                    raid_inventory_clear_held();
                }
            }
            else
            {
                raid.hotbar[hotbar_slot] = undefined;
            }
        }
        return;
    }
    var grids = raid_inventory_get_grids();
    for (var i = 0; i < array_length(grids); i++)
    {
        var grid = grids[i];
        var grid_cell_size = variable_struct_exists(grid, "cell_size") ? grid.cell_size : 60;
        var grid_stride = variable_struct_exists(grid, "cell_stride") ? grid.cell_stride : grid_cell_size;
        var grid_local_x = device_mouse_x_to_gui(0) - grid.left;
        var grid_local_y = device_mouse_y_to_gui(0) - grid.top;
        var grid_x = floor(grid_local_x / grid_stride);
        var grid_y = floor(grid_local_y / grid_stride);
        if (grid_x < 0 || grid_y < 0 || grid_x >= grid.storage.grid_width || grid_y >= grid.storage.grid_height
        || (grid_local_x mod grid_stride) >= grid_cell_size || (grid_local_y mod grid_stride) >= grid_cell_size) continue;

        if (!is_undefined(raid.inventory_item))
        {
            var item = raid.inventory_item;
            if (inventory_can_place_item(item, grid_x, grid_y, grid.storage))
            {
                var stack_target = inventory_find_item_at(grid.storage, grid_x, grid_y);
                if (!is_undefined(stack_target))
                {
                    var collected_quantity = item.quantity;
                    inventory_merge_stacks(item, stack_target);
                    collected_quantity -= item.quantity;
                    if (collected_quantity > 0 && !is_undefined(raid.active_loot_container)
                    && raid.inventory_container == raid.active_loot_container.storage
                    && grid.storage != raid.active_loot_container.storage)
                        quest_event(QuestObjectiveType.COLLECT_ITEM, item.item_key, collected_quantity);
                    if (item.quantity <= 0)
                    {
                        raid.inventory_item = undefined;
                        raid.inventory_container = undefined;
                    }
                }
                else
                {
                    if (!is_undefined(raid.active_loot_container)
                    && raid.inventory_container == raid.active_loot_container.storage
                    && grid.storage != raid.active_loot_container.storage)
                        quest_event(QuestObjectiveType.COLLECT_ITEM, item.item_key, item.quantity);
                    item.x = grid_x;
                    item.y = grid_y;
                    item.rotation = raid.inventory_rotation;
                    array_push(grid.storage.items, item);
                    raid.inventory_item = undefined;
                    raid.inventory_container = undefined;
                }
            }
            return;
        }

        for (var j = 0; j < array_length(grid.storage.items); j++)
        {
            var item = grid.storage.items[j];
            var definition = item_get(item.item_key);
            var width = item.rotation == 90 ? definition.grid_height : definition.grid_width;
            var height = item.rotation == 90 ? definition.grid_width : definition.grid_height;
            if (grid_x >= item.x && grid_x < item.x + width && grid_y >= item.y && grid_y < item.y + height)
            {
                if (keyboard_check(vk_control)
                && variable_struct_exists(grid, "key")
                && grid.key == "loot")
                {
                    var quick_transfer_destinations = [];
                    if (crew[raid.crew_index].bag != "") array_push(quick_transfer_destinations, stash.backpack);
                    array_push(quick_transfer_destinations, stash.pockets);
                    array_push(quick_transfer_destinations, stash.secure_container);
                    var collected_quantity = item.quantity;
                    if (inventory_quick_transfer(item, grid.storage, quick_transfer_destinations))
                    {
                        var item_remains_in_loot = false;
                        for (var source_index = 0; source_index < array_length(grid.storage.items); source_index++)
                        {
                            if (grid.storage.items[source_index] == item)
                            {
                                item_remains_in_loot = true;
                                break;
                            }
                        }
                        if (item_remains_in_loot) collected_quantity -= item.quantity;
                        if (collected_quantity > 0)
                            quest_event(QuestObjectiveType.COLLECT_ITEM, item.item_key, collected_quantity);
                    }
                    return;
                }

                // Selection stays in its source grid until a valid move is committed.
                raid.inventory_item = item;
                raid.inventory_container = grid.storage;
                stash_remove_item(item, grid.storage);
                if (definition.grid_width == definition.grid_height) item.rotation = 0;
                raid.inventory_rotation = item.rotation;
                return;
            }
        }
    }
}
