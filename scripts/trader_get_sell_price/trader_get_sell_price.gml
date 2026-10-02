function trader_get_sell_price(_item_key)
{
    var item = item_get(_item_key);

    if (is_undefined(item))
    {
        return 0;
    }

    // Trader pays 60% of base item value for now
    var sell_multiplier = 0.60;

    var sell_price = floor(
        item.base_value * sell_multiplier
    );

    return max(1, sell_price);
}