function trader_sell_stored_item(_trader_key, _stored_item, _storage = stash, _quantity = 1)
{
    if (is_undefined(_stored_item) || _storage != stash) return false;
    if (!trader_will_buy_item(_trader_key, _stored_item.item_key)) return false;

    var _found = false;
    for (var _i = 0; _i < array_length(_storage.items); _i++)
    {
        if (_storage.items[_i] == _stored_item)
        {
            _found = true;
            break;
        }
    }
    if (!_found || !is_real(_quantity) || _quantity != floor(_quantity)
    || _quantity <= 0 || _quantity > _stored_item.quantity) return false;

    var _unit_price = trader_get_sell_price(_stored_item.item_key);
    if (_unit_price <= 0 || _quantity > floor(2147483647 / _unit_price)) return false;
    var _price = _unit_price * _quantity;

    _stored_item.quantity -= _quantity;
    var _removed = _stored_item.quantity <= 0;
    if (_removed && !stash_remove_item(_stored_item, _storage))
    {
        _stored_item.quantity = _quantity;
        return false;
    }

    if (!stash_add("cash", _price))
    {
        _stored_item.quantity += _quantity;
        if (_removed) array_push(_storage.items, _stored_item);
        return false;
    }

    save_mark_dirty();
    player_skill_add_xp("scavenging", skill_xp_awards.scavenging_trade * _quantity);
    return true;
}
