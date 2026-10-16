function raid_inventory_item_fits_equipment(_item, _slot)
{
    if (is_undefined(_item) || equipment_get_slot_item(raid.crew_index, _slot) != "") return false;
    var definition = item_get(_item.item_key);
    if (is_undefined(definition)) return false;

    switch (_slot)
    {
        case EquipmentSlot.WEAPON:
        case EquipmentSlot.WEAPON_2: return definition.category == ItemCategory.WEAPON;
        case EquipmentSlot.HEAD: return definition.category == ItemCategory.HEAD_ARMOR;
        case EquipmentSlot.CHEST: return definition.category == ItemCategory.BODY_ARMOR;
        case EquipmentSlot.BAG: return definition.category == ItemCategory.BAG;
    }
    return false;
}
