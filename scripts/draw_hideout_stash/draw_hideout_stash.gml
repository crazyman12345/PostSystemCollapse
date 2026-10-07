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

    var secure_grid_left = middle_left + 165;
    var secure_grid_top = backpack_grid_top + 320;

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
            secure_grid_top = backpack_grid_top + (stash.backpack.grid_height * container_cell_size) + 150;
            array_push(item_grids, { key: "backpack", storage: stash.backpack, left: backpack_grid_left, top: backpack_grid_top, cell_size: container_cell_size });
        }
    }

    array_push(item_grids, { key: "secure", storage: stash.secure_container, left: secure_grid_left, top: secure_grid_top + 48, cell_size: stash_cell_size });

    for (var grid_index = 0; grid_index < array_length(item_grids); grid_index++)
    {
        var item_grid = item_grids[grid_index];

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

            var item_left = item_grid.left + (stash_item.x * item_grid.cell_size);

            var item_top = item_grid.top + (stash_item.y * item_grid.cell_size);

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
                var preview_left = item_grid.left + (stash.hover_x * item_grid.cell_size);
                var preview_top = item_grid.top + (stash.hover_y * item_grid.cell_size);
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

function draw_stash_equipment_and_carried_storage(_member, _draw_items = true, _panel_left = 330, _panel_width = 1570)
{
    var equipment_left = _panel_left + 20;
    var equipment_width = 450;
    var middle_left = equipment_left + equipment_width + 15;
    var stash_left = _panel_left + _panel_width - 25 - (stash.grid_width * 60);
    var middle_width = stash_left - middle_left - 15;
    var grid_top = 150;
    var cell_size = 60;
    var equipment_center = equipment_left + (equipment_width * 0.5);
    var backpack_grid_left = middle_left + 165;
    var backpack_grid_top = grid_top;
    var secure_grid_left = middle_left + 165;
    var secure_grid_top = backpack_grid_top + 320;

    draw_text(equipment_left, grid_top - 25, "EQUIPMENT");
    draw_line(equipment_left, grid_top - 7, equipment_left + equipment_width, grid_top - 7);
    draw_text(middle_left, grid_top - 25, "CARRIED STORAGE");
    draw_line(middle_left, grid_top - 7, middle_left + middle_width, grid_top - 7);

    if (equipment_silhouette_sprite != -1 && sprite_exists(equipment_silhouette_sprite))
    {
        var silhouette_width = sprite_get_width(equipment_silhouette_sprite);
        var silhouette_height = sprite_get_height(equipment_silhouette_sprite);
        var silhouette_scale = min(430 / silhouette_width, 760 / silhouette_height);
        var silhouette_left = equipment_center - ((silhouette_width * silhouette_scale) * 0.5);

        draw_set_alpha(0.55);
        draw_sprite_part_ext(equipment_silhouette_sprite, 0, 0, 0, silhouette_width, silhouette_height, silhouette_left, grid_top + 15, silhouette_scale, silhouette_scale, c_gray, 1);
        draw_set_alpha(1);
    }

    draw_equipment_slot(equipment_center - 45, grid_top + 5, 90, 90, "HEAD ARMOR", _member.armor_head, false, true);
    draw_equipment_slot(equipment_center - 75, grid_top + 100, 150, 220, "CHEST ARMOR", _member.armor_chest, false, true);
    draw_equipment_slot(equipment_center - 180, grid_top + 350, 360, 100, "WEAPON 1", _member.weapon, false, true);
    draw_equipment_slot(equipment_center - 180, grid_top + 470, 360, 100, "WEAPON 2", _member.weapon_2, false, true);
    draw_equipment_slot(middle_left, grid_top, 150, 220, "BACKPACK", _member.bag, false, true);

    var preview_item = raid.active ? raid.inventory_item : stash.held_item;

    if (!is_undefined(preview_item))
    {
        var held_definition = item_get(preview_item.item_key);

        if (!is_undefined(held_definition))
        {
            var held_source_valid = raid.active || stash.held_source == "stash" || stash.held_source == "equipment";
            var bag_source_valid = raid.active || stash.held_source == "stash";
            var gui_mouse_x = device_mouse_x_to_gui(0);
            var gui_mouse_y = device_mouse_y_to_gui(0);
            var equipment_previews = [
                { slot: EquipmentSlot.HEAD, item_key: _member.armor_head, category: ItemCategory.HEAD_ARMOR, left: equipment_center - 45, top: grid_top + 5, right: equipment_center + 45, bottom: grid_top + 95, source: held_source_valid },
                { slot: EquipmentSlot.CHEST, item_key: _member.armor_chest, category: ItemCategory.BODY_ARMOR, left: equipment_center - 75, top: grid_top + 100, right: equipment_center + 75, bottom: grid_top + 320, source: held_source_valid },
                { slot: EquipmentSlot.WEAPON, item_key: _member.weapon, category: ItemCategory.WEAPON, left: equipment_center - 180, top: grid_top + 350, right: equipment_center + 180, bottom: grid_top + 450, source: held_source_valid },
                { slot: EquipmentSlot.WEAPON_2, item_key: _member.weapon_2, category: ItemCategory.WEAPON, left: equipment_center - 180, top: grid_top + 470, right: equipment_center + 180, bottom: grid_top + 570, source: held_source_valid },
                { slot: EquipmentSlot.BAG, item_key: _member.bag, category: ItemCategory.BAG, left: middle_left, top: grid_top, right: middle_left + 150, bottom: grid_top + 220, source: bag_source_valid }
            ];

            for (var preview_index = 0; preview_index < array_length(equipment_previews); preview_index++)
            {
                var preview = equipment_previews[preview_index];

                if (gui_mouse_x < preview.left || gui_mouse_x >= preview.right
                || gui_mouse_y < preview.top || gui_mouse_y >= preview.bottom)
                {
                    continue;
                }

                var preview_valid = preview.item_key == ""
                    && preview.source
                    && held_definition.category == preview.category;

                draw_set_alpha(0.45);
                draw_set_color(preview_valid ? c_lime : c_red);
                draw_rectangle(preview.left + 4, preview.top + 4, preview.right - 4, preview.bottom - 4, false);
                draw_set_alpha(1);
            }
        }
    }

    var head_item = variable_struct_exists(stash, "equipped_armor_head_item") ? stash.equipped_armor_head_item : undefined;
    var chest_item = variable_struct_exists(stash, "equipped_armor_chest_item") ? stash.equipped_armor_chest_item : undefined;
    var weapon_item = variable_struct_exists(stash, "equipped_weapon_item") ? stash.equipped_weapon_item : undefined;
    var weapon_2_item = variable_struct_exists(stash, "equipped_weapon_2_item") ? stash.equipped_weapon_2_item : undefined;
    var bag_item = variable_struct_exists(stash, "equipped_bag_item") ? stash.equipped_bag_item : undefined;
    if (is_undefined(head_item)) inventory_hover_consider_key(_member.armor_head, equipment_center - 45, grid_top + 5, equipment_center + 45, grid_top + 95);
    else inventory_hover_consider(head_item, equipment_center - 45, grid_top + 5, equipment_center + 45, grid_top + 95);
    if (is_undefined(chest_item)) inventory_hover_consider_key(_member.armor_chest, equipment_center - 75, grid_top + 100, equipment_center + 75, grid_top + 320);
    else inventory_hover_consider(chest_item, equipment_center - 75, grid_top + 100, equipment_center + 75, grid_top + 320);
    if (is_undefined(weapon_item)) inventory_hover_consider_key(_member.weapon, equipment_center - 180, grid_top + 350, equipment_center + 180, grid_top + 450);
    else inventory_hover_consider(weapon_item, equipment_center - 180, grid_top + 350, equipment_center + 180, grid_top + 450);
    if (is_undefined(weapon_2_item)) inventory_hover_consider_key(_member.weapon_2, equipment_center - 180, grid_top + 470, equipment_center + 180, grid_top + 570);
    else inventory_hover_consider(weapon_2_item, equipment_center - 180, grid_top + 470, equipment_center + 180, grid_top + 570);
    if (is_undefined(bag_item)) inventory_hover_consider_key(_member.bag, middle_left, grid_top, middle_left + 150, grid_top + 220);
    else inventory_hover_consider(bag_item, middle_left, grid_top, middle_left + 150, grid_top + 220);

    if (_member.bag != "")
    {
        var backpack_definition = item_get(_member.bag);

        if (!is_undefined(backpack_definition))
        {
            stash.backpack.grid_width = backpack_definition.grid_width;
            stash.backpack.grid_height = backpack_definition.grid_height;

            for (var backpack_y = 0; backpack_y < stash.backpack.grid_height; backpack_y++)
            {
                for (var backpack_x = 0; backpack_x < stash.backpack.grid_width; backpack_x++)
                {
                    var backpack_cell_left = backpack_grid_left + (backpack_x * cell_size);
                    var backpack_cell_top = backpack_grid_top + (backpack_y * cell_size);
                    draw_set_color(c_dkgray);
                    draw_rectangle(backpack_cell_left, backpack_cell_top, backpack_cell_left + cell_size, backpack_cell_top + cell_size, false);
                    draw_set_color(c_green);
                    draw_rectangle(backpack_cell_left, backpack_cell_top, backpack_cell_left + cell_size, backpack_cell_top + cell_size, true);
                }
            }

            secure_grid_top = backpack_grid_top + (stash.backpack.grid_height * cell_size) + 150;
        }
    }

    draw_equipment_slot(middle_left, secure_grid_top, 150, 150, "SECURE CONTAINER", "", false, true);

    for (var secure_y = 0; secure_y < stash.secure_container.grid_height; secure_y++)
    {
        for (var secure_x = 0; secure_x < stash.secure_container.grid_width; secure_x++)
        {
            var secure_cell_left = secure_grid_left + (secure_x * cell_size);
            var secure_cell_top = secure_grid_top + 48 + (secure_y * cell_size);
            draw_set_color(c_dkgray);
            draw_rectangle(secure_cell_left, secure_cell_top, secure_cell_left + cell_size, secure_cell_top + cell_size, false);
            draw_set_color(c_green);
            draw_rectangle(secure_cell_left, secure_cell_top, secure_cell_left + cell_size, secure_cell_top + cell_size, true);
        }
    }

    if (!_draw_items) return;

    var containers = [
        { storage: stash.backpack, left: backpack_grid_left, top: backpack_grid_top, visible: _member.bag != "" },
        { storage: stash.secure_container, left: secure_grid_left, top: secure_grid_top + 48, visible: true }
    ];

    for (var container_index = 0; container_index < array_length(containers); container_index++)
    {
        var container = containers[container_index];
        if (!container.visible) continue;

        for (var item_index = 0; item_index < array_length(container.storage.items); item_index++)
        {
            var stored_item = container.storage.items[item_index];
            var definition = item_get(stored_item.item_key);
            var item_width = definition.grid_width;
            var item_height = definition.grid_height;

            if (stored_item.rotation == 90)
            {
                var item_size = item_width;
                item_width = item_height;
                item_height = item_size;
            }

            var item_left = container.left + (stored_item.x * cell_size);
            var item_top = container.top + (stored_item.y * cell_size);
            draw_inventory_grid_item(stored_item, definition, item_left, item_top, item_width, item_height, cell_size, false);
            inventory_hover_consider(stored_item, item_left, item_top, item_left + (item_width * cell_size), item_top + (item_height * cell_size));
        }
    }
}

function draw_inventory_grid_item(_stored_item, _definition, _left, _top, _grid_width, _grid_height, _cell_size, _selected, _text_color = c_black)
{
    var item_right = _left + (_grid_width * _cell_size);
    var item_bottom = _top + (_grid_height * _cell_size);

    draw_set_color(_selected ? c_lime : c_gray);
    draw_rectangle(_left + 4, _top + 4, item_right - 4, item_bottom - 4, false);

    var grid_sprite = -1;
    if (variable_struct_exists(_definition, "icon_sprite")) grid_sprite = _definition.icon_sprite;
    if ((grid_sprite == -1 || !sprite_exists(grid_sprite)) && variable_struct_exists(_definition, "weapon_sprite")) grid_sprite = _definition.weapon_sprite;
    if ((grid_sprite == -1 || !sprite_exists(grid_sprite)) && variable_struct_exists(_definition, "sprite_idle")) grid_sprite = _definition.sprite_idle;

    if (grid_sprite == -1 || !sprite_exists(grid_sprite)) grid_sprite = spr_error;
    var has_sprite = grid_sprite != -1 && sprite_exists(grid_sprite);

    if (has_sprite)
    {
        var padding = 8;
        var available_width = max(1, (item_right - _left) - (padding * 2));
        var available_height = max(1, (item_bottom - _top) - (padding * 2));
        var _bbox_left = sprite_get_bbox_left(grid_sprite);
        var _bbox_top = sprite_get_bbox_top(grid_sprite);
        var _bbox_right = sprite_get_bbox_right(grid_sprite);
        var _bbox_bottom = sprite_get_bbox_bottom(grid_sprite);
        var _bbox_width = _bbox_right - _bbox_left + 1;
        var _bbox_height = _bbox_bottom - _bbox_top + 1;
        var sprite_rotation = _stored_item.rotation == 90 && _definition.grid_width != _definition.grid_height ? 90 : 0;
        var visible_center_x = ((_bbox_left + _bbox_right) * 0.5) - sprite_get_xoffset(grid_sprite);
        var visible_center_y = ((_bbox_top + _bbox_bottom) * 0.5) - sprite_get_yoffset(grid_sprite);
        var fit_width = sprite_rotation == 90 ? _bbox_height : _bbox_width;
        var fit_height = sprite_rotation == 90 ? _bbox_width : _bbox_height;
        var sprite_scale = min(available_width / fit_width, available_height / fit_height);
        var center_x = ( _left + item_right ) * 0.5;
        var center_y = ( _top + item_bottom ) * 0.5;
        var offset_distance = point_distance(0, 0, visible_center_x, visible_center_y);
        var offset_direction = point_direction(0, 0, visible_center_x, visible_center_y);
        var rotated_offset_x = lengthdir_x(offset_distance * sprite_scale, offset_direction + sprite_rotation);
        var rotated_offset_y = lengthdir_y(offset_distance * sprite_scale, offset_direction + sprite_rotation);

        draw_sprite_ext(grid_sprite, 0, center_x - rotated_offset_x, center_y - rotated_offset_y, sprite_scale, sprite_scale, sprite_rotation, c_white, 1);
    }
    else
    {
        draw_set_color(_text_color);

        draw_text_ext(_left + 10, _top + 10, _definition.name, 20, (_grid_width * _cell_size) - 20);
    }

    if (_stored_item.quantity > 1)
    {
        var previous_halign = draw_get_halign();
        draw_set_color(c_black);
        draw_set_halign(fa_right);
        draw_text(item_right - 8, _top + 8, "x" + format_compact_number(_stored_item.quantity));
        draw_set_halign(previous_halign);
    }
}
