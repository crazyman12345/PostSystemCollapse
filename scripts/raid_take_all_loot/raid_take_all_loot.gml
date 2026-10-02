function raid_take_all_loot()
{
    var i = 0;

    while (i < array_length(raid.last_loot))
    {
        var entry =
            raid.last_loot[i];

        var took_something = false;
		
            raid_bag_add(
                entry.item_key,
                1
            );

            entry.quantity -= 1;

            took_something = true;
     

        if (entry.quantity <= 0)
        {
            array_delete(
                raid.last_loot,
                i,
                1
            );
        }
        else
        {
            raid.last_loot[i] =
                entry;

            i++;
        }

        if (!took_something && entry.quantity > 0)
        {
            i++;
        }
    }
}