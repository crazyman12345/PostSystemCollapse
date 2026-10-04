function raid_get_weapon_in_slot(_slot)
{
    if (
        _slot != EquipmentSlot.WEAPON
        && _slot != EquipmentSlot.WEAPON_2
    )
    {
        return undefined;
    }

    var _item_key = equipment_get_slot_item(raid.crew_index, _slot);

    if (_item_key == "")
    {
        return undefined;
    }

    var _weapon = item_get(_item_key);

    if (
        !is_struct(_weapon)
        || _weapon.category != ItemCategory.WEAPON
    )
    {
        return undefined;
    }

    return _weapon;
}
