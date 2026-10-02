function trader_sell_item(_trader_key, _item_key)
{
    var trader = trader_get(_trader_key);
    var item = item_get(_item_key);


    // ==============================
    // VALIDATE
    // ==============================

    if (is_undefined(trader) || is_undefined(item))
    {
        return false;
    }


    // ==============================
    // DOES TRADER BUY THIS?
    // ==============================

    if (!trader_will_buy_item(_trader_key, _item_key))
    {
        log_add(
            trader.name
            + " is not interested in "
            + item.name
            + "."
        );

        return false;
    }


    // ==============================
    // DOES PLAYER OWN IT?
    // ==============================

    if (!inventory_has(_item_key, 1))
    {
        log_add(
            "You don't have any "
            + item.name
            + " to sell."
        );

        return false;
    }


    // ==============================
    // GET PRICE
    // ==============================

    var price =
        trader_get_sell_price(
            _item_key
        );


    // ==============================
    // COMPLETE SALE
    // ==============================

    inventory_remove(
        _item_key,
        1
    );

   inventory_add("cash",price);


    log_add(
        "Sold "
        + item.name
        + " to "
        + trader.name
        + " for $"
        + string(price)
        + "."
    );

    return true;
}