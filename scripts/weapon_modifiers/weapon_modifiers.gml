function weapon_modifier_registry_init()
{
    global.weapon_rarities = {
        common:    { key: "common", name: "Common", modifier_count: 0, color: make_color_rgb(150, 150, 150) },
        rare:      { key: "rare", name: "Rare", modifier_count: 1, color: make_color_rgb(70, 130, 255) },
        very_rare: { key: "very_rare", name: "Very Rare", modifier_count: 2, color: make_color_rgb(45, 205, 190) },
        epic:      { key: "epic", name: "Epic", modifier_count: 3, color: make_color_rgb(180, 80, 235) },
        legendary: { key: "legendary", name: "Legendary", modifier_count: 4, color: make_color_rgb(245, 180, 45) }
    };

    global.weapon_modifier_registry = {
        heavy_hitter: {
            key: "heavy_hitter", name: "Heavy Hitter", description: "+7.5% damage",
            effects: [{ stat: "damage_min", mode: "multiply", value: 1.075, round_result: true }, { stat: "damage_max", mode: "multiply", value: 1.075, round_result: true }]
        },
        rapid_action: {
            key: "rapid_action", name: "Rapid Action", description: "+7.5% fire rate",
            effects: [{ stat: "fire_rate", mode: "multiply", value: 1.075, maximum: 60 }]
        },
        precision_barrel: {
            key: "precision_barrel", name: "Precision Barrel", description: "+8 Accuracy",
            effects: [{ stat: "accuracy", mode: "add", value: 8, maximum: 100 }]
        },
        quickdraw: {
            key: "quickdraw", name: "Quickdraw", description: "+8 Handling",
            effects: [{ stat: "handling", mode: "add", value: 8, maximum: 100 }]
        },
        extended_magazine: {
            key: "extended_magazine", name: "Extended Magazine", description: "+15% magazine capacity",
            effects: [{ stat: "mag_size", mode: "multiply", value: 1.15, round_result: true, minimum: 1 }]
        },
        fast_reload: {
            key: "fast_reload", name: "Fast Reload", description: "-8% reload time",
            effects: [{ stat: "reload_time", mode: "multiply", value: 0.92, minimum: 1 }]
        },
        lightweight: {
            key: "lightweight", name: "Lightweight", description: "-10% weight",
            effects: [{ stat: "weight", mode: "multiply", value: 0.90, minimum: 0 }]
        },
        reinforced: {
            key: "reinforced", name: "Reinforced", description: "-15% durability wear (future)",
            effects: [{ stat: "durability_wear_multiplier", mode: "multiply", value: 0.85, minimum: 0 }]
        }
    };

    global.weapon_modifier_keys = [
        "heavy_hitter", "rapid_action", "precision_barrel", "quickdraw",
        "extended_magazine", "fast_reload", "lightweight", "reinforced"
    ];

    // Add or override a source with variable_struct_set(global.weapon_rarity_chances, source, chances).
    global.weapon_rarity_chances = {
        standard: [
            { rarity: "common", chance: 70 },
            { rarity: "rare", chance: 20 },
            { rarity: "very_rare", chance: 7 },
            { rarity: "epic", chance: 2.5 },
            { rarity: "legendary", chance: 0.5 }
        ]
    };
}

function weapon_rarity_get(_rarity_key)
{
    if (!is_string(_rarity_key) || !variable_struct_exists(global.weapon_rarities, _rarity_key))
        return global.weapon_rarities.common;
    return variable_struct_get(global.weapon_rarities, _rarity_key);
}

function weapon_rarity_roll(_source = "default")
{
    var _source_key = string(_source);
    var _chances = variable_struct_exists(global.weapon_rarity_chances, _source_key)
        ? variable_struct_get(global.weapon_rarity_chances, _source_key)
        : global.weapon_rarity_chances.standard;
    var _total = 0;
    for (var i = 0; i < array_length(_chances); i++) _total += max(0, _chances[i].chance);
    if (_total <= 0) return "common";
    var _roll = random(_total);
    for (var i = 0; i < array_length(_chances); i++)
    {
        _roll -= max(0, _chances[i].chance);
        if (_roll < 0 && variable_struct_exists(global.weapon_rarities, _chances[i].rarity)) return _chances[i].rarity;
    }
    return "common";
}

function weapon_modifier_roll_unique(_count)
{
    var _available = array_concat(global.weapon_modifier_keys, []);
    var _result = [];
    repeat (min(_count, array_length(_available)))
    {
        var _index = irandom(array_length(_available) - 1);
        array_push(_result, _available[_index]);
        array_delete(_available, _index, 1);
    }
    return _result;
}

function weapon_modifier_roll_is_valid(_rarity_key, _modifiers)
{
    if (!is_string(_rarity_key) || !variable_struct_exists(global.weapon_rarities, _rarity_key) || !is_array(_modifiers)) return false;
    if (array_length(_modifiers) != weapon_rarity_get(_rarity_key).modifier_count) return false;
    var _seen = [];
    for (var i = 0; i < array_length(_modifiers); i++)
    {
        var _key = _modifiers[i];
        if (!is_string(_key) || !variable_struct_exists(global.weapon_modifier_registry, _key) || array_contains(_seen, _key)) return false;
        array_push(_seen, _key);
    }
    return true;
}

function weapon_instance_initialize(_item, _roll_rarity = false, _source = "default")
{
    if (!is_struct(_item)) return _item;
    var _definition = item_get(_item.item_key);
    if (is_undefined(_definition) || _definition.category != ItemCategory.WEAPON) return _item;
    if (variable_struct_exists(_item, "rarity") && variable_struct_exists(_item, "modifiers")
    && weapon_modifier_roll_is_valid(_item.rarity, _item.modifiers)) return _item;

    _item.rarity = _roll_rarity ? weapon_rarity_roll(_source) : "common";
    _item.modifiers = weapon_modifier_roll_unique(weapon_rarity_get(_item.rarity).modifier_count);
    if (variable_struct_exists(_item, "effective_weapon_cache")) variable_struct_remove(_item, "effective_weapon_cache");
    return _item;
}

function weapon_instance_restore_roll(_item, _rarity_key, _modifiers)
{
    if (weapon_modifier_roll_is_valid(_rarity_key, _modifiers))
    {
        _item.rarity = _rarity_key;
        _item.modifiers = array_concat(_modifiers, []);
    }
    else
    {
        _item.rarity = "common";
        _item.modifiers = [];
    }
    return _item;
}

function weapon_get_effective_stats(_item)
{
    var _definition = is_string(_item) ? item_get(_item) : item_get(_item.item_key);
    if (is_undefined(_definition) || _definition.category != ItemCategory.WEAPON) return _definition;
    if (!is_string(_item))
    {
        weapon_instance_initialize(_item, false);
        if (variable_struct_exists(_item, "effective_weapon_cache")) return _item.effective_weapon_cache;
    }

    var _effective = {};
    var _fields = variable_struct_get_names(_definition);
    for (var i = 0; i < array_length(_fields); i++)
        variable_struct_set(_effective, _fields[i], variable_struct_get(_definition, _fields[i]));
    _effective.rarity = is_string(_item) ? "common" : _item.rarity;
    _effective.modifiers = is_string(_item) ? [] : array_concat(_item.modifiers, []);
    _effective.durability_wear_multiplier = 1;

    for (var i = 0; i < array_length(_effective.modifiers); i++)
    {
        var _modifier = variable_struct_get(global.weapon_modifier_registry, _effective.modifiers[i]);
        for (var j = 0; j < array_length(_modifier.effects); j++)
        {
            var _effect = _modifier.effects[j];
            var _value = variable_struct_exists(_effective, _effect.stat) ? variable_struct_get(_effective, _effect.stat) : 1;
            if (_effect.mode == "multiply") _value *= _effect.value; else _value += _effect.value;
            if (variable_struct_exists(_effect, "minimum")) _value = max(_effect.minimum, _value);
            if (variable_struct_exists(_effect, "maximum")) _value = min(_effect.maximum, _value);
            if (variable_struct_exists(_effect, "round_result") && _effect.round_result) _value = round(_value);
            variable_struct_set(_effective, _effect.stat, _value);
        }
    }

    if (!is_string(_item)) _item.effective_weapon_cache = _effective;
    return _effective;
}

function weapon_rarity_color(_item)
{
    var _key = is_struct(_item) && variable_struct_exists(_item, "rarity") ? _item.rarity : "common";
    return weapon_rarity_get(_key).color;
}
