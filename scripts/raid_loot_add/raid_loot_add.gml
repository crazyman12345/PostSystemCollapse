function raid_loot_add(_loot, _item_key, _quantity)
{
    for (var i = 0; i < array_length(_loot); i++)
    {
        if (_loot[i].item_key == _item_key)
        {
            _loot[i].quantity += _quantity;
            return _loot;
        }
    }

    array_push(
        _loot,
        {
            item_key: _item_key,
            quantity: _quantity
        }
    );

    return _loot;
}