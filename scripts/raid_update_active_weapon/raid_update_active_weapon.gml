function raid_update_active_weapon()
{
    if (
        active_weapon_slot == EquipmentSlot.WEAPON
        || active_weapon_slot == EquipmentSlot.WEAPON_2
    )
    {
        var _weapon = raid_get_weapon_in_slot(active_weapon_slot);

        if (!is_undefined(_weapon))
        {
            return _weapon;
        }
    }

    raid_weapon_loaded_slot = -1;
    raid_weapon_loaded_key = "";
    raid_weapon_mag = 0;
    raid_weapon_mags = [0, 0];
    raid_weapon_slot_keys = ["", ""];
    raid_reload_active = false;
    raid_reload_timer = 0;
    raid_burst_remaining = 0;
    return undefined;
}
