function raid_switch_weapon()
{
    if (active_weapon_slot == EquipmentSlot.WEAPON)
    {
        active_weapon_slot = EquipmentSlot.WEAPON_2;
    }
    else
    {
        active_weapon_slot = EquipmentSlot.WEAPON;
    }
}
