function inventory_salvage_item(_item_key)
{
    var item =
        item_get(_item_key);


    if (is_undefined(item))
    {
        return false;
    }


    if (!item_can_salvage(_item_key))
    {
        log_add(
            item.name
            + " cannot be salvaged."
        );

        return false;
    }


    if (!inventory_remove(_item_key, 1))
    {
        return false;
    }


    for (
        var i = 0;
        i < array_length(item.salvage);
        i++
    )
    {
        var salvage_entry =
            item.salvage[i];


        inventory_add(
            salvage_entry.item_key,
            salvage_entry.quantity
        );
    }


    log_add(
        "Salvaged "
        + item.name
        + "."
    );


    return true;
}