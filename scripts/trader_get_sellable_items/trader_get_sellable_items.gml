function trader_get_sellable_items(_trader_key)
{
    var sellable_items = [];

    for (var i = 0; i < array_length(stash.items); i++)
    {
        var item_key =
            stash.items[i].item_key;

        var already_added = false;

        for (var j = 0; j < array_length(sellable_items); j++)
        {
            if (sellable_items[j] == item_key)
            {
                already_added = true;
                break;
            }
        }

        if (!already_added && trader_will_buy_item(_trader_key, item_key))
        {
            array_push(
                sellable_items,
                item_key
            );
        }
    }

    return sellable_items;
}

function trader_get_stash_quantity(_item_key)
{
    return stash_get_quantity(_item_key);
}
