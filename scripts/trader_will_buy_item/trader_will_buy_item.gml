function trader_will_buy_item(_trader_key, _item_key)
{
    var trader = trader_get(_trader_key);
    var item = item_get(_item_key);

    if (is_undefined(trader) || is_undefined(item))
    {
        return false;
    }


    // Check each category this trader accepts
    for (
        var i = 0;
        i < array_length(trader.accepted_categories);
        i++
    )
    {
        if (item.category == trader.accepted_categories[i])
        {
            return true;
        }
    }


    // No matching category found
   return false;
}