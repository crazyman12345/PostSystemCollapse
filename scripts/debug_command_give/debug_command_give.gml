function debug_command_give(_args)
{
    if (array_length(_args) < 3)
    {
        debug_log_add(
            "Usage: give <item_key> <quantity>"
        );

        return;
    }

    var item_key =
        string_lower(_args[1]);

    var quantity =
        real(_args[2]);

    var item =
        item_get(item_key);

    if (is_undefined(item))
    {
        debug_log_add(
            "Unknown item: " + item_key
        );

        return;
    }

    if (quantity <= 0)
    {
        debug_log_add(
            "Quantity must be greater than 0."
        );

        return;
    }

    inventory_add(
        item_key,
        quantity
    );

    debug_log_add(
        "Added "
        + string(quantity)
        + "x "
        + item.name
        + "."
    );
}