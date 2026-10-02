function raid_loot_pick(_pool)
{
    var _total_weight = 0;

    for (var i = 0; i < array_length(_pool); i++)
        _total_weight += _pool[i].weight;

    var _roll = random(_total_weight);
    var _current = 0;

    for (var i = 0; i < array_length(_pool); i++)
    {
        _current += _pool[i].weight;

        if (_roll < _current)
            return _pool[i];
    }

    return _pool[array_length(_pool) - 1];
}