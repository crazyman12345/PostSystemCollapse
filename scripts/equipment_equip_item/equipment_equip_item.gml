function equipment_equip_item(
    _crew_index,
    _slot,
    _new_item_key
)
{
    var member =
        crew[_crew_index];

    var old_item_key =
        equipment_get_slot_item(
            _crew_index,
            _slot
        );


    // ==============================
    // REMOVE NEW ITEM FROM SOURCE
    // ==============================

    if (_new_item_key != "")
    {
        var removed = false;

        if (raid.active)
        {
            removed =
                raid_bag_remove(
                    _new_item_key,
                    1
                );
        }
        else
        {
            removed =
                inventory_remove(
                    _new_item_key,
                    1
                );
        }

        if (!removed)
        {
            log_add(
                "Unable to equip item."
            );

            return false;
        }
    }


    // ==============================
    // RETURN OLD ITEM
    // ==============================

    if (old_item_key != "")
    {
        if (raid.active)
        {
            raid_bag_add(
                old_item_key,
                1
            );
        }
        else
        {
            inventory_add(
                old_item_key,
                1
            );
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
            break;

        case EquipmentSlot.HEAD:
            member.armor_head =
                _new_item_key;
            break;

        case EquipmentSlot.CHEST:
            member.armor_chest =
                _new_item_key;
            break;

        case EquipmentSlot.BAG:
            member.bag =
                _new_item_key;
            break;
    }


    crew[_crew_index] =
        member;

    return true;
}