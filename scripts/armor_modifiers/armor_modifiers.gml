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
            categories: [ItemCategory.BAG],
            effects: [{ stat: "weight", mode: "multiply", value: 0.90, minimum: 0 }]
        },
        fine_craftsmanship: {
            key: "fine_craftsmanship", name: "Fine Craftsmanship", description: "+10% value",
            categories: [ItemCategory.BODY_ARMOR, ItemCategory.HEAD_ARMOR, ItemCategory.BAG],
            effects: [{ stat: "base_value", mode: "multiply", value: 1.10, round_result: true }]
        },
        lightweight_construction: {
            key: "lightweight_construction", name: "Lightweight Construction", description: "Reduces chest armor weight by 10-20%",
            rolled_description: "Reduces chest armor weight by {value}%", roll_min: 10, roll_max: 20,
            categories: [ItemCategory.BODY_ARMOR], effects: [{ stat: "weight", mode: "multiply_reduction", rolled: true, percent: true }]
        },
        flexible_fit: {
            key: "flexible_fit", name: "Flexible Fit", description: "Increases movement speed by 3-6%",
            rolled_description: "Increases movement speed by {value}%", roll_min: 3, roll_max: 6,
            categories: [ItemCategory.BODY_ARMOR], effects: [{ stat: "movement_speed_multiplier", mode: "multiply_increase", rolled: true, percent: true }]
        },
        impact_padding: {
            key: "impact_padding", name: "Impact Padding", description: "Reduces knockback distance by 15-30%",
            rolled_description: "Reduces knockback distance by {value}%", roll_min: 15, roll_max: 30,
            categories: [ItemCategory.BODY_ARMOR], effects: [{ stat: "knockback_distance_multiplier", mode: "multiply_reduction", rolled: true, percent: true }]
        },
        endurance_lining: {
            key: "endurance_lining", name: "Endurance Lining", description: "Reduces stamina consumption by 5-10%",
            rolled_description: "Reduces stamina consumption by {value}%", roll_min: 5, roll_max: 10,
            categories: [ItemCategory.BODY_ARMOR], effects: [{ stat: "stamina_consumption_multiplier", mode: "multiply_reduction", rolled: true, percent: true }]
        },
        stabilized_plates: {
            key: "stabilized_plates", name: "Stabilized Plates", description: "Increases accuracy by 5-10%",
            rolled_description: "Increases accuracy by {value}%", roll_min: 5, roll_max: 10,
            categories: [ItemCategory.BODY_ARMOR], effects: [{ stat: "weapon_accuracy_multiplier", mode: "multiply_increase", rolled: true, percent: true }]
        },
        combat_harness: {
            key: "combat_harness", name: "Combat Harness", description: "Increases weapon handling by 3-6%",
            rolled_description: "Increases weapon handling by {value}%", roll_min: 3, roll_max: 6,
            categories: [ItemCategory.BODY_ARMOR], effects: [{ stat: "weapon_handling_multiplier", mode: "multiply_increase", rolled: true, percent: true }]
        },
        quick_recovery: {
            key: "quick_recovery", name: "Quick Recovery", description: "Reduces stamina regeneration delay by 10-20%",
            rolled_description: "Reduces stamina regeneration delay by {value}%", roll_min: 10, roll_max: 20,
            categories: [ItemCategory.BODY_ARMOR], effects: [{ stat: "stamina_regen_delay_multiplier", mode: "multiply_reduction", rolled: true, percent: true }]
        },
        emergency_pockets: {
            key: "emergency_pockets", name: "Emergency Pockets", description: "Increases consumable use speed by 5-10%",
            rolled_description: "Increases consumable use speed by {value}%", roll_min: 5, roll_max: 10,
            categories: [ItemCategory.BODY_ARMOR], effects: [{ stat: "consumable_use_speed_multiplier", mode: "multiply_increase", rolled: true, percent: true }]
        },
        lightweight_shell: {
            key: "lightweight_shell", name: "Lightweight Shell", description: "Reduces helmet weight by 10-20%",
            rolled_description: "Reduces helmet weight by {value}%", roll_min: 10, roll_max: 20,
            categories: [ItemCategory.HEAD_ARMOR], effects: [{ stat: "weight", mode: "multiply_reduction", rolled: true, percent: true }]
        },
        target_acquisition: {
            key: "target_acquisition", name: "Target Acquisition", description: "Increases weapon handling by 4-8%",
            rolled_description: "Increases weapon handling by {value}%", roll_min: 4, roll_max: 8,
            categories: [ItemCategory.HEAD_ARMOR], effects: [{ stat: "weapon_handling_multiplier", mode: "multiply_increase", rolled: true, percent: true }]
        },
        tactical_optics: {
            key: "tactical_optics", name: "Tactical Optics", description: "Increases weapon accuracy by 3-6 points",
            rolled_description: "Increases weapon accuracy by {value} points", roll_min: 3, roll_max: 6,
            categories: [ItemCategory.HEAD_ARMOR], effects: [{ stat: "weapon_accuracy_bonus", mode: "add", rolled: true }]
        },
        aim_boost: {
            key: "aim_boost", name: "Aim Boost", description: "Increases critical hit chance by 4-8%",
            categories: [ItemCategory.HEAD_ARMOR], effects: []
        },
        aim_damage: {
            key: "aim_damage", name: "Aim Damage", description: "Increases critical hit damage by 4-8%",
            categories: [ItemCategory.HEAD_ARMOR], effects: []
        },
        expanded_storage: {
            key: "expanded_storage", name: "Expanded Storage", description: "Adds 2-4 backpack inventory cells",
            rolled_description: "Adds {value} backpack inventory cells", roll_min: 2, roll_max: 4,
            categories: [ItemCategory.BAG], effects: [{ stat: "storage_bonus_cells", mode: "add", rolled: true }]
        },
        lightweight_frame: {
            key: "lightweight_frame", name: "Lightweight Frame", description: "Reduces backpack empty weight by 10-20%",
            rolled_description: "Reduces backpack empty weight by {value}%", roll_min: 10, roll_max: 20,
            categories: [ItemCategory.BAG], effects: [{ stat: "weight", mode: "multiply_reduction", rolled: true, percent: true }]
        },
        load_distribution: {
            key: "load_distribution", name: "Load Distribution", description: "Reduces effective weight of stored items by 5-10%",
            rolled_description: "Reduces effective weight of stored items by {value}%", roll_min: 5, roll_max: 10,
            categories: [ItemCategory.BAG], effects: [{ stat: "stored_weight_multiplier", mode: "multiply_reduction", rolled: true, percent: true }]
        },
        ergonomic_straps: {
            key: "ergonomic_straps", name: "Ergonomic Straps", description: "Reduces movement penalties from carried weight by 10-20%",
            rolled_description: "Reduces movement penalties from carried weight by {value}%", roll_min: 10, roll_max: 20,
            categories: [ItemCategory.BAG], effects: [{ stat: "encumbrance_penalty_reduction", mode: "add", rolled: true, percent: true }]
        },
        quick_access: {
            key: "quick_access", name: "Quick Access", description: "Reduces consumable use time by 5-10%",
            rolled_description: "Reduces consumable use time by {value}%", roll_min: 5, roll_max: 10,
            categories: [ItemCategory.BAG], effects: [{ stat: "consumable_use_time_multiplier", mode: "multiply_reduction", rolled: true, percent: true }]
        },
        scavengers_pack: {
            key: "scavengers_pack", name: "Scavenger's Pack", description: "Increases Scavenging XP gained by 5-15%",
            rolled_description: "Increases Scavenging XP gained by {value}%", roll_min: 5, roll_max: 15,
            categories: [ItemCategory.BAG], effects: [{ stat: "scavenging_xp_multiplier", mode: "multiply_increase", rolled: true, percent: true }]
        },
        insulated_storage: {
            key: "insulated_storage", name: "Insulated Storage", description: "Reduces hunger and hydration drain by 5-10%",
            rolled_description: "Reduces hunger and hydration drain by {value}%", roll_min: 5, roll_max: 10,
            categories: [ItemCategory.BAG], effects: [{ stat: "survival_drain_multiplier", mode: "multiply_reduction", rolled: true, percent: true }]
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
    var _available = armor_modifier_available_keys(_category);
    if (array_length(_modifiers) != min(armor_rarity_get(_rarity_key).modifier_count, array_length(_available))) return false;
    var _seen = [];
    for (var _i = 0; _i < array_length(_modifiers); _i++)
    {
        if (!array_contains(_available, _modifiers[_i]) || array_contains(_seen, _modifiers[_i])) return false;
        array_push(_seen, _modifiers[_i]);
    }
    return true;
}

function armor_modifier_values_copy(_values)
{
    var _copy = {};
    if (!is_struct(_values)) return _copy;
    var _keys = variable_struct_get_names(_values);
    for (var _i = 0; _i < array_length(_keys); _i++)
        variable_struct_set(_copy, _keys[_i], variable_struct_get(_values, _keys[_i]));
    return _copy;
}

function armor_modifier_values_ensure(_item)
{
    if (!variable_struct_exists(_item, "modifier_values") || !is_struct(_item.modifier_values)) _item.modifier_values = {};
    for (var _i = 0; _i < array_length(_item.modifiers); _i++)
    {
        var _key = _item.modifiers[_i];
        var _modifier = variable_struct_get(global.armor_modifier_registry, _key);
        if (!variable_struct_exists(_modifier, "roll_min") || !variable_struct_exists(_modifier, "roll_max")) continue;
        var _has_valid_value = false;
        if (variable_struct_exists(_item.modifier_values, _key))
        {
            var _saved_value = variable_struct_get(_item.modifier_values, _key);
            _has_valid_value = is_real(_saved_value) && _saved_value >= _modifier.roll_min && _saved_value <= _modifier.roll_max;
        }
        if (!_has_valid_value)
            variable_struct_set(_item.modifier_values, _key, irandom_range(_modifier.roll_min, _modifier.roll_max));
    }
}

function armor_modifier_get_value(_item, _modifier_key, _default = 0)
{
    if (!is_struct(_item) || !variable_struct_exists(_item, "modifier_values")
    || !is_struct(_item.modifier_values) || !variable_struct_exists(_item.modifier_values, _modifier_key)) return _default;
    return variable_struct_get(_item.modifier_values, _modifier_key);
}

function armor_modifier_get_description(_item, _modifier_key)
{
    var _modifier = variable_struct_get(global.armor_modifier_registry, _modifier_key);
    if (!variable_struct_exists(_modifier, "rolled_description")) return _modifier.description;
    return string_replace_all(_modifier.rolled_description, "{value}", string(armor_modifier_get_value(_item, _modifier_key, _modifier.roll_min)));
}

function armor_instance_initialize(_item, _roll_rarity = false, _source = "default")
{
    if (!is_struct(_item)) return _item;
    var _definition = item_get(_item.item_key);
    if (is_undefined(_definition) || !armor_category_is_equipment(_definition.category)) return _item;
    if (variable_struct_exists(_item, "rarity") && variable_struct_exists(_item, "modifiers")
    && armor_modifier_roll_is_valid(_definition.category, _item.rarity, _item.modifiers))
    {
        armor_modifier_values_ensure(_item);
        return _item;
    }
    _item.rarity = _roll_rarity ? armor_rarity_roll(_source) : "common";
    _item.modifiers = armor_modifier_roll_unique(_definition.category, armor_rarity_get(_item.rarity).modifier_count);
    _item.modifier_values = {};
    armor_modifier_values_ensure(_item);
    if (variable_struct_exists(_item, "effective_armor_cache")) variable_struct_remove(_item, "effective_armor_cache");
    return _item;
}

function armor_instance_restore_roll(_item, _rarity_key, _modifiers, _modifier_values = {})
{
    var _definition = item_get(_item.item_key);
    if (!is_undefined(_definition) && armor_modifier_roll_is_valid(_definition.category, _rarity_key, _modifiers))
    {
        _item.rarity = _rarity_key;
        _item.modifiers = array_concat(_modifiers, []);
        _item.modifier_values = armor_modifier_values_copy(_modifier_values);
        armor_modifier_values_ensure(_item);
    }
    else
    {
        _item.rarity = "common";
        _item.modifiers = [];
        _item.modifier_values = {};
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
    _effective.modifier_values = is_string(_item) ? {} : armor_modifier_values_copy(_item.modifier_values);
    if (_definition.category == ItemCategory.BODY_ARMOR)
    {
        _effective.movement_speed_multiplier = 1;
        _effective.knockback_distance_multiplier = 1;
        _effective.stamina_consumption_multiplier = 1;
        _effective.weapon_accuracy_multiplier = 1;
        _effective.weapon_handling_multiplier = 1;
        _effective.stamina_regen_delay_multiplier = 1;
        _effective.consumable_use_speed_multiplier = 1;
    }
    else if (_definition.category == ItemCategory.HEAD_ARMOR)
    {
        _effective.weapon_handling_multiplier = 1;
        _effective.weapon_accuracy_bonus = 0;
    }
    else if (_definition.category == ItemCategory.BAG)
    {
        _effective.storage_bonus_cells = 0;
        _effective.stored_weight_multiplier = 1;
        _effective.encumbrance_penalty_reduction = 0;
        _effective.consumable_use_time_multiplier = 1;
        _effective.scavenging_xp_multiplier = 1;
        _effective.survival_drain_multiplier = 1;
    }
    for (var _i = 0; _i < array_length(_effective.modifiers); _i++)
    {
        var _modifier = variable_struct_get(global.armor_modifier_registry, _effective.modifiers[_i]);
        for (var _j = 0; _j < array_length(_modifier.effects); _j++)
        {
            var _effect = _modifier.effects[_j];
            if (!variable_struct_exists(_effective, _effect.stat)) continue;
            var _value = variable_struct_get(_effective, _effect.stat);
            var _effect_value = variable_struct_exists(_effect, "rolled") && _effect.rolled
                ? armor_modifier_get_value(_item, _effective.modifiers[_i])
                : _effect.value;
            if (variable_struct_exists(_effect, "percent") && _effect.percent) _effect_value /= 100;
            if (_effect.mode == "multiply") _value *= _effect_value;
            else if (_effect.mode == "multiply_reduction") _value *= 1 - _effect_value;
            else if (_effect.mode == "multiply_increase") _value *= 1 + _effect_value;
            else _value += _effect_value;
            if (variable_struct_exists(_effect, "minimum")) _value = max(_effect.minimum, _value);
            if (variable_struct_exists(_effect, "round_result") && _effect.round_result) _value = round(_value);
            variable_struct_set(_effective, _effect.stat, _value);
        }
    }
    if (!is_string(_item)) _item.effective_armor_cache = _effective;
    return _effective;
}

function armor_get_equipped_bag_stats()
{
    if (!variable_global_exists("stash") || is_undefined(stash.equipped_bag_item)) return undefined;
    return armor_get_effective_stats(stash.equipped_bag_item);
}

function armor_get_equipped_chest_stats()
{
    if (!variable_global_exists("stash") || is_undefined(stash.equipped_armor_chest_item)) return undefined;
    return armor_get_effective_stats(stash.equipped_armor_chest_item);
}

function armor_get_equipped_head_stats()
{
    if (!variable_global_exists("stash") || is_undefined(stash.equipped_armor_head_item)) return undefined;
    return armor_get_effective_stats(stash.equipped_armor_head_item);
}

function armor_get_backpack_storage(_bag_item)
{
    if (is_undefined(_bag_item)) return { grid_width: 0, grid_height: 0, cell_limit: 0 };
    var _bag = armor_get_effective_stats(_bag_item);
    if (is_undefined(_bag)) return { grid_width: 0, grid_height: 0, cell_limit: 0 };
    var _cell_limit = (_bag.storage_width * _bag.storage_height) + max(0, _bag.storage_bonus_cells);
    return {
        grid_width: _bag.storage_width,
        grid_height: ceil(_cell_limit / max(1, _bag.storage_width)),
        cell_limit: _cell_limit
    };
}

function armor_sync_backpack_storage(_bag_item)
{
    var _storage = armor_get_backpack_storage(_bag_item);
    stash.backpack.grid_width = _storage.grid_width;
    stash.backpack.grid_height = _storage.grid_height;
    stash.backpack.cell_limit = _storage.cell_limit;
}

function armor_rarity_color(_item)
{
    var _key = is_struct(_item) && variable_struct_exists(_item, "rarity") ? _item.rarity : "common";
    return armor_rarity_get(_key).color;
}
