function step_raid_inventory()
{
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

    if (mouse_check_button_pressed(mb_right)) raid_inventory_clear_held();
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
    var equipment_slot = raid_inventory_get_equipment_slot(gui_mouse_x, gui_mouse_y);
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
        var grid_x = floor((device_mouse_x_to_gui(0) - grid.left) / 60);
        var grid_y = floor((device_mouse_y_to_gui(0) - grid.top) / 60);
        if (grid_x < 0 || grid_y < 0 || grid_x >= grid.storage.grid_width || grid_y >= grid.storage.grid_height) continue;

        if (!is_undefined(raid.inventory_item))
        {
            var item = raid.inventory_item;
            if (inventory_can_place_item(item, grid_x, grid_y, grid.storage))
            {
                var stack_target = inventory_find_item_at(grid.storage, grid_x, grid_y);
                if (!is_undefined(stack_target))
                {
                    inventory_merge_stacks(item, stack_target);
                    if (item.quantity <= 0)
                    {
                        raid.inventory_item = undefined;
                        raid.inventory_container = undefined;
                    }
                }
                else
                {
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
