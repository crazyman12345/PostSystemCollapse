function draw_hideout_stash()
{
    inventory_hover_begin();
    // ==========================================
    // MAIN LAYOUT
    // ==========================================

    var panel_left = 330;
    var panel_top = 80;
    var panel_width = 1570;
    var panel_height = 970;

    var equipment_left = panel_left + 20;
    var equipment_width = 450;

    var stash_right_margin = 25;
    var grid_top = panel_top + 70;
    var stash_cell_size = 60;

    var stash_left =
        1920
        - stash_right_margin
        - (stash.grid_width * stash_cell_size);

    var middle_left =
        equipment_left
        + equipment_width
        + 15;

    var middle_width =
        stash_left
        - middle_left
        - 15;

    var container_cell_size = 60;

    var backpack_grid_left = middle_left + 165;
    var backpack_grid_top = grid_top;

    var pockets_grid_left = middle_left;
    var pockets_grid_top = backpack_grid_top + 328;
    var pockets_cell_stride = 66;

    var secure_grid_left = middle_left + 165;
    var secure_grid_top = pockets_grid_top + 122;

    var item_count = array_length(stash.items);
    var member = crew[0];


    // ==========================================
    // MAIN PANEL
    // ==========================================

    draw_set_color(c_black);

    draw_rectangle(
        panel_left,
        panel_top,
        panel_left + panel_width,
        panel_top + panel_height,
        false
    );

    draw_set_color(c_lime);
    draw_set_font(fnt_terminal_small);

    terminal_panel(
        panel_left,
        panel_top,
        panel_width,
        panel_height,
        "STASH"
    );


    draw_stash_equipment_and_carried_storage(member, false);
    draw_player_status_panel(395, 790, 360);

    draw_text(stash_left, grid_top - 25, "MAIN STASH");
    draw_line(stash_left, grid_top - 7, stash_left + (stash.grid_width * stash_cell_size), grid_top - 7);
    // ==========================================
    // MAIN STASH GRID
    // ==========================================

    for (
        var grid_y = 0;
        grid_y < stash.grid_height;
        grid_y++
    )
    {
        for (
            var grid_x = 0;
            grid_x < stash.grid_width;
            grid_x++
        )
        {
            var cell_left =
                stash_left
                + (
                    grid_x
                    * stash_cell_size
                );

            var cell_top =
                grid_top
                + (
                    grid_y
                    * stash_cell_size
                );

            draw_set_color(c_dkgray);

            draw_rectangle(
                cell_left,
                cell_top,
                cell_left + stash_cell_size,
                cell_top + stash_cell_size,
                false
            );

            draw_set_color(c_green);

            draw_rectangle(
                cell_left,
                cell_top,
                cell_left + stash_cell_size,
                cell_top + stash_cell_size,
                true
            );
        }
    }


    // ==========================================
    // GRID ITEMS
    // ==========================================

    var item_grids = [{ key: "stash", storage: stash, left: stash_left, top: grid_top, cell_size: stash_cell_size }];

    if (member.bag != "")
    {
        var backpack_definition = item_get(member.bag);

        if (!is_undefined(backpack_definition))
        {
            stash.backpack.grid_width = backpack_definition.grid_width;
            stash.backpack.grid_height = backpack_definition.grid_height;
            pockets_grid_top = backpack_grid_top + max(328, (stash.backpack.grid_height * container_cell_size) + 28);
            secure_grid_top = pockets_grid_top + 122;
            array_push(item_grids, { key: "backpack", storage: stash.backpack, left: backpack_grid_left, top: backpack_grid_top, cell_size: container_cell_size });
        }
    }

    array_push(item_grids, { key: "pockets", storage: stash.pockets, left: pockets_grid_left, top: pockets_grid_top, cell_size: stash_cell_size, cell_stride: pockets_cell_stride });
    array_push(item_grids, { key: "secure", storage: stash.secure_container, left: secure_grid_left, top: secure_grid_top + 48, cell_size: stash_cell_size });

    for (var grid_index = 0; grid_index < array_length(item_grids); grid_index++)
    {
        var item_grid = item_grids[grid_index];
        var item_grid_stride = variable_struct_exists(item_grid, "cell_stride") ? item_grid.cell_stride : item_grid.cell_size;

        for (var i = 0; i < array_length(item_grid.storage.items); i++)
        {
            var stash_item = item_grid.storage.items[i];

            var definition = item_get(stash_item.item_key);

            var item_width = definition.grid_width;

            var item_height = definition.grid_height;

            if (stash_item.rotation == 90)
            {
                var size = item_width;

                item_width = item_height;

                item_height = size;
            }

            var item_left = item_grid.left + (stash_item.x * item_grid_stride);

            var item_top = item_grid.top + (stash_item.y * item_grid_stride);

            var item_right = item_left + (item_width * item_grid.cell_size);

            var item_bottom = item_top + (item_height * item_grid.cell_size);

            draw_inventory_grid_item(stash_item, definition, item_left, item_top, item_width, item_height, item_grid.cell_size, item_grid.key == "stash" && i == stash_index);
            inventory_hover_consider(stash_item, item_left, item_top, item_right, item_bottom);
        }
    }


    // ==========================================
    // HELD ITEM PREVIEW
    // ==========================================

    var held_definition = undefined;
    var preview_width = 0;
    var preview_height = 0;

    if (
        !is_undefined(stash.held_item)
        && stash.hover_x >= 0
        && stash.hover_y >= 0
    )
    {
        held_definition =
            item_get(stash.held_item.item_key);

        preview_width =
            held_definition.grid_width;

        preview_height =
            held_definition.grid_height;

        if (stash.held_item.rotation == 90)
        {
            var preview_size =
                preview_width;

            preview_width =
                preview_height;

            preview_height =
                preview_size;
        }

        for (var grid_index = 0; grid_index < array_length(item_grids); grid_index++)
        {
            var item_grid = item_grids[grid_index];

            if (item_grid.key == stash.hover_container)
            {
                var preview_stride = variable_struct_exists(item_grid, "cell_stride") ? item_grid.cell_stride : item_grid.cell_size;
                var preview_left = item_grid.left + (stash.hover_x * preview_stride);
                var preview_top = item_grid.top + (stash.hover_y * preview_stride);
                var preview_valid = inventory_can_place_item(stash.held_item, stash.hover_x, stash.hover_y, item_grid.storage);

                draw_set_alpha(0.45);
                draw_set_color(preview_valid ? c_lime : c_red);
                draw_rectangle(preview_left + 4, preview_top + 4, preview_left + (preview_width * item_grid.cell_size) - 4, preview_top + (preview_height * item_grid.cell_size) - 4, false);
                draw_set_alpha(1);
                break;
            }
        }
    }

    if (!is_undefined(stash.held_item))
    {
        if (is_undefined(held_definition)) held_definition = item_get(stash.held_item.item_key);
        if (preview_width == 0)
        {
            preview_width = held_definition.grid_width;
            preview_height = held_definition.grid_height;

            if (stash.held_item.rotation == 90)
            {
                var held_item_size = preview_width;
                preview_width = preview_height;
                preview_height = held_item_size;
            }
        }

        var held_mouse_x = device_mouse_x_to_gui(0);
        var held_mouse_y = device_mouse_y_to_gui(0);
        var held_item_left = held_mouse_x;
        var held_item_top = held_mouse_y;

        draw_set_alpha(0.5);
        draw_inventory_grid_item(stash.held_item, held_definition, held_item_left, held_item_top, preview_width, preview_height, stash_cell_size, false);
        draw_set_alpha(1);

        draw_set_font(fnt_terminal_tiny);
        draw_set_color(c_white);
        var held_item_name_width = string_width(held_definition.name);
        draw_text(
            held_item_left + ((preview_width * stash_cell_size - held_item_name_width) * 0.5),
            held_item_top - 18,
            held_definition.name
        );
    }


    // ==========================================
    // CONTROLS
    // ==========================================

    draw_set_color(c_lime);

    draw_text(
        equipment_left,
        panel_top + 925,
        "W/S: SELECT MAIN STASH ITEM"
    );

    draw_text(
        equipment_left,
        panel_top + 950,
        "R: ROTATE HELD ITEM | ESC: CLOSE"
    );

    draw_set_alpha(1);
    draw_set_font(fnt_terminal);
    inventory_hover_finish();
    inventory_hover_draw();
}
