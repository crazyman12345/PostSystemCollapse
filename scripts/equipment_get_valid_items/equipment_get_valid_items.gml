function equipment_get_valid_items(_slot)
{
    var source_items;

    // During a raid, equipment must come from raid bag
    if (raid.state != RaidState.INACTIVE && raid.state != RaidState.RESULT)
    {
        source_items =
            raid_bag_get_visible_items();
    }
    else
    {
        source_items =
            stash_get_visible_items();
    }

    var valid_items = [];

    for (var i = 0; i < array_length(source_items); i++)
    {
        var item_key =
            source_items[i];

        var item =
            item_get(item_key);

        if (is_undefined(item))
        {
            continue;
        }

        var valid = false;

        switch (_slot)
        {
            case EquipmentSlot.WEAPON:
            case EquipmentSlot.WEAPON_2:
                valid =
                    item.category == ItemCategory.WEAPON;
                break;

            case EquipmentSlot.HEAD:
                valid =
                    item.category == ItemCategory.HEAD_ARMOR;
                break;

            case EquipmentSlot.CHEST:
                valid =
                    item.category == ItemCategory.BODY_ARMOR;
                break;

            case EquipmentSlot.BAG:
                valid =
                    item.category == ItemCategory.BAG;
                break;
        }

        if (valid)
        {
            array_push(
                valid_items,
                item_key
            );
        }
    }

    return valid_items;
}
