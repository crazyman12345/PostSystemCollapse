function equipment_equip_item(
    _crew_index,
    _slot,
    _new_item_key
)
{
    var member =
        crew[_crew_index];

    var old_item;

    switch (_slot)
    {
        case EquipmentSlot.WEAPON: old_item = stash.equipped_weapon_item; break;
        case EquipmentSlot.WEAPON_2: old_item = stash.equipped_weapon_2_item; break;
        case EquipmentSlot.HEAD: old_item = stash.equipped_armor_head_item; break;
        case EquipmentSlot.CHEST: old_item = stash.equipped_armor_chest_item; break;
        case EquipmentSlot.BAG: old_item = stash.equipped_bag_item; break;
    }

    var source = raid.active ? stash.backpack : stash;
    var new_item = undefined;


    // ==============================
    // REMOVE NEW ITEM FROM SOURCE
    // ==============================

    if (_new_item_key != "")
    {
        var matching_items = stash_find_items(_new_item_key, source);

        if (array_length(matching_items) == 0)
        {
            log_add(
                "Unable to equip item."
            );

            return false;
        }

        new_item = matching_items[0];
        stash_remove_item(new_item, source);
    }


    // ==============================
    // RETURN OLD ITEM
    // ==============================

    if (!is_undefined(old_item))
    {
        if (!stash_place_existing_item(old_item, source))
        {
            if (!is_undefined(new_item)) array_push(source.items, new_item);
            log_add("Unable to unequip item: not enough storage space.");
            return false;
        }
    }


    // ==============================
    // EQUIP NEW ITEM
    // ==============================

    switch (_slot)
    {
        case EquipmentSlot.WEAPON:
            member.weapon =
                _new_item_key;
            stash.equipped_weapon_item = new_item;
            break;

        case EquipmentSlot.WEAPON_2:
            member.weapon_2 =
                _new_item_key;
            stash.equipped_weapon_2_item = new_item;
            break;

        case EquipmentSlot.HEAD:
            member.armor_head =
                _new_item_key;
            stash.equipped_armor_head_item = new_item;
            break;

        case EquipmentSlot.CHEST:
            member.armor_chest =
                _new_item_key;
            stash.equipped_armor_chest_item = new_item;
            break;

        case EquipmentSlot.BAG:
            member.bag =
                _new_item_key;
            stash.equipped_bag_item = new_item;

            if (!is_undefined(new_item))
            {
                var bag_definition = item_get(_new_item_key);
                stash.backpack.grid_width = bag_definition.grid_width;
                stash.backpack.grid_height = bag_definition.grid_height;
            }
            break;
    }


    crew[_crew_index] =
        member;

    if (raid.active)
    {
        if (
            _slot == active_weapon_slot
            && _new_item_key == ""
        )
        {
            if (
                _slot == EquipmentSlot.WEAPON
                && !is_undefined(
                    raid_get_weapon_in_slot(EquipmentSlot.WEAPON_2)
                )
            )
            {
                active_weapon_slot = EquipmentSlot.WEAPON_2;
            }
            else if (
                _slot == EquipmentSlot.WEAPON_2
                && !is_undefined(
                    raid_get_weapon_in_slot(EquipmentSlot.WEAPON)
                )
            )
            {
                active_weapon_slot = EquipmentSlot.WEAPON;
            }
        }

        raid_update_active_weapon();
    }

    return true;
}
