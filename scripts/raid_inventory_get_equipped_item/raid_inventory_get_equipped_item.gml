function raid_inventory_get_equipped_item(_slot)
{
    switch (_slot)
    {
        case EquipmentSlot.WEAPON: return stash.equipped_weapon_item;
        case EquipmentSlot.WEAPON_2: return stash.equipped_weapon_2_item;
        case EquipmentSlot.HEAD: return stash.equipped_armor_head_item;
        case EquipmentSlot.CHEST: return stash.equipped_armor_chest_item;
        case EquipmentSlot.BAG: return stash.equipped_bag_item;
    }
    return undefined;
}
