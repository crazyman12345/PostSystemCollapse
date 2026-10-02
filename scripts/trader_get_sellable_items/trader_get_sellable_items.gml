function trader_get_sellable_items(_trader_key)
{
    var owned_items =
        inventory_get_visible_items();

    var sellable_items = [];

    for (var i = 0; i < array_length(owned_items); i++)
    {
        var item_key =
            owned_items[i];

        if (trader_will_buy_item(_trader_key, item_key))
        {
            array_push(
                sellable_items,
                item_key
            );
        }
    }

    return sellable_items;
}