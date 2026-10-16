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

    draw_equipment_slot(equipment_center - 45, grid_top + 5, 90, 90, "HELMET", _member.armor_head, false, true);
    draw_equipment_slot(equipment_center - 75, grid_top + 100, 150, 220, "CHEST", _member.armor_chest, false, true);
    draw_equipment_slot(equipment_center - 180, grid_top + 350, 360, 100, "WEAPON 1", _member.weapon, false, true);
    draw_equipment_slot(equipment_center - 180, grid_top + 470, 360, 100, "WEAPON 2", _member.weapon_2, false, true);
    draw_equipment_slot(middle_left, grid_top, 150, 220, "BACKPACK", _member.bag, false, true);

    var preview_item = raid.state != RaidState.INACTIVE && raid.state != RaidState.RESULT ? raid.inventory_item : stash.held_item;

    if (!is_undefined(preview_item))
    {
        var held_definition = item_get(preview_item.item_key);

        if (!is_undefined(held_definition))
        {
            var held_source_valid = (raid.state != RaidState.INACTIVE && raid.state != RaidState.RESULT) || stash.held_source == "stash" || stash.held_source == "equipment";
            var bag_source_valid = (raid.state != RaidState.INACTIVE && raid.state != RaidState.RESULT) || stash.held_source == "stash";
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
	var secure_container_item = variable_struct_exists(stash, "equipped_secure_container_item") ? stash.equipped_secure_container_item : undefined;
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

    draw_equipment_slot(middle_left, secure_grid_top, 150, 150, "CONTAINER", _member.secure_container, false, true);
	if (is_undefined(secure_container_item)) inventory_hover_consider_key(_member.secure_container, middle_left, secure_grid_top, middle_left + 150, secure_grid_top + 150);
	else inventory_hover_consider(secure_container_item, middle_left, secure_grid_top, middle_left + 150, secure_grid_top + 150);

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