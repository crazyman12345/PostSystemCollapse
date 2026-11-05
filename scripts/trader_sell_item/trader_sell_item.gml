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

    var _stored_items = stash_find_items(_item_key);
    if (array_length(_stored_items) == 0) return false;
    return trader_sell_stored_item(_trader_key, _stored_items[0]);
}
