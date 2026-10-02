function raid_bag_get_weight()
{
    var total_weight = 0;

    var keys =
        variable_struct_get_names(
            raid.bag
        );


    for (var i = 0; i < array_length(keys); i++)
    {
        var item_key =
            keys[i];


        // Skip invalid empty item
        if (item_key == "")
            continue;


        var item =
            item_get(
                item_key
            );


        // Skip invalid item keys
        if (is_undefined(item))
        {
            log_add(
                "Invalid bag item: "
                + string(item_key)
            );

            continue;
        }


        var quantity =
            variable_struct_get(
                raid.bag,
                item_key
            );


        total_weight +=
            item.weight
            * quantity;
    }


    return total_weight;
}