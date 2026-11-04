function armor_modifier_registry_init()
{
    global.armor_rarities = {
        common:    { key: "common", name: "Common", modifier_count: 0, color: make_color_rgb(150, 150, 150) },
        rare:      { key: "rare", name: "Rare", modifier_count: 1, color: make_color_rgb(70, 130, 255) },
        very_rare: { key: "very_rare", name: "Very Rare", modifier_count: 2, color: make_color_rgb(45, 205, 190) },
        epic:      { key: "epic", name: "Epic", modifier_count: 3, color: make_color_rgb(180, 80, 235) },
        legendary: { key: "legendary", name: "Legendary", modifier_count: 4, color: make_color_rgb(245, 180, 45) }
    };
    global.armor_modifier_registry = {
        lightweight: {
            key: "lightweight", name: "Lightweight", description: "-10% weight",
            categories: [ItemCategory.BODY_ARMOR, ItemCategory.HEAD_ARMOR, ItemCategory.BAG],
            effects: [{ stat: "weight", mode: "multiply", value: 0.90, minimum: 0 }]
        },
        fine_craftsmanship: {
            key: "fine_craftsmanship", name: "Fine Craftsmanship", description: "+10% value",
            categories: [ItemCategory.BODY_ARMOR, ItemCategory.HEAD_ARMOR, ItemCategory.BAG],
            effects: [{ stat: "base_value", mode: "multiply", value: 1.10, round_result: true }]
        },
        reinforced: {
            key: "reinforced", name: "Reinforced", description: "+10% armor",
            categories: [ItemCategory.BODY_ARMOR, ItemCategory.HEAD_ARMOR],
            effects: [{ stat: "armor", mode: "multiply", value: 1.10, round_result: true }]
        },
        impact_lining: {
            key: "impact_lining", name: "Impact Lining", description: "+8% armor",
            categories: [ItemCategory.BODY_ARMOR, ItemCategory.HEAD_ARMOR],
            effects: [{ stat: "armor", mode: "multiply", value: 1.08, round_result: true }]
        },
        balanced_load: {
            key: "balanced_load", name: "Balanced Load", description: "+10% carrying capacity",
            categories: [ItemCategory.BAG],
            effects: [{ stat: "bag_capacity", mode: "multiply", value: 1.10 }]
        },
        weatherproof: {
            key: "weatherproof", name: "Weatherproof", description: "+5% carrying capacity",
            categories: [ItemCategory.BAG],
            effects: [{ stat: "bag_capacity", mode: "multiply", value: 1.05 }]
        }
    };
    global.armor_rarity_chances = {
        standard: [
            { rarity: "common", chance: 70 }, { rarity: "rare", chance: 20 },
            { rarity: "very_rare", chance: 7 }, { rarity: "epic", chance: 2.5 },
            { rarity: "legendary", chance: 0.5 }
        ]
    };
}

function armor_category_is_equipment(_category)
{
    return _category == ItemCategory.BODY_ARMOR || _category == ItemCategory.HEAD_ARMOR || _category == ItemCategory.BAG;
}

function armor_rarity_get(_rarity_key)
{
    if (!is_string(_rarity_key) || !variable_struct_exists(global.armor_rarities, _rarity_key))
        return global.armor_rarities.common;
    return variable_struct_get(global.armor_rarities, _rarity_key);
}

function armor_rarity_roll(_source = "default")
{
    var _source_key = string(_source);
    var _chances = variable_struct_exists(global.armor_rarity_chances, _source_key)
        ? variable_struct_get(global.armor_rarity_chances, _source_key)
        : global.armor_rarity_chances.standard;
    var _total = 0;
    for (var _i = 0; _i < array_length(_chances); _i++) _total += max(0, _chances[_i].chance);
    if (_total <= 0) return "common";
    var _roll = random(_total);
    for (var _i = 0; _i < array_length(_chances); _i++)
    {
        _roll -= max(0, _chances[_i].chance);
        if (_roll < 0 && variable_struct_exists(global.armor_rarities, _chances[_i].rarity)) return _chances[_i].rarity;
    }
    return "common";
}

function armor_modifier_available_keys(_category)
{
    var _result = [];
    var _keys = variable_struct_get_names(global.armor_modifier_registry);
    for (var _i = 0; _i < array_length(_keys); _i++)
    {
        var _modifier = variable_struct_get(global.armor_modifier_registry, _keys[_i]);
        if (array_contains(_modifier.categories, _category)) array_push(_result, _keys[_i]);
    }
    return _result;
}

function armor_modifier_roll_unique(_category, _count)
{
    var _available = armor_modifier_available_keys(_category);
    var _result = [];
    repeat (min(_count, array_length(_available)))
    {
        var _index = irandom(array_length(_available) - 1);
        array_push(_result, _available[_index]);
        array_delete(_available, _index, 1);
    }
    return _result;
}

function armor_modifier_roll_is_valid(_category, _rarity_key, _modifiers)
{
    if (!armor_category_is_equipment(_category) || !is_array(_modifiers)
    || !variable_struct_exists(global.armor_rarities, _rarity_key)) return false;
    if (array_length(_modifiers) != armor_rarity_get(_rarity_key).modifier_count) return false;
    var _available = armor_modifier_available_keys(_category);
    var _seen = [];
    for (var _i = 0; _i < array_length(_modifiers); _i++)
    {
        if (!array_contains(_available, _modifiers[_i]) || array_contains(_seen, _modifiers[_i])) return false;
        array_push(_seen, _modifiers[_i]);
    }
    return true;
}

function armor_instance_initialize(_item, _roll_rarity = false, _source = "default")
{
    if (!is_struct(_item)) return _item;
    var _definition = item_get(_item.item_key);
    if (is_undefined(_definition) || !armor_category_is_equipment(_definition.category)) return _item;
    if (variable_struct_exists(_item, "rarity") && variable_struct_exists(_item, "modifiers")
    && armor_modifier_roll_is_valid(_definition.category, _item.rarity, _item.modifiers)) return _item;
    _item.rarity = _roll_rarity ? armor_rarity_roll(_source) : "common";
    _item.modifiers = armor_modifier_roll_unique(_definition.category, armor_rarity_get(_item.rarity).modifier_count);
    if (variable_struct_exists(_item, "effective_armor_cache")) variable_struct_remove(_item, "effective_armor_cache");
    return _item;
}

function armor_instance_restore_roll(_item, _rarity_key, _modifiers)
{
    var _definition = item_get(_item.item_key);
    if (!is_undefined(_definition) && armor_modifier_roll_is_valid(_definition.category, _rarity_key, _modifiers))
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

function armor_get_effective_stats(_item)
{
    var _definition = is_string(_item) ? item_get(_item) : item_get(_item.item_key);
    if (is_undefined(_definition) || !armor_category_is_equipment(_definition.category)) return _definition;
    if (!is_string(_item))
    {
        armor_instance_initialize(_item, false);
        if (variable_struct_exists(_item, "effective_armor_cache")) return _item.effective_armor_cache;
    }
    var _effective = {};
    var _fields = variable_struct_get_names(_definition);
    for (var _i = 0; _i < array_length(_fields); _i++)
        variable_struct_set(_effective, _fields[_i], variable_struct_get(_definition, _fields[_i]));
    _effective.rarity = is_string(_item) ? "common" : _item.rarity;
    _effective.modifiers = is_string(_item) ? [] : array_concat(_item.modifiers, []);
    for (var _i = 0; _i < array_length(_effective.modifiers); _i++)
    {
        var _modifier = variable_struct_get(global.armor_modifier_registry, _effective.modifiers[_i]);
        for (var _j = 0; _j < array_length(_modifier.effects); _j++)
        {
            var _effect = _modifier.effects[_j];
            if (!variable_struct_exists(_effective, _effect.stat)) continue;
            var _value = variable_struct_get(_effective, _effect.stat);
            if (_effect.mode == "multiply") _value *= _effect.value; else _value += _effect.value;
            if (variable_struct_exists(_effect, "minimum")) _value = max(_effect.minimum, _value);
            if (variable_struct_exists(_effect, "round_result") && _effect.round_result) _value = round(_value);
            variable_struct_set(_effective, _effect.stat, _value);
        }
    }
    if (!is_string(_item)) _item.effective_armor_cache = _effective;
    return _effective;
}

function armor_rarity_color(_item)
{
    var _key = is_struct(_item) && variable_struct_exists(_item, "rarity") ? _item.rarity : "common";
    return armor_rarity_get(_key).color;
}
