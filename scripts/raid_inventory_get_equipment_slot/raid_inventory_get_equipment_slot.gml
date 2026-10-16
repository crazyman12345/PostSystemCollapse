function raid_inventory_get_equipment_slot(_mouse_x, _mouse_y)
{
    if (_mouse_x >= 220 && _mouse_x < 310 && _mouse_y >= 155 && _mouse_y < 245) return EquipmentSlot.HEAD;
    if (_mouse_x >= 190 && _mouse_x < 340 && _mouse_y >= 250 && _mouse_y < 470) return EquipmentSlot.CHEST;
    if (_mouse_x >= 85 && _mouse_x < 445 && _mouse_y >= 500 && _mouse_y < 600) return EquipmentSlot.WEAPON;
    if (_mouse_x >= 85 && _mouse_x < 445 && _mouse_y >= 620 && _mouse_y < 720) return EquipmentSlot.WEAPON_2;
    if (_mouse_x >= 505 && _mouse_x < 655 && _mouse_y >= 150 && _mouse_y < 370) return EquipmentSlot.BAG;
    return -1;
}
