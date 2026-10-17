function save_apply_data(_data)
{
    var was_ready = save_ready;
    save_ready = false;
    save_reset_to_defaults();

    var inventory = _data.inventory;
    stash.items = [];
    save_apply_items(save_value(inventory, "stash", []), stash);

    var backpack_data = save_value(inventory, "backpack", {});
    stash.backpack.items = [];
    stash.backpack.grid_width = max(0, save_number(backpack_data, "grid_width", 0));
    stash.backpack.grid_height = max(0, save_number(backpack_data, "grid_height", 0));

    var secure_data = save_value(inventory, "secure_container", {});
    stash.secure_container.items = [];
    stash.secure_container.grid_width = max(1, save_number(secure_data, "grid_width", 2));
    stash.secure_container.grid_height = max(1, save_number(secure_data, "grid_height", 2));

    var equipment = save_value(inventory, "equipment", {});
    stash.equipped_weapon_item = save_item_from_data(save_value(equipment, "weapon_1", {}));
    stash.equipped_weapon_2_item = save_item_from_data(save_value(equipment, "weapon_2", {}));
    stash.equipped_armor_head_item = save_item_from_data(save_value(equipment, "head", {}));
    stash.equipped_armor_chest_item = save_item_from_data(save_value(equipment, "chest", {}));
    stash.equipped_bag_item = save_item_from_data(save_value(equipment, "backpack", {}));
    var secure_item = save_item_from_data(save_value(equipment, "secure_container", {}));
    if (!is_undefined(secure_item)) stash.equipped_secure_container_item = secure_item;

    var member = crew[0];
    member.weapon = save_item_key(stash.equipped_weapon_item);
    member.weapon_2 = save_item_key(stash.equipped_weapon_2_item);
    member.armor_head = save_item_key(stash.equipped_armor_head_item);
    member.armor_chest = save_item_key(stash.equipped_armor_chest_item);
    member.bag = save_item_key(stash.equipped_bag_item);
    member.secure_container = save_item_key(stash.equipped_secure_container_item);

    if (member.bag != "")
    {
        var bag_definition = item_get(member.bag);
        if (!is_undefined(bag_definition))
        {
            stash.backpack.grid_width = bag_definition.grid_width;
            stash.backpack.grid_height = bag_definition.grid_height;
            save_apply_items(save_value(backpack_data, "items", []), stash.backpack);
        }
    }
    save_apply_items(save_value(secure_data, "items", []), stash.secure_container);

    var player = save_value(_data, "player", {});
    var crew_data = save_value(player, "crew", {});
    member.hp = max(0, save_number(crew_data, "hp", member.hp));
    member.max_hp = max(1, save_number(crew_data, "max_hp", member.max_hp));
    var saved_status = save_number(crew_data, "status", CrewStatus.READY);
    member.status = saved_status == CrewStatus.CRITICALLY_INJURED ? CrewStatus.CRITICALLY_INJURED : CrewStatus.READY;
    member.injury_end_time = current_time + max(0, save_number(crew_data, "injury_remaining_ms", 0));
    member.alive = save_value(crew_data, "alive", true) == true;
    crew[0] = member;

    save_apply_skills(save_value(player, "skills", {}));
    save_apply_unlocks(save_value(player, "skill_unlocks", {}));

    var progression = save_value(_data, "progression", {});
    global.progress.danger_level = max(0, save_number(progression, "danger_level", 0));
    var flags = save_value(progression, "flags", {});
    var flag_keys = variable_struct_get_names(global.progress.flags);
    for (var i = 0; i < array_length(flag_keys); i++)
    {
        var key = flag_keys[i];
        if (is_struct(flags) && variable_struct_exists(flags, key))
            variable_struct_set(global.progress.flags, key, variable_struct_get(flags, key) == true);
    }

    var workshop = save_value(progression, "workshop", {});
    for (var i = 0; i < array_length(workshop_keys); i++)
    {
        var key = workshop_keys[i];
        var bench = variable_struct_get(workshop_db, key);
        variable_struct_set(workshop_progress, key, clamp(save_number(workshop, key, 0), 0, bench.max_level));
    }

    var meta = save_value(_data, "meta", {});
    save_unfinished_raid = save_value(meta, "unfinished_raid", false) == true;
    save_ready = was_ready;
    return true;
}

function save_apply_items(_saved_items, _storage)
{
    if (!is_array(_saved_items)) return;
    for (var i = 0; i < array_length(_saved_items); i++)
    {
        var item = save_item_from_data(_saved_items[i]);
        if (is_undefined(item)) continue;
        if (!stash_item_fits(item.item_key, item.x, item.y, item.rotation, _storage)) continue;
        array_push(_storage.items, item);
    }
}

function save_item_from_data(_data)
{
    if (!is_struct(_data)) return undefined;
    var item_key = save_value(_data, "item_key", "");
    if (!is_string(item_key) || item_key == "" || is_undefined(item_get(item_key))) return undefined;

    var definition = item_get(item_key);
    var max_stack = item_get_max_stack(definition);
    var quantity = floor(clamp(save_number(_data, "quantity", 1), 1, max_stack));
    var rotation = save_number(_data, "rotation", 0) == 90 ? 90 : 0;
    return {
        item_key: item_key,
        quantity: quantity,
        x: floor(save_number(_data, "x", 0)),
        y: floor(save_number(_data, "y", 0)),
        rotation: rotation
    };
}

function save_item_key(_item)
{
    return is_undefined(_item) ? "" : _item.item_key;
}

function save_number(_struct, _key, _default)
{
    var value = save_value(_struct, _key, _default);
    return is_real(value) ? value : _default;
}

function save_apply_skills(_skills)
{
    if (!is_struct(_skills)) return;
    for (var i = 0; i < array_length(player_skill_keys); i++)
    {
        var key = player_skill_keys[i];
        if (!variable_struct_exists(_skills, key)) continue;
        var saved_skill = variable_struct_get(_skills, key);
        var xp = max(0, save_number(saved_skill, "xp", 0));
        variable_struct_set(player_skills, key, { level: skill_get_level_from_xp(xp), xp: xp });
    }
}

function save_apply_unlocks(_unlocks)
{
    skill_node_unlocks = {};
    var skill_keys = variable_struct_get_names(skill_nodes);
    for (var i = 0; i < array_length(skill_keys); i++)
    {
        var skill_key = skill_keys[i];
        var valid_unlocks = {};
        var saved_unlocks = is_struct(_unlocks) ? save_value(_unlocks, skill_key, {}) : {};
        var nodes = skill_node_get_nodes(skill_key);
        for (var j = 0; j < array_length(nodes); j++)
        {
            var node = nodes[j];
            if (node.unlock_type == SkillNodeUnlockType.MONEY
            && is_struct(saved_unlocks)
            && save_value(saved_unlocks, node.key, false) == true)
                variable_struct_set(valid_unlocks, node.key, true);
        }
        variable_struct_set(skill_node_unlocks, skill_key, valid_unlocks);
    }
}

function save_resolve_unfinished_raid()
{
    if (!save_unfinished_raid) return;
    var member = crew[0];
    member.status = CrewStatus.CRITICALLY_INJURED;
    member.injury_end_time = current_time + (5 * 60 * 1000);
    member.weapon = "";
    member.weapon_2 = "";
    member.armor_head = "";
    member.armor_chest = "";
    member.bag = "";
    crew[0] = member;

    stash.backpack.items = [];
    stash.backpack.grid_width = 0;
    stash.backpack.grid_height = 0;
    stash.equipped_bag_item = undefined;
    stash.equipped_weapon_item = undefined;
    stash.equipped_weapon_2_item = undefined;
    stash.equipped_armor_head_item = undefined;
    stash.equipped_armor_chest_item = undefined;
    save_unfinished_raid = false;
}
