function player_health_heal_global(_amount)
{
    var _before = raid_player_hp;
    raid_player_hp = min(raid_player_max_hp, raid_player_hp + max(0, _amount));
    player_health_sync_crew();
    if (raid_player_hp > _before) save_mark_dirty();
    return raid_player_hp - _before;
}

function player_health_heal_limb(_limb_index, _amount)
{
    if (_limb_index < 0 || _limb_index >= array_length(health_limbs)) return 0;
    var _limb = health_limbs[_limb_index];
    if (_limb.injury == LimbInjuryState.BLACKED_OUT) return 0;
    var _before = _limb.hp;
    _limb.hp = min(_limb.max_hp, _limb.hp + max(0, _amount));
    player_health_update_limb_state(_limb);
    if (_limb.hp > _before) save_mark_dirty();
    return _limb.hp - _before;
}

function player_health_stop_light_bleed(_limb_index = -1)
{
    return player_health_stop_bleed_type(LimbBleedState.LIGHT, _limb_index);
}

function player_health_stop_heavy_bleed(_limb_index = -1)
{
    return player_health_stop_bleed_type(LimbBleedState.HEAVY, _limb_index);
}

function player_health_stop_bleed_type(_bleed_type, _limb_index)
{
    var _removed = false;
    for (var i = 0; i < array_length(health_limbs); i++)
    {
        if (_limb_index != -1 && _limb_index != i) continue;
        var _limb = health_limbs[i];
        var _remaining_bleeds = [];
        for (var j = 0; j < array_length(_limb.bleeds); j++)
        {
            if (_limb.bleeds[j].type == _bleed_type) _removed = true;
            else array_push(_remaining_bleeds, _limb.bleeds[j]);
        }
        _limb.bleeds = _remaining_bleeds;
        player_health_sync_limb_bleed_state(_limb);
        health_limbs[i] = _limb;
    }
    if (_removed) save_mark_dirty();
    return _removed;
}

function player_health_clear_bleeds()
{
    for (var i = 0; i < array_length(health_limbs); i++)
    {
        health_limbs[i].bleeds = [];
        health_limbs[i].bleed = LimbBleedState.NONE;
    }
}

function player_health_repair_fracture(_limb_index)
{
    if (_limb_index < 0 || _limb_index >= array_length(health_limbs) || !health_limbs[_limb_index].fractured) return false;
    health_limbs[_limb_index].fractured = false;
    save_mark_dirty();
    return true;
}

function player_health_repair_blacked_limb(_limb_index)
{
    if (_limb_index < 0 || _limb_index >= array_length(health_limbs)
    || health_limbs[_limb_index].injury != LimbInjuryState.BLACKED_OUT) return false;
    health_limbs[_limb_index].hp = min(health_limbs[_limb_index].max_hp, health_config.blacked_repair_hp);
    player_health_update_limb_state(health_limbs[_limb_index]);
    save_mark_dirty();
    return true;
}

function player_health_recover_blacked_limbs()
{
    for (var i = 0; i < array_length(health_limbs); i++)
    {
        if (health_limbs[i].injury != LimbInjuryState.BLACKED_OUT) continue;
        health_limbs[i].hp = min(health_limbs[i].max_hp, health_config.blacked_repair_hp);
        player_health_update_limb_state(health_limbs[i]);
    }
}

function player_health_use_painkillers(_duration_seconds = -1)
{
    if (_duration_seconds < 0) _duration_seconds = health_config.painkiller_duration_seconds;
    health_painkiller_remaining = max(health_painkiller_remaining, _duration_seconds);
    save_mark_dirty();
}

function player_health_recover_after_death()
{
    raid_player_hp = max(health_config.death_recovery_hp, raid_player_hp);
    player_health_prepare_death_result();
    player_health_recover_blacked_limbs();
    player_health_sync_crew();
    save_mark_dirty();
}

function player_health_prepare_death_result()
{
    for (var i = 0; i < array_length(health_limbs); i++)
    {
        if (health_limbs[i].injury == LimbInjuryState.BLACKED_OUT) continue;
        health_limbs[i].hp = min(health_limbs[i].max_hp, health_config.death_recovery_hp);
        player_health_update_limb_state(health_limbs[i]);
    }
    player_health_sync_crew();
    save_mark_dirty();
}

function player_health_treatment_is_active()
{
    return variable_struct_exists(raid, "treatment") && raid.treatment.active;
}

function player_health_treatment_get_durability(_item, _definition)
{
    if (!variable_struct_exists(_item, "durability")) _item.durability = _definition.medical_capacity;
    return clamp(_item.durability, 0, _definition.medical_capacity);
}

function player_health_treatment_find_source(_item)
{
    var _containers = [stash.backpack, stash.pockets, stash.secure_container, stash];
    if (is_struct(raid.active_loot_container)) array_push(_containers, raid.active_loot_container.storage);
    for (var i = 0; i < array_length(_containers); i++)
    {
        var _container = _containers[i];
        for (var j = 0; j < array_length(_container.items); j++)
        {
            if (_container.items[j] == _item) return _container;
        }
    }
    return undefined;
}

function player_health_treatment_source_contains(_source, _item)
{
    if (!is_struct(_source)) return false;
    for (var i = 0; i < array_length(_source.items); i++)
    {
        if (_source.items[i] == _item) return true;
    }
    return false;
}

function player_health_treatment_target_is_valid(_effect, _target_type, _limb_index)
{
    if (_effect == "painkillers")
    {
        if (health_painkiller_remaining > 0) return false;
        for (var i = 0; i < array_length(health_limbs); i++)
        {
            if (health_limbs[i].injury != LimbInjuryState.HEALTHY || health_limbs[i].fractured) return true;
        }
        return false;
    }

    if (_target_type == "global") return _effect == "heal" && raid_player_hp < raid_player_max_hp;
    if (_target_type != "limb" || _limb_index < 0 || _limb_index >= array_length(health_limbs)) return false;
    var _limb = health_limbs[_limb_index];
    switch (_effect)
    {
        case "light_bleed": return player_health_limb_has_bleed(_limb, LimbBleedState.LIGHT);
        case "heavy_bleed": return player_health_limb_has_bleed(_limb, LimbBleedState.HEAVY);
        case "fracture": return _limb.fractured;
        case "heal": return _limb.injury != LimbInjuryState.BLACKED_OUT && _limb.hp < _limb.max_hp;
        case "surgery": return _limb.injury == LimbInjuryState.BLACKED_OUT;
    }
    return false;
}

function player_health_treatment_get_auto_target(_definition)
{
    var _effect = _definition.treatment_effect;
    if (_effect == "painkillers")
        return player_health_treatment_target_is_valid(_effect, "none", -1)
            ? { type: "none", limb: -1 }
            : undefined;

    if (_effect == "heal" && raid_player_hp < raid_player_max_hp) return { type: "global", limb: -1 };

    var _best_limb = -1;
    var _best_percent = 2;
    for (var i = 0; i < array_length(health_limbs); i++)
    {
        if (!player_health_treatment_target_is_valid(_effect, "limb", i)) continue;
        if (_effect != "heal") return { type: "limb", limb: i };
        var _percent = health_limbs[i].hp / max(1, health_limbs[i].max_hp);
        if (_percent < _best_percent)
        {
            _best_percent = _percent;
            _best_limb = i;
        }
    }
    return _best_limb >= 0 ? { type: "limb", limb: _best_limb } : undefined;
}

function player_health_treatment_start(_item, _target_type, _limb_index = -1, _hotbar_slot = -1, _instant = false)
{
    if ((!_instant && raid.state != RaidState.COMBAT) || player_health_treatment_is_active() || is_undefined(_item)) return false;
    var _definition = item_get(_item.item_key);
    if (is_undefined(_definition) || !variable_struct_exists(_definition, "treatment_effect")) return false;
    var _source = player_health_treatment_find_source(_item);
    if (is_undefined(_source) || player_health_treatment_get_durability(_item, _definition) <= 0) return false;
    if (!player_health_treatment_target_is_valid(_definition.treatment_effect, _target_type, _limb_index)) return false;

    var _amount = 1;
    var _duration = _definition.treatment_duration;
    if (_definition.treatment_effect == "heal")
    {
        var _missing = _target_type == "global"
            ? raid_player_max_hp - raid_player_hp
            : health_limbs[_limb_index].max_hp - health_limbs[_limb_index].hp;
        _amount = min(10, _missing, player_health_treatment_get_durability(_item, _definition));
        if (_amount <= 0) return false;
        _duration *= _amount / 10;
    }

    raid.treatment.active = true;
    raid.treatment.item = _item;
    raid.treatment.source = _source;
    raid.treatment.item_key = _item.item_key;
    raid.treatment.target_type = _target_type;
    raid.treatment.limb = _limb_index;
    raid.treatment.duration = _duration;
    raid.treatment.remaining = _duration;
    raid.treatment.amount = _amount;
    raid.treatment.hotbar_slot = _hotbar_slot;
    raid.medical_selected_item = undefined;

    if (_instant) return player_health_treatment_apply();

    raid_player_dash_active = false;
    raid_player_dash_timer = 0;
    raid_player_dash_xp_pending = false;
    raid_reload_active = false;
    raid_reload_timer = 0;
    raid_burst_remaining = 0;
    raid_knife_attack_timer = 0;
    raid_knife_trail = [];
    raid_muzzle_flash_light = undefined;
    return true;
}

function player_health_treatment_start_held(_item, _source, _target_type, _limb_index = -1, _instant = false)
{
    if (is_undefined(_item) || !is_struct(_source)) return false;
    var _definition = item_get(_item.item_key);
    if (is_undefined(_definition) || !variable_struct_exists(_definition, "treatment_effect")) return false;
    if (player_health_treatment_get_durability(_item, _definition) <= 0
    || !player_health_treatment_target_is_valid(_definition.treatment_effect, _target_type, _limb_index)) return false;

    array_push(_source.items, _item);
    if (player_health_treatment_start(_item, _target_type, _limb_index, -1, _instant)) return true;
    stash_remove_item(_item, _source);
    return false;
}

function player_health_treatment_cancel()
{
    if (!player_health_treatment_is_active()) return false;
    raid.treatment.active = false;
    raid.treatment.item = undefined;
    raid.treatment.source = undefined;
    raid.treatment.item_key = "";
    raid.treatment.target_type = "";
    raid.treatment.limb = -1;
    raid.treatment.duration = 0;
    raid.treatment.remaining = 0;
    raid.treatment.amount = 0;
    raid.treatment.hotbar_slot = -1;
    return true;
}

function player_health_treatment_apply()
{
    var _treatment = raid.treatment;
    var _item = _treatment.item;
    var _definition = item_get(_treatment.item_key);
    if (is_undefined(_item) || is_undefined(_definition)
    || !player_health_treatment_source_contains(_treatment.source, _item)
    || _item.item_key != _treatment.item_key
    || !player_health_treatment_target_is_valid(_definition.treatment_effect, _treatment.target_type, _treatment.limb))
    {
        player_health_treatment_cancel();
        return false;
    }

    var _applied = false;
    var _cost = 1;
    switch (_definition.treatment_effect)
    {
        case "light_bleed": _applied = player_health_stop_light_bleed(_treatment.limb); break;
        case "heavy_bleed": _applied = player_health_stop_heavy_bleed(_treatment.limb); break;
        case "fracture": _applied = player_health_repair_fracture(_treatment.limb); break;
        case "painkillers":
            player_health_use_painkillers(60);
            _applied = true;
        break;
        case "surgery": _applied = player_health_repair_blacked_limb(_treatment.limb); break;
        case "heal":
            var _healed = _treatment.target_type == "global"
                ? player_health_heal_global(_treatment.amount)
                : player_health_heal_limb(_treatment.limb, _treatment.amount);
            _cost = _healed;
            _applied = _healed > 0;
            if (_applied) player_skill_add_xp("vitality", skill_xp_awards.vitality_heal);
        break;
    }

    if (!_applied)
    {
        player_health_treatment_cancel();
        return false;
    }

    _item.durability = max(0, player_health_treatment_get_durability(_item, _definition) - _cost);
    if (_item.durability <= 0)
    {
        if (_item.quantity > 1)
        {
            _item.quantity--;
            _item.durability = _definition.medical_capacity;
        }
        else
        {
            stash_remove_item(_item, _treatment.source);
            for (var i = 0; i < array_length(raid.hotbar); i++)
            {
                if (raid.hotbar[i] == _item) raid.hotbar[i] = undefined;
            }
        }
    }

    if (_treatment.hotbar_slot >= 0)
    {
        raid.hotbar_feedback_slot = _treatment.hotbar_slot;
        raid.hotbar_feedback_timer = 12;
        raid.hotbar_feedback_success = true;
    }
    save_mark_dirty();
    player_health_treatment_cancel();
    return true;
}

function player_health_treatment_update()
{
    if (!player_health_treatment_is_active()) return;
    if (raid.state != RaidState.COMBAT || keyboard_check_pressed(ord("C")))
    {
        player_health_treatment_cancel();
        return;
    }
    if (!player_health_treatment_source_contains(raid.treatment.source, raid.treatment.item))
    {
        player_health_treatment_cancel();
        return;
    }

    raid.treatment.remaining = max(0, raid.treatment.remaining - (frame_scale / 60));
    if (raid.treatment.remaining <= 0) player_health_treatment_apply();
}

function player_health_treatment_select_inventory_item(_mouse_x, _mouse_y)
{
    var _grids = raid_inventory_get_grids();
    for (var i = 0; i < array_length(_grids); i++)
    {
        var _grid = _grids[i];
        var _cell_size = variable_struct_exists(_grid, "cell_size") ? _grid.cell_size : 60;
        var _cell_stride = variable_struct_exists(_grid, "cell_stride") ? _grid.cell_stride : _cell_size;
        for (var j = 0; j < array_length(_grid.storage.items); j++)
        {
            var _item = _grid.storage.items[j];
            var _definition = item_get(_item.item_key);
            var _width = (_item.rotation == 90 ? _definition.grid_height : _definition.grid_width) * _cell_size;
            var _height = (_item.rotation == 90 ? _definition.grid_width : _definition.grid_height) * _cell_size;
            var _left = _grid.left + (_item.x * _cell_stride);
            var _top = _grid.top + (_item.y * _cell_stride);
            if (_mouse_x < _left || _mouse_x >= _left + _width || _mouse_y < _top || _mouse_y >= _top + _height) continue;
            if (!variable_struct_exists(_definition, "treatment_effect")) return false;
            raid.medical_selected_item = _item;
            if (_definition.treatment_effect == "painkillers")
                return player_health_treatment_start(_item, "none", -1, -1);
            return true;
        }
    }
    return false;
}

function player_health_treatment_get_manual_target(_mouse_x, _mouse_y, _equipment_left = 40, _grid_top = 150)
{
    var _global_left = _equipment_left + 155;
    var _global_top = _grid_top + 370;
    if (_mouse_x >= _global_left && _mouse_x < _global_left + 140
    && _mouse_y >= _global_top && _mouse_y < _global_top + 68)
        return { type: "global", limb: -1 };

    var _boxes = [
        { limb: PlayerLimb.HEAD, left: _equipment_left + 165, top: _grid_top + 8, width: 120 },
        { limb: PlayerLimb.CHEST, left: _equipment_left + 155, top: _grid_top + 145, width: 140 },
        { limb: PlayerLimb.RIGHT_ARM, left: _equipment_left + 2, top: _grid_top + 230, width: 142 },
        { limb: PlayerLimb.LEFT_ARM, left: _equipment_left + 306, top: _grid_top + 230, width: 142 },
        { limb: PlayerLimb.RIGHT_LEG, left: _equipment_left + 18, top: _grid_top + 515, width: 142 },
        { limb: PlayerLimb.LEFT_LEG, left: _equipment_left + 290, top: _grid_top + 515, width: 142 }
    ];
    for (var i = 0; i < array_length(_boxes); i++)
    {
        var _box = _boxes[i];
        if (_mouse_x >= _box.left && _mouse_x < _box.left + _box.width
        && _mouse_y >= _box.top && _mouse_y < _box.top + 68)
            return { type: "limb", limb: _box.limb };
    }
    return undefined;
}
