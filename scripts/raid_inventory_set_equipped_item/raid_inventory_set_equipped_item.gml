function raid_inventory_set_equipped_item(_slot, _item)
{
    var member = crew[raid.crew_index];
    var item_key = is_undefined(_item) ? "" : _item.item_key;

    switch (_slot)
    {
        case EquipmentSlot.WEAPON:
            member.weapon = item_key;
            stash.equipped_weapon_item = _item;
            break;
        case EquipmentSlot.WEAPON_2:
            member.weapon_2 = item_key;
            stash.equipped_weapon_2_item = _item;
            break;
        case EquipmentSlot.HEAD:
            member.armor_head = item_key;
            stash.equipped_armor_head_item = _item;
            break;
        case EquipmentSlot.CHEST:
            member.armor_chest = item_key;
            stash.equipped_armor_chest_item = _item;
            break;
        case EquipmentSlot.BAG:
            member.bag = item_key;
            stash.equipped_bag_item = _item;
            if (!is_undefined(_item))
            {
                var bag_definition = item_get(item_key);
                stash.backpack.grid_width = bag_definition.storage_width;
                stash.backpack.grid_height = bag_definition.storage_height;
            }
            break;
    }

    crew[raid.crew_index] = member;

    if ((_slot == EquipmentSlot.WEAPON || _slot == EquipmentSlot.WEAPON_2) && is_undefined(_item))
    {
        if (_slot == active_weapon_slot)
            active_weapon_slot = _slot == EquipmentSlot.WEAPON ? EquipmentSlot.WEAPON_2 : EquipmentSlot.WEAPON;
    }
    raid_update_active_weapon();
}
