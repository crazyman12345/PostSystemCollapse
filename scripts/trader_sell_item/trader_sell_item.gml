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

    if (trader_get_stash_quantity(_item_key) < 1)
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

    for (var i = array_length(stash.items) - 1; i >= 0; i--)
    {
        var stash_item = stash.items[i];

        if (stash_item.item_key == _item_key)
        {
            stash_item.quantity--;

            if (stash_item.quantity <= 0)
            {
                stash_remove_item(stash_item);
            }

            break;
        }
    }

    variable_struct_set(inventory, _item_key, trader_get_stash_quantity(_item_key));

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
