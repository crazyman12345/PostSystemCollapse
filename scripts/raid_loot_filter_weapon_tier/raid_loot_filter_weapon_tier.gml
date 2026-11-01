function raid_loot_filter_weapon_tier(_pool, _min_tier = 1, _max_tier = 10)
{
    var _filtered_pool = [];
    _min_tier = clamp(floor(_min_tier), 1, 10);
    _max_tier = clamp(floor(_max_tier), _min_tier, 10);

    for (var _i = 0; _i < array_length(_pool); _i++)
    {
        var _entry = _pool[_i];
        var _definition = item_get(_entry.item_key);
        if (is_undefined(_definition)) continue;
        if (_definition.category != ItemCategory.WEAPON
        || (_definition.tier >= _min_tier && _definition.tier <= _max_tier))
            array_push(_filtered_pool, _entry);
    }

    return _filtered_pool;
}
