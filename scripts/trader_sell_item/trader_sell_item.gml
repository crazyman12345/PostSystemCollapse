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
        return false;
    }


    // ==============================
    // DOES PLAYER OWN IT?
    // ==============================

    if (!stash_has(_item_key, 1))
    {
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

    if (!stash_remove(_item_key, 1))
    {
        return false;
    }

    if (!stash_add("cash", price))
    {
        stash_add(_item_key, 1);
        return false;
    }


    player_skill_add_xp("scavenging", skill_xp_awards.scavenging_trade);

    return true;
}
