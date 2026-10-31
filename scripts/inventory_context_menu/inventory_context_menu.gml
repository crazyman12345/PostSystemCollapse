function inventory_context_menu_close()
{
    inventory_context_active = false;
    inventory_context_item = undefined;
    inventory_context_container = undefined;
    inventory_context_equipment_slot = -1;
    inventory_context_actions = [];
    inventory_context_trader_key = "";
}

function inventory_context_menu_get_equip_slot(_definition, _crew_index)
{
    var _member = crew[_crew_index];
    switch (_definition.category)
    {
        case ItemCategory.WEAPON:
            if (_member.weapon == "") return EquipmentSlot.WEAPON;
            if (_member.weapon_2 == "") return EquipmentSlot.WEAPON_2;
            break;
        case ItemCategory.HEAD_ARMOR: if (_member.armor_head == "") return EquipmentSlot.HEAD; break;
        case ItemCategory.BODY_ARMOR: if (_member.armor_chest == "") return EquipmentSlot.CHEST; break;
        case ItemCategory.BAG: if (_member.bag == "") return EquipmentSlot.BAG; break;
    }
    return -1;
}

function inventory_context_menu_open(_item, _container, _equipment_slot, _allow_destroy, _allow_use, _raid_context, _trader_key = "")
{
    if (is_undefined(_item)) return false;
    var _definition = item_get(_item.item_key);
    if (is_undefined(_definition)) return false;

    var _actions = _item.item_key == "supply_crate"
        ? [{ key: "open_supply_crate", label: "OPEN" }]
        : [{ key: "inspect", label: "INSPECT" }];
    var _crew_index = _raid_context ? raid.crew_index : 0;
    var _equip_slot = -1;
    if (_item.item_key == "supply_crate")
    {
        // The sealed crate has only one context action.
    }
    else if (_trader_key != "")
    {
        if (_container == stash && trader_will_buy_item(_trader_key, _item.item_key))
            array_push(_actions, { key: "sell", label: "SELL" });
    }
    else
    {
        if (_equipment_slot != -1)
        {
            if (_equipment_slot != EquipmentSlot.BAG || array_length(stash.backpack.items) == 0)
                array_push(_actions, { key: "unequip", label: "UNEQUIP" });
        }
        else
        {
            _equip_slot = inventory_context_menu_get_equip_slot(_definition, _crew_index);
            if (_equip_slot != -1) array_push(_actions, { key: "equip", label: "EQUIP" });
        }

        if (_allow_use && raid_hotbar_is_usable(_definition))
        {
            var _use_label = "USE";
            if (_definition.category == ItemCategory.CONSUMABLE
            && variable_struct_exists(_definition, "consumable_animation"))
                _use_label = _definition.consumable_animation == "drink" ? "DRINK" : "EAT";
            array_push(_actions, { key: "use", label: _use_label });
        }
        if (_allow_destroy && !is_undefined(_container))
            array_push(_actions, { key: "destroy", label: "DESTROY" });
    }
    if (array_length(_actions) == 0) return false;

    inventory_context_active = true;
    inventory_context_item = _item;
    inventory_context_container = _container;
    inventory_context_equipment_slot = _equipment_slot;
    inventory_context_equip_slot = _equip_slot;
    inventory_context_raid = _raid_context;
    inventory_context_trader_key = _trader_key;
    inventory_context_actions = _actions;
    inventory_context_x = clamp(device_mouse_x_to_gui(0), 0, display_get_gui_width() - 104);
    inventory_context_y = clamp(device_mouse_y_to_gui(0), 0, display_get_gui_height() - array_length(_actions) * 22);
    inventory_hover_item = undefined;
    inventory_hover_time = 0;
    inventory_inspect_item = undefined;
    return true;
}

function inventory_context_menu_set_equipped(_slot, _item, _crew_index)
{
    var _member = crew[_crew_index];
    var _item_key = is_undefined(_item) ? "" : _item.item_key;
    switch (_slot)
    {
        case EquipmentSlot.WEAPON: _member.weapon = _item_key; stash.equipped_weapon_item = _item; break;
        case EquipmentSlot.WEAPON_2: _member.weapon_2 = _item_key; stash.equipped_weapon_2_item = _item; break;
        case EquipmentSlot.HEAD: _member.armor_head = _item_key; stash.equipped_armor_head_item = _item; break;
        case EquipmentSlot.CHEST: _member.armor_chest = _item_key; stash.equipped_armor_chest_item = _item; break;
        case EquipmentSlot.BAG:
            _member.bag = _item_key;
            stash.equipped_bag_item = _item;
            if (!is_undefined(_item))
            {
                var _definition = item_get(_item_key);
                stash.backpack.grid_width = _definition.storage_width;
                stash.backpack.grid_height = _definition.storage_height;
            }
            break;
    }
    crew[_crew_index] = _member;
}

function inventory_context_menu_execute(_action)
{
    var _item = inventory_context_item;
    if (is_undefined(_item)) return;

    switch (_action)
    {
        case "open_supply_crate":
            onboarding_open_supply_crate(_item, inventory_context_container);
            break;

        case "inspect":
            inventory_inspect_item = _item;
            inventory_inspect_x = inventory_context_x;
            inventory_inspect_y = inventory_context_y;
            break;

        case "destroy":
            stash_remove_item(_item, inventory_context_container);
            for (var _slot = 0; _slot < array_length(raid.hotbar); _slot++)
                if (raid.hotbar[_slot] == _item) raid.hotbar[_slot] = undefined;
            save_mark_dirty();
            break;

        case "sell":
            trader_sell_stored_item(inventory_context_trader_key, _item, inventory_context_container);
            break;

        case "equip":
            if (inventory_context_equip_slot != -1
            && stash_remove_item(_item, inventory_context_container))
            {
                if (inventory_context_raid)
                    raid_inventory_set_equipped_item(inventory_context_equip_slot, _item);
                else
                    inventory_context_menu_set_equipped(inventory_context_equip_slot, _item, 0);
                save_mark_dirty();
            }
            break;

        case "unequip":
            if (inventory_context_raid)
            {
                raid.inventory_item = _item;
                raid.inventory_container = undefined;
                raid.inventory_equipment_slot = inventory_context_equipment_slot;
                raid.inventory_rotation = _item.rotation;
                raid_inventory_set_equipped_item(inventory_context_equipment_slot, undefined);
                save_mark_dirty();
            }
            else if (stash_place_existing_item(_item, stash))
            {
                inventory_context_menu_set_equipped(inventory_context_equipment_slot, undefined, 0);
                stash_index = array_length(stash.items) - 1;
                save_mark_dirty();
            }
            break;

        case "use":
            var _definition = item_get(_item.item_key);
            if (variable_struct_exists(_definition, "treatment_effect"))
            {
                var _target = player_health_treatment_get_auto_target(_definition);
                if (!is_undefined(_target)) player_health_treatment_start(_item, _target.type, _target.limb);
            }
            else if (variable_struct_exists(_definition, "max_servings"))
            {
                player_health_consumable_start(_item);
            }
            break;
    }
}

function inventory_context_menu_step()
{
    if (!is_undefined(inventory_inspect_item))
    {
        if (mouse_check_button_pressed(mb_right))
        {
            inventory_inspect_item = undefined;
            return false;
        }
        if (keyboard_check_pressed(vk_escape) || mouse_check_button_pressed(mb_left))
            inventory_inspect_item = undefined;
        return true;
    }
    if (!inventory_context_active) return false;
    if (mouse_check_button_pressed(mb_right))
    {
        inventory_context_menu_close();
        return false;
    }
    if (keyboard_check_pressed(vk_escape))
    {
        inventory_context_menu_close();
        return true;
    }
    if (mouse_check_button_pressed(mb_left))
    {
        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);
        var _row = floor((_mouse_y - inventory_context_y) / 22);
        if (_mouse_x >= inventory_context_x && _mouse_x < inventory_context_x + 104
        && _row >= 0 && _row < array_length(inventory_context_actions))
            inventory_context_menu_execute(inventory_context_actions[_row].key);
        inventory_context_menu_close();
    }
    return true;
}

function inventory_context_menu_draw()
{
    if (!inventory_context_active) return;
    var _height = array_length(inventory_context_actions) * 22;
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    draw_set_alpha(0.96);
    draw_set_color(c_black);
    draw_rectangle(inventory_context_x, inventory_context_y, inventory_context_x + 104, inventory_context_y + _height, false);
    draw_set_alpha(1);
    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    for (var _i = 0; _i < array_length(inventory_context_actions); _i++)
    {
        var _top = inventory_context_y + _i * 22;
        var _hovered = point_in_rectangle(_mouse_x, _mouse_y, inventory_context_x, _top, inventory_context_x + 104, _top + 22);
        draw_set_color(global.ui_interactive_color);
        draw_rectangle(inventory_context_x, _top, inventory_context_x + 104, _top + 22, true);
        draw_text(inventory_context_x + 7, _top + 5, inventory_context_actions[_i].label);
    }
    draw_set_font(fnt_terminal);
}
