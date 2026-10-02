function raid_secure_bag()
{//transfers loot from raid bag to main inventory
    var bag_keys =
        variable_struct_get_names(raid.bag);

    for (var i = 0; i < array_length(bag_keys); i++)
    {
        var item_key =
            bag_keys[i];

        var quantity =
            raid_bag_get_quantity(item_key);

        if (quantity > 0)
        {
            inventory_add(
                item_key,
                quantity
            );

            var item =
                item_get(item_key);

            log_add(
                "Secured "
                + string(quantity)
                + "x "
                + item.name
                + "."
            );
        }
    }

    // Only clear AFTER everything has transferred
    raid.bag = {};
}