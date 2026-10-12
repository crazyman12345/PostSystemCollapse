function trader_buy_item(_trader_key, _stock_index)
{
    // ==============================
    // GET TRADER
    // ==============================

    var trader = trader_get(_trader_key);

    if (is_undefined(trader))
    {
        return false;
    }


    // ==============================
    // CHECK STOCK INDEX
    // ==============================

    if (
        _stock_index < 0 ||
        _stock_index >= array_length(trader.stock)
    )
    {
        return false;
    }


    // ==============================
    // GET STOCK ITEM
    // ==============================

    var stock_entry =
        trader.stock[_stock_index];

    var item =
        item_get(stock_entry.item_key);

    if (is_undefined(item))
    {
        return false;
    }


    // ==============================
    // PRICE
    // ==============================

    var price =
        stock_entry.price;


    // ==============================
    // CHECK PLAYER CASH
    // ==============================

    if (get_cash() < price)
    {
        log_add(
            "Not enough cash to buy "
            + item.name
            + "."
        );

        return false;
    }


    // ==============================
    // COMPLETE PURCHASE
    // ==============================

    if (!spend_cash(price))
    {
        return false;
    }

    if (!stash_add(stock_entry.item_key, 1))
    {
        stash_add("cash", price);
        log_add("Not enough stash space to buy " + item.name + ".");
        return false;
    }


    // ==============================
    // LOG
    // ==============================

    player_skill_add_xp("scavenging", skill_xp_awards.scavenging_trade);

    log_add(
        "Purchased "
        + item.name
        + " for $"
        + string(price)
        + "."
    );

    return true;
}
