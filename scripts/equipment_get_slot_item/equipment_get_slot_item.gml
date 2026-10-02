function equipment_get_slot_item(_crew_index, _slot)
{
    var member =
        crew[_crew_index];

    switch (_slot)
    {
        case EquipmentSlot.WEAPON:
            return member.weapon;

        case EquipmentSlot.HEAD:
            return member.armor_head;

        case EquipmentSlot.CHEST:
            return member.armor_chest;

        case EquipmentSlot.BAG:
            return member.bag;
    }

    return "";
}