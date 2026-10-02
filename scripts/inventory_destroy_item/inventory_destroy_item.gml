function inventory_destroy_item(_item_key)
{
    var item =
        item_get(_item_key);


    if (is_undefined(item))
    {
        return false;
    }


    if (!inventory_remove(_item_key, 1))
    {
        return false;
    }


    log_add(
        "Destroyed "
        + item.name
        + "."
    );


    return true;
}