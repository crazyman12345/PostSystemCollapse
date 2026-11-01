function raid_loot_add(_loot, _item_key, _quantity, _rarity_source = "")
{
    for (var i = 0; i < array_length(_loot); i++)
    {
        var _existing_source = variable_struct_exists(_loot[i], "rarity_source") ? _loot[i].rarity_source : "";
        if (_loot[i].item_key == _item_key && _existing_source == _rarity_source)
        {
            _loot[i].quantity += _quantity;
            return _loot;
        }
    }

    array_push(
        _loot,
        {
            item_key: _item_key,
            quantity: _quantity,
            rarity_source: _rarity_source
        }
    );

    return _loot;
}
