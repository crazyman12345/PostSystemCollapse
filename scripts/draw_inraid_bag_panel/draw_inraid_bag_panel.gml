function draw_inraid_bag_panel()
{
    draw_set_font(fnt_terminal_small);
    terminal_panel(20, 80, 1880, 970, "RAID INVENTORY");
    draw_stash_equipment_and_carried_storage(crew[raid.crew_index], true, 20, 1880);
    draw_raid_hotbar(true);
    draw_player_status_panel(85, 790, 360, true);

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
            inventory_hover_consider(stored_item, loot_grid.left + (stored_item.x * loot_grid.cell_size), loot_grid.top + (stored_item.y * loot_grid.cell_size), loot_grid.left + ((stored_item.x + item_width) * loot_grid.cell_size), loot_grid.top + ((stored_item.y + item_height) * loot_grid.cell_size));
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
