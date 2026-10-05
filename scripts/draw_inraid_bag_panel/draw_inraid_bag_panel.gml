function draw_inraid_bag_panel()
{
    draw_set_font(fnt_terminal_small);
    terminal_panel(20, 80, 1880, 970, "RAID INVENTORY");
    draw_stash_equipment_and_carried_storage(crew[raid.crew_index], true, 20, 1880);
    draw_raid_hotbar(true);

    var loot_grid = raid_inventory_get_loot_grid();
    if (!is_undefined(loot_grid))
    {
        var loot = raid.active_loot_container;
        draw_text(loot_grid.left, loot_grid.top - 25, raid_reward_name(loot.reward_type));
        draw_line(loot_grid.left, loot_grid.top - 7, loot_grid.left + (loot.storage.grid_width * loot_grid.cell_size), loot_grid.top - 7);

        for (var grid_y = 0; grid_y < loot.storage.grid_height; grid_y++)
        {
            for (var grid_x = 0; grid_x < loot.storage.grid_width; grid_x++)
            {
                var cell_left = loot_grid.left + (grid_x * loot_grid.cell_size);
                var cell_top = loot_grid.top + (grid_y * loot_grid.cell_size);
                draw_set_color(c_dkgray);
                draw_rectangle(cell_left, cell_top, cell_left + loot_grid.cell_size, cell_top + loot_grid.cell_size, false);
                draw_set_color(c_green);
                draw_rectangle(cell_left, cell_top, cell_left + loot_grid.cell_size, cell_top + loot_grid.cell_size, true);
            }
        }

        for (var item_index = 0; item_index < array_length(loot.storage.items); item_index++)
        {
            var stored_item = loot.storage.items[item_index];
            var definition = item_get(stored_item.item_key);
            var item_width = definition.grid_width;
            var item_height = definition.grid_height;
            if (stored_item.rotation == 90)
            {
                var item_size = item_width;
                item_width = item_height;
                item_height = item_size;
            }
            draw_inventory_grid_item(
                stored_item,
                definition,
                loot_grid.left + (stored_item.x * loot_grid.cell_size),
                loot_grid.top + (stored_item.y * loot_grid.cell_size),
                item_width,
                item_height,
                loot_grid.cell_size,
                false
            );
        }
    }

    if (!is_undefined(raid.inventory_item))
    {
        var preview_grids = raid_inventory_get_grids();
        for (var preview_index = 0; preview_index < array_length(preview_grids); preview_index++)
        {
            var preview_grid = preview_grids[preview_index];
            var preview_x = floor((device_mouse_x_to_gui(0) - preview_grid.left) / 60);
            var preview_y = floor((device_mouse_y_to_gui(0) - preview_grid.top) / 60);
            if (preview_x >= 0 && preview_y >= 0 && preview_x < preview_grid.storage.grid_width && preview_y < preview_grid.storage.grid_height)
            {
                var preview_definition = item_get(raid.inventory_item.item_key);
                var preview_width = raid.inventory_rotation == 90 ? preview_definition.grid_height : preview_definition.grid_width;
                var preview_height = raid.inventory_rotation == 90 ? preview_definition.grid_width : preview_definition.grid_height;
                draw_set_alpha(0.45);
                draw_set_color(inventory_can_place_item(raid.inventory_item, preview_x, preview_y, preview_grid.storage) ? c_lime : c_red);
                draw_rectangle(preview_grid.left + preview_x * 60 + 4, preview_grid.top + preview_y * 60 + 4, preview_grid.left + (preview_x + preview_width) * 60 - 4, preview_grid.top + (preview_y + preview_height) * 60 - 4, false);
                draw_set_alpha(1);
                break;
            }
        }
    }

    if (!is_undefined(raid.inventory_item))
    {
        var held_definition = item_get(raid.inventory_item.item_key);
        var held_width = held_definition.grid_width;
        var held_height = held_definition.grid_height;
        if (raid.inventory_rotation == 90)
        {
            var held_size = held_width;
            held_width = held_height;
            held_height = held_size;
        }
        draw_set_alpha(0.5);
        draw_inventory_grid_item(raid.inventory_item, held_definition, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), held_width, held_height, 60, false, c_white);
        draw_set_alpha(1);

        draw_set_font(fnt_terminal_tiny);
        draw_set_color(c_white);
        var held_item_name_width = string_width(held_definition.name);
        draw_text(
            device_mouse_x_to_gui(0) + ((held_width * 60 - held_item_name_width) * 0.5),
            device_mouse_y_to_gui(0) - 18,
            held_definition.name
        );
    }

    terminal_prompt("CLICK: SELECT / PLACE    R: ROTATE    RIGHT CLICK: CANCEL    U/ESC: CLOSE");
    draw_set_font(fnt_terminal);
}

function raid_inventory_get_grids()
{
    // Match draw_stash_equipment_and_carried_storage's raid panel layout.
    var grids = [];
    var secure_top = 518;
    if (crew[raid.crew_index].bag != "")
    {
        array_push(grids, { storage: stash.backpack, left: 670, top: 150 });
        secure_top = 348 + (stash.backpack.grid_height * 60);
    }
    array_push(grids, { storage: stash.secure_container, left: 670, top: secure_top });
    var loot_grid = raid_inventory_get_loot_grid();
    if (!is_undefined(loot_grid)) array_push(grids, loot_grid);
    return grids;
}

function raid_inventory_get_loot_grid()
{
    if (is_undefined(raid.active_loot_container)) return undefined;

    return {
        key: "loot",
        storage: raid.active_loot_container.storage,
        left: 1300,
        top: 150,
        cell_size: 60
    };
}

function raid_inventory_get_hotbar_rect()
{
    var secure_top = 518;
    if (crew[raid.crew_index].bag != "")
        secure_top = 348 + (stash.backpack.grid_height * 60);

    return { left: 40, top: secure_top + 48 + (stash.secure_container.grid_height * 60) + 234, width: 424, height: 64 };
}

function raid_inventory_clear_held()
{
    if (!is_undefined(raid.inventory_item) && !is_undefined(raid.inventory_container))
        array_push(raid.inventory_container.items, raid.inventory_item);

    raid.inventory_item = undefined;
    raid.inventory_container = undefined;
}

function step_raid_inventory()
{
    if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("U")))
    {
        raid_inventory_clear_held();
        raid.active_loot_container = undefined;
        overlay_mode = OverlayMode.NONE;
        return;
    }

    if (!is_undefined(raid.inventory_item)
    && is_undefined(raid.inventory_container))
        raid_inventory_clear_held();

    if (mouse_check_button_pressed(mb_right)) raid_inventory_clear_held();
    if (!is_undefined(raid.inventory_item) && keyboard_check_pressed(ord("R")))
        raid.inventory_rotation = raid.inventory_rotation == 90 ? 0 : 90;

    if (!mouse_check_button_pressed(mb_left)) return;
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
                raid.inventory_rotation = item.rotation;
                return;
            }
        }
    }
}
