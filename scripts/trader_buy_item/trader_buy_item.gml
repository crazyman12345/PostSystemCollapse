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
        trader_get_buy_price(stock_entry.price);


    // ==============================
    // CHECK PLAYER CASH
    // ==============================

    if (get_cash() < price)
    {
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
        return false;
    }


    // ==============================
    // LOG
    // ==============================

    player_skill_add_xp("scavenging", skill_xp_awards.scavenging_trade);

    return true;
}

function trader_get_buy_price(_base_price)
{
	var nodes = skill_node_get_nodes("scavenging");
	var charisma = skill_node_find(nodes, "charisma");
	var charisma_2 = skill_node_find(nodes, "charisma_2");
	var multiplier = 1;
	if (!is_undefined(charisma) && skill_node_is_unlocked("scavenging", charisma)) multiplier -= 0.05;
	if (!is_undefined(charisma_2) && skill_node_is_unlocked("scavenging", charisma_2)) multiplier -= 0.05;
	return max(1, floor(_base_price * multiplier));
}
