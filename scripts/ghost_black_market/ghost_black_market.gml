function ghost_black_market_initialize()
{
    ghost_black_market_config = {
        stock_min: 18,
        stock_max: 24,
        raids_per_refresh: 3,
        current_tier_chance: 85,
        lower_tier_chance: 10,
        higher_tier_chance: 5,
        price_multiplier_min: 2.0,
        price_multiplier_max: 4.0,
        modifier_quality_weight: 0.5,
        rarity_price_bonus: [0, 0.35, 0.7, 1.15, 2.0]
    };
    global.weapon_rarity_chances.ghost_black_market = [
        { rarity: "common", chance: 15 },
        { rarity: "rare", chance: 35 },
        { rarity: "very_rare", chance: 25 },
        { rarity: "epic", chance: 17 },
        { rarity: "legendary", chance: 8 }
    ];
    ghost_black_market_raids_completed = 0;
    ghost_black_market_next_instance_id = 1;
}

function ghost_black_market_reset()
{
    ghost_black_market_raids_completed = 0;
    ghost_black_market_next_instance_id = 1;
    ghost_black_market_generate_stock();
}

function ghost_black_market_generate_stock()
{
    var _trader = trader_get("ghost");
    if (is_undefined(_trader)) return false;

    var _weapon_keys = [];
    var _item_keys = variable_struct_get_names(global.items);
    for (var _i = 0; _i < array_length(_item_keys); _i++)
    {
        var _definition = item_get(_item_keys[_i]);
        if (!is_undefined(_definition) && _definition.category == ItemCategory.WEAPON
        && variable_struct_exists(_definition, "tier")) array_push(_weapon_keys, _item_keys[_i]);
    }
    if (array_length(_weapon_keys) <= 0) return false;

    _trader.stock = [];
    var _current_tier = clamp(floor(global.progress.danger_level), 1, 10);
    var _stock_count = irandom_range(ghost_black_market_config.stock_min, ghost_black_market_config.stock_max);
    repeat (_stock_count)
    {
        var _tier_total = ghost_black_market_config.current_tier_chance
            + ghost_black_market_config.lower_tier_chance
            + ghost_black_market_config.higher_tier_chance;
        var _tier_roll = random(_tier_total);
        var _target_tier = _current_tier;
        if (_tier_roll >= ghost_black_market_config.current_tier_chance)
        {
            _target_tier += _tier_roll < ghost_black_market_config.current_tier_chance
                + ghost_black_market_config.lower_tier_chance ? -1 : 1;
        }
        _target_tier = clamp(_target_tier, 1, 10);

        var _tier_pool = [];
        for (var _i = 0; _i < array_length(_weapon_keys); _i++)
        {
            var _definition = item_get(_weapon_keys[_i]);
            if (_definition.tier == _target_tier) array_push(_tier_pool, _weapon_keys[_i]);
        }
        if (array_length(_tier_pool) == 0)
        {
            var _fallback_tier = 0;
            for (var _i = 0; _i < array_length(_weapon_keys); _i++)
            {
                var _definition = item_get(_weapon_keys[_i]);
                if (_definition.tier > _current_tier || _definition.tier < _fallback_tier) continue;
                if (_definition.tier > _fallback_tier)
                {
                    _fallback_tier = _definition.tier;
                    _tier_pool = [];
                }
                array_push(_tier_pool, _weapon_keys[_i]);
            }
        }

        var _item_key = _tier_pool[irandom(array_length(_tier_pool) - 1)];
        var _item = {
            item_key: _item_key,
            quantity: 1,
            x: 0,
            y: 0,
            rotation: 0,
            tier: item_get(_item_key).tier,
            instance_id: "ghost_" + string(ghost_black_market_next_instance_id)
        };
        ghost_black_market_next_instance_id++;
        weapon_instance_initialize(_item, true, "ghost_black_market");
        array_push(_trader.stock, {
            item_key: _item_key,
            item_instance: _item,
            price: ghost_black_market_get_price(_item)
        });
    }
    return true;
}

function ghost_black_market_get_price(_item)
{
    var _definition = item_get(_item.item_key);
    var _baseline = _definition.base_value;
    var _trader_keys = ["mara", "sawbones", "iron", "bastion"];
    for (var _trader_index = 0; _trader_index < array_length(_trader_keys); _trader_index++)
    {
        var _trader = trader_get(_trader_keys[_trader_index]);
        if (is_undefined(_trader)) continue;
        for (var _stock_index = 0; _stock_index < array_length(_trader.stock); _stock_index++)
        {
            if (_trader.stock[_stock_index].item_key == _item.item_key)
                _baseline = max(_baseline, _trader.stock[_stock_index].price);
        }
    }

    var _rarity_keys = ["common", "rare", "very_rare", "epic", "legendary"];
    var _rarity_index = 0;
    for (var _i = 0; _i < array_length(_rarity_keys); _i++)
        if (_rarity_keys[_i] == _item.rarity) _rarity_index = _i;
    var _base_power = weapon_calculate_gear_score(_definition);
    var _effective_power = weapon_calculate_gear_score(weapon_get_effective_stats(_item));
    var _quality = _base_power > 0 ? max(0, _effective_power / _base_power - 1) : 0;
    var _multiplier = ghost_black_market_config.price_multiplier_min
        + ghost_black_market_config.rarity_price_bonus[_rarity_index]
        + _quality * ghost_black_market_config.modifier_quality_weight;
    _multiplier = clamp(_multiplier, ghost_black_market_config.price_multiplier_min,
        ghost_black_market_config.price_multiplier_max);
    return max(1, round(_baseline * _multiplier));
}

function ghost_black_market_complete_raid()
{
    ghost_black_market_raids_completed++;
    if (ghost_black_market_raids_completed >= ghost_black_market_config.raids_per_refresh)
    {
        ghost_black_market_raids_completed = 0;
        ghost_black_market_generate_stock();
    }
    save_mark_dirty();
}

function ghost_black_market_save_data()
{
    var _saved_stock = [];
    var _trader = trader_get("ghost");
    if (!is_undefined(_trader))
    {
        for (var _i = 0; _i < array_length(_trader.stock); _i++)
        {
            var _entry = _trader.stock[_i];
            if (!variable_struct_exists(_entry, "item_instance")) continue;
            array_push(_saved_stock, { item: save_item_to_data(_entry.item_instance), price: _entry.price });
        }
    }
    return {
        stock: _saved_stock,
        raids_completed: ghost_black_market_raids_completed,
        next_instance_id: ghost_black_market_next_instance_id
    };
}

function ghost_black_market_load_data(_data)
{
    var _saved_stock = save_value(_data, "stock", undefined);
    if (!is_array(_saved_stock))
    {
        ghost_black_market_reset();
        return;
    }

    var _stock = [];
    for (var _i = 0; _i < array_length(_saved_stock); _i++)
    {
        var _saved_entry = _saved_stock[_i];
        if (!is_struct(_saved_entry)) continue;
        var _item = save_item_from_data(save_value(_saved_entry, "item", {}));
        var _price = floor(save_number(_saved_entry, "price", 0));
        if (is_undefined(_item) || item_get(_item.item_key).category != ItemCategory.WEAPON || _price <= 0) continue;
        array_push(_stock, { item_key: _item.item_key, item_instance: _item, price: _price });
    }

    var _trader = trader_get("ghost");
    if (!is_undefined(_trader)) _trader.stock = _stock;
    ghost_black_market_raids_completed = clamp(floor(save_number(_data, "raids_completed", 0)), 0,
        ghost_black_market_config.raids_per_refresh - 1);
    ghost_black_market_next_instance_id = max(1, floor(save_number(_data, "next_instance_id", 1)));
}
