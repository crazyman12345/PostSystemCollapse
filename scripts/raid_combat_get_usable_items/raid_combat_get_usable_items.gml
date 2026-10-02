function raid_combat_get_usable_items()
{
    var usable_items = [];

    var bag_items =
        raid_bag_get_visible_items();


    for (
        var i = 0;
        i < array_length(bag_items);
        i++
    )
    {
        var item_key =
            bag_items[i];

        var item =
            item_get(item_key);


        if (is_undefined(item))
        {
            continue;
        }


        if (
            variable_struct_exists(
                item,
                "combat_usable"
            )
        )
        {
            if (item.combat_usable == true)
            {
                array_push(
                    usable_items,
                    item_key
                );
            }
        }
    }
    return usable_items;
}