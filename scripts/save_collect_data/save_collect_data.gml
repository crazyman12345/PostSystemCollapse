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
    return {
        version: save_format_version,
        meta: { unfinished_raid: save_unfinished_raid },
        player: {
            crew: {
                hp: member.hp,
                max_hp: member.max_hp,
                status: member.status,
                injury_remaining_ms: max(0, member.injury_end_time - current_time),
                alive: member.alive
            },
            skills: skills,
            skill_unlocks: unlocks
        },
        inventory: {
            stash: save_items_to_data(stash.items),
            backpack: {
                grid_width: stash.backpack.grid_width,
                grid_height: stash.backpack.grid_height,
                items: save_items_to_data(stash.backpack.items)
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
        }
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
    return {
        item_key: _item.item_key,
        quantity: _item.quantity,
        x: _item.x,
        y: _item.y,
        rotation: _item.rotation,
        state: {}
    };
}
