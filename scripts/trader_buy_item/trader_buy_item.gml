function trader_buy_item(_trader_key, _stock_index, _quantity = 1)
{
    if (!trader_can_buy_item(_trader_key, _stock_index, _quantity)) return false;
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

    var _unique_stock = variable_struct_exists(stock_entry, "item_instance");
    if (_unique_stock && _quantity != 1) return false;

    var item =
        item_get(stock_entry.item_key);

    if (is_undefined(item))
    {
        return false;
    }


    // ==============================
    // PRICE
    // ==============================

    var unit_price = trader_get_buy_price(stock_entry.price);
    if (_quantity > floor(2147483647 / unit_price)) return false;
    var price = unit_price * _quantity;


    // ==============================
    // COMPLETE PURCHASE
    // ==============================

    if (!spend_cash(price))
    {
        return false;
    }

    var _added = false;
    if (_unique_stock)
    {
        var _stock_item = stock_entry.item_instance;
        _stock_item.rotation = 0;
        _added = stash_place_existing_item(_stock_item, stash);
        if (!_added)
        {
            _stock_item.rotation = 90;
            _added = stash_place_existing_item(_stock_item, stash);
        }
    }
    else _added = stash_add(stock_entry.item_key, _quantity);

    if (!_added)
    {
        stash_add("cash", price);
        return false;
    }

    if (_unique_stock)
    {
        array_delete(trader.stock, _stock_index, 1);
        trader_stock_layout = trader_stock_grid_build(_trader_key, 11);
        trader_selected_stock_index = -1;
        trader_hovered_stock_index = -1;
        save_mark_dirty();
        save_game();
    }


    // ==============================
    // LOG
    // ==============================

    player_skill_add_xp("scavenging", skill_xp_awards.scavenging_trade * _quantity);

    return true;
}

function trader_can_buy_item(_trader_key, _stock_index, _quantity)
{
    if (!is_real(_quantity) || _quantity != floor(_quantity) || _quantity <= 0) return false;
    var _trader = trader_get(_trader_key);
    if (is_undefined(_trader) || _stock_index < 0 || _stock_index >= array_length(_trader.stock)) return false;
    var _stock_entry = _trader.stock[_stock_index];
    if (variable_struct_exists(_stock_entry, "item_instance") && _quantity != 1) return false;
    if (is_undefined(item_get(_stock_entry.item_key))) return false;
    var _unit_price = trader_get_buy_price(_stock_entry.price);
    if (_quantity > floor(2147483647 / _unit_price)) return false;
    return get_cash() >= _unit_price * _quantity && stash_can_add(_stock_entry.item_key, _quantity);
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
