function save_collect_data()
{
    var skills = {};
    for (var i = 0; i < array_length(player_skill_keys); i++)
    {
        var key = player_skill_keys[i];
        var progress = variable_struct_get(player_skills, key);
        variable_struct_set(skills, key, { level: progress.level, xp: progress.xp });
    }

    var unlocks = {};
    var unlock_skill_keys = variable_struct_get_names(skill_nodes);
    for (var i = 0; i < array_length(unlock_skill_keys); i++)
    {
        var skill_key = unlock_skill_keys[i];
        var saved_unlocks = {};
        if (variable_struct_exists(skill_node_unlocks, skill_key))
        {
            var current_unlocks = variable_struct_get(skill_node_unlocks, skill_key);
            var unlock_keys = variable_struct_get_names(current_unlocks);
            for (var j = 0; j < array_length(unlock_keys); j++)
                variable_struct_set(saved_unlocks, unlock_keys[j], variable_struct_get(current_unlocks, unlock_keys[j]));
        }
        variable_struct_set(unlocks, skill_key, saved_unlocks);
    }

    var flags = {};
    var flag_keys = variable_struct_get_names(global.progress.flags);
    for (var i = 0; i < array_length(flag_keys); i++)
        variable_struct_set(flags, flag_keys[i], variable_struct_get(global.progress.flags, flag_keys[i]));

    var workshop = {};
    for (var i = 0; i < array_length(workshop_keys); i++)
        variable_struct_set(workshop, workshop_keys[i], variable_struct_get(workshop_progress, workshop_keys[i]));

    var member = crew[0];
    var saved_limbs = [];
    for (var i = 0; i < array_length(health_limbs); i++)
    {
        var limb = health_limbs[i];
        var saved_bleeds = [];
        for (var j = 0; j < array_length(limb.bleeds); j++)
        {
            var bleed = limb.bleeds[j];
            array_push(saved_bleeds, {
                type: bleed.type,
                tick_remaining: bleed.tick_remaining,
                recovery_remaining: bleed.recovery_remaining
            });
        }
        array_push(saved_limbs, {
            hp: limb.hp,
            fractured: limb.fractured,
            bleed: limb.bleed,
            bleeds: saved_bleeds
        });
    }
    return {
        version: save_format_version,
        meta: { unfinished_raid: save_unfinished_raid },
        player: {
            crew: {
                name: member.name,
                hp: member.hp,
                max_hp: member.max_hp,
                status: member.status,
                injury_remaining_ms: max(0, member.injury_end_time - current_time),
                alive: member.alive
            },
            skills: skills,
            skill_unlocks: unlocks
        },
        health: {
            hp: raid_player_hp,
            painkiller_remaining: health_painkiller_remaining,
            limbs: saved_limbs
        },
        survival: {
            energy: player_energy,
            hydration: player_hydration
        },
        inventory: {
            stash: save_items_to_data(stash.items),
            backpack: {
                grid_width: stash.backpack.grid_width,
                grid_height: stash.backpack.grid_height,
                items: save_items_to_data(stash.backpack.items)
            },
            pockets: {
                items: save_items_to_data(stash.pockets.items)
            },
            secure_container: {
                grid_width: stash.secure_container.grid_width,
                grid_height: stash.secure_container.grid_height,
                items: save_items_to_data(stash.secure_container.items)
            },
            equipment: {
                weapon_1: save_item_to_data(stash.equipped_weapon_item),
                weapon_2: save_item_to_data(stash.equipped_weapon_2_item),
                head: save_item_to_data(stash.equipped_armor_head_item),
                chest: save_item_to_data(stash.equipped_armor_chest_item),
                backpack: save_item_to_data(stash.equipped_bag_item),
                secure_container: save_item_to_data(stash.equipped_secure_container_item)
            }
        },
        progression: {
            danger_level: global.progress.danger_level,
            flags: flags,
            workshop: workshop
        },
		quests: quest_save_data(),
		dialogue: dialogue_save_data()
    };
}

function save_items_to_data(_items)
{
    var result = [];
    for (var i = 0; i < array_length(_items); i++) array_push(result, save_item_to_data(_items[i]));
    return result;
}

function save_item_to_data(_item)
{
    if (is_undefined(_item)) return {};
    var _state = {};
    if (variable_struct_exists(_item, "durability")) _state.durability = _item.durability;
    if (variable_struct_exists(_item, "servings")) _state.servings = _item.servings;
    return {
        item_key: _item.item_key,
        quantity: _item.quantity,
        x: _item.x,
        y: _item.y,
        rotation: _item.rotation,
        state: _state
    };
}
