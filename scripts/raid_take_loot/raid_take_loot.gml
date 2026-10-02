function raid_take_loot(_loot_index, _quantity)
{
    // ========================================================
    // VALIDATE INDEX
    // ========================================================

    if (_loot_index < 0)
    {
        return false;
    }

    if (_loot_index >= array_length(raid.last_loot))
    {
        return false;
    }


    // ========================================================
    // GET LOOT ENTRY
    // ========================================================

    var loot_entry =
        raid.last_loot[_loot_index];

    var item_key =
        loot_entry.item_key;

    var available_quantity =
        loot_entry.quantity;


    // ========================================================
    // VALIDATE QUANTITY
    // ========================================================

    if (_quantity <= 0)
    {
        return false;
    }


    var take_quantity =
        min(
            _quantity,
            available_quantity
        );


    // ========================================================
    // ADD TO RAID BAG
    // ========================================================

    if (!raid_bag_add(
        item_key,
        take_quantity
    ))
    {
        return false;
    }


    // ========================================================
    // REMOVE FROM GROUND LOOT
    // ========================================================

    loot_entry.quantity -=
        take_quantity;


    // ========================================================
    // REMOVE EMPTY LOOT ENTRY
    // ========================================================

    if (loot_entry.quantity <= 0)
    {
        array_delete(
            raid.last_loot,
            _loot_index,
            1
        );
    }
    else
    {
        raid.last_loot[_loot_index] =
            loot_entry;
    }


    // ========================================================
    // KEEP SELECTION VALID
    // ========================================================

    if (array_length(raid.last_loot) <= 0)
    {
        raid.loot_index = 0;
    }
    else
    {
        raid.loot_index =
            clamp(
                raid.loot_index,
                0,
                array_length(raid.last_loot) - 1
            );
    }


    return true;
}