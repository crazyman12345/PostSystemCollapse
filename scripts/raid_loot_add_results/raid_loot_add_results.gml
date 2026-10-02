function raid_add_loot_results(_loot_results)
{
    for (var i = 0; i < array_length(_loot_results); i++)
    {
        var loot_entry = _loot_results[i];

        // Add EXACT rolled quantity to bag
        raid_bag_add(
            loot_entry.item_key,
            loot_entry.quantity
        );

        var item =
            item_get(loot_entry.item_key);

        // Read back what the bag now actually contains
        var bag_quantity =
            raid_bag_get_quantity(
                loot_entry.item_key
            );

        log_add(
            "Recovered "
            + string(loot_entry.quantity)
            + "x "
            + item.name
            + ". Bag total: "
            + string(bag_quantity)
        );
    }
}