function init_recipe_database()
{
    recipe_db = {
        gunmaking: [
            {
                name: "9MM",
                skill_level: 1,
                crafting_tier: 1,
                crafting_branch: "ammunition",
                unlock_node: "ammo_9mm",
                ingredients: [
                    { item_key: "metal_scrap", quantity: 2 },
                    { item_key: "gunpowder", quantity: 1 }
                ],
                output: { item_key: "ammo_9mm", quantity: 100 },
                craft_time: 5,
                xp: 10
            },
            {
                name: "12 GAUGE",
                skill_level: 2,
                crafting_tier: 1,
                crafting_branch: "ammunition",
                unlock_node: "ammo_12g",
                ingredients: [
                    { item_key: "metal_scrap", quantity: 2 },
                    { item_key: "gunpowder", quantity: 2 }
                ],
                output: { item_key: "ammo_12g", quantity: 100 },
                craft_time: 6,
                xp: 12
            },
            {
                name: "7.62X54R",
                skill_level: 3,
                crafting_tier: 1,
                crafting_branch: "ammunition",
                unlock_node: "ammo_762x54r",
                ingredients: [
                    { item_key: "metal_scrap", quantity: 3 },
                    { item_key: "gunpowder", quantity: 2 }
                ],
                output: { item_key: "ammo_762x54r", quantity: 100 },
                craft_time: 7,
                xp: 15
            },
            {
                name: ".45 ACP",
                skill_level: 4,
                crafting_tier: 1,
                crafting_branch: "ammunition",
                unlock_node: "ammo_45",
                ingredients: [
                    { item_key: "metal_scrap", quantity: 2 },
                    { item_key: "gunpowder", quantity: 2 }
                ],
                output: { item_key: "ammo_45", quantity: 100 },
                craft_time: 6,
                xp: 12
            },
            {
                name: "7.62X25",
                skill_level: 5,
                crafting_tier: 1,
                crafting_branch: "ammunition",
                unlock_node: "ammo_762x25",
                ingredients: [
                    { item_key: "metal_scrap", quantity: 2 },
                    { item_key: "gunpowder", quantity: 1 }
                ],
                output: { item_key: "ammo_762x25", quantity: 100 },
                craft_time: 5,
                xp: 10
            },
            {
                name: "PIPE PISTOL",
                skill_level: 1,
                crafting_tier: 1,
                crafting_branch: "pistols",
                unlock_node: "gun_pipe_pistol",
                crafting_minigame: "pipe_pistol",
                ingredients: [
                    { item_key: "metal_scrap", quantity: 3 },
                    { item_key: "weapon_parts", quantity: 1 },
                    { item_key: "springs", quantity: 1 },
                    { item_key: "screws", quantity: 1 }
                ],
                output: { item_key: "pipe_pistol", quantity: 1 },
                craft_time: 12,
                xp: 18
            },
            {
                name: "MP-27",
                skill_level: 2,
                crafting_tier: 1,
                crafting_branch: "shotguns",
                unlock_node: "gun_mp27",
                crafting_minigame: "double_barrel_shotgun",
                ingredients: [
                    { item_key: "metal_scrap", quantity: 5 },
                    { item_key: "weapon_parts", quantity: 2 },
                    { item_key: "wood", quantity: 2 },
                    { item_key: "springs", quantity: 1 },
                    { item_key: "screws", quantity: 2 }
                ],
                output: { item_key: "double_barrel_shotgun", quantity: 1 },
                craft_time: 30,
                xp: 35
            },
            {
                name: "MOSIN-NAGANT",
                skill_level: 3,
                crafting_tier: 1,
                crafting_branch: "rifles",
                unlock_node: "gun_mosin",
                crafting_minigame: "mosin_nagant",
                ingredients: [
                    { item_key: "weapon_parts", quantity: 4 },
                    { item_key: "metal_scrap", quantity: 5 },
                    { item_key: "wood", quantity: 4 },
                    { item_key: "screws", quantity: 2 }
                ],
                output: { item_key: "mosin_nagant", quantity: 1 },
                craft_time: 35,
                xp: 42
            },
            {
                name: "M1911",
                skill_level: 4,
                crafting_tier: 1,
                crafting_branch: "pistols",
                unlock_node: "gun_m1911",
                ingredients: [
                    { item_key: "weapon_parts", quantity: 4 },
                    { item_key: "metal_scrap", quantity: 2 },
                    { item_key: "springs", quantity: 1 },
                    { item_key: "screws", quantity: 2 }
                ],
                output: { item_key: "m1911", quantity: 1 },
                crafting_minigame: "m1911",
                craft_time: 20,
                xp: 30
            },
            {
                name: "PPSH-41",
                skill_level: 5,
                crafting_tier: 1,
                crafting_branch: "submachine_guns",
                unlock_node: "gun_ppsh41",
                crafting_minigame: "ppsh_41",
                ingredients: [
                    { item_key: "weapon_parts", quantity: 4 },
                    { item_key: "metal_scrap", quantity: 4 },
                    { item_key: "springs", quantity: 2 },
                    { item_key: "mechanical_parts", quantity: 1 },
                    { item_key: "screws", quantity: 2 }
                ],
                output: { item_key: "ppsh_41", quantity: 1 },
                craft_time: 30,
                xp: 40
            },
            {
                name: "MOSSBERG 500",
                skill_level: 7,
                crafting_tier: 1,
                crafting_branch: "shotguns",
                unlock_node: "gun_mossberg500",
                crafting_minigame: "pump_shotgun",
                ingredients: [
                    { item_key: "weapon_parts", quantity: 6 },
                    { item_key: "mechanical_parts", quantity: 3 },
                    { item_key: "wood", quantity: 2 },
                    { item_key: "springs", quantity: 2 },
                    { item_key: "screws", quantity: 3 }
                ],
                output: { item_key: "pump_shotgun", quantity: 1 },
                craft_time: 45,
                xp: 70
            },
            {
                name: "GLOCK 17",
                skill_level: 10,
                crafting_tier: 2,
                crafting_branch: "pistols",
                unlock_node: "gun_glock17",
                crafting_minigame: "glock17",
                ingredients: [
                    { item_key: "weapon_parts", quantity: 5 },
                    { item_key: "polymer", quantity: 3 },
                    { item_key: "mechanical_parts", quantity: 2 },
                    { item_key: "springs", quantity: 2 },
                    { item_key: "screws", quantity: 2 }
                ],
                output: { item_key: "glock17", quantity: 1 },
                craft_time: 35,
                xp: 75
            },
            {
                name: "UZI",
                skill_level: 12,
                crafting_tier: 2,
                crafting_branch: "submachine_guns",
                unlock_node: "gun_uzi",
                crafting_minigame: "uzi",
                ingredients: [
                    { item_key: "weapon_parts", quantity: 7 },
                    { item_key: "metal_scrap", quantity: 5 },
                    { item_key: "springs", quantity: 3 },
                    { item_key: "mechanical_parts", quantity: 4 },
                    { item_key: "precision_parts", quantity: 1 },
                    { item_key: "screws", quantity: 3 }
                ],
                output: { item_key: "uzi", quantity: 1 },
                craft_time: 50,
                xp: 90
            },
            {
                name: "AKM",
                skill_level: 14,
                crafting_tier: 2,
                crafting_branch: "rifles",
                unlock_node: "gun_akm",
                crafting_minigame: "akm",
                ingredients: [
                    { item_key: "weapon_parts", quantity: 8 },
                    { item_key: "wood", quantity: 3 },
                    { item_key: "mechanical_parts", quantity: 4 },
                    { item_key: "precision_parts", quantity: 2 },
                    { item_key: "springs", quantity: 2 }
                ],
                output: { item_key: "akm", quantity: 1 },
                craft_time: 55,
                xp: 100
            },
            {
                name: "G3",
                skill_level: 17,
                crafting_tier: 2,
                crafting_branch: "rifles",
                unlock_node: "gun_g3",
                crafting_minigame: "g3",
                ingredients: [
                    { item_key: "weapon_parts", quantity: 9 },
                    { item_key: "polymer", quantity: 3 },
                    { item_key: "mechanical_parts", quantity: 5 },
                    { item_key: "precision_parts", quantity: 3 },
                    { item_key: "springs", quantity: 2 }
                ],
                output: { item_key: "g3", quantity: 1 },
                craft_time: 65,
                xp: 120
            }
        ],
        armorcrafting: [
            {
                name: "PACA SOFT ARMOR",
                skill_level: 1,
                crafting_tier: 1,
                crafting_branch: "body_armor",
                unlock_node: "armor_paca",
                crafting_minigame: "paca",
                ingredients: [
                    { item_key: "cloth", quantity: 8 },
                    { item_key: "leather", quantity: 2 },
                    { item_key: "adhesive", quantity: 2 }
                ],
                output: { item_key: "paca", quantity: 1 },
                craft_time: 20,
                xp: 25
            },
            {
                name: "SLING BAG",
                skill_level: 1,
                crafting_tier: 1,
                crafting_branch: "bags",
                unlock_node: "armor_sling_bag",
                crafting_minigame: "sling_bag",
                ingredients: [
                    { item_key: "cloth", quantity: 5 },
                    { item_key: "leather", quantity: 2 },
                    { item_key: "adhesive", quantity: 1 }
                ],
                output: { item_key: "sling_bag", quantity: 1 },
                craft_time: 12,
                xp: 15
            },
            {
                name: "CONSTRUCTION HELMET",
                skill_level: 2,
                crafting_tier: 1,
                crafting_branch: "helmets",
                unlock_node: "armor_construction_helmet",
                crafting_minigame: "construction_helmet",
                ingredients: [
                    { item_key: "plastic", quantity: 4 },
                    { item_key: "metal_scrap", quantity: 2 },
                    { item_key: "cloth", quantity: 2 },
                    { item_key: "screws", quantity: 2 }
                ],
                output: { item_key: "construction_helmet", quantity: 1 },
                craft_time: 15,
                xp: 20
            },
            {
                name: "SCHOOL BACKPACK",
                skill_level: 4,
                crafting_tier: 1,
                crafting_branch: "bags",
                unlock_node: "armor_school_backpack",
                crafting_minigame: "school_backpack",
                ingredients: [
                    { item_key: "cloth", quantity: 8 },
                    { item_key: "leather", quantity: 3 },
                    { item_key: "plastic", quantity: 2 },
                    { item_key: "adhesive", quantity: 2 }
                ],
                output: { item_key: "school_backpack", quantity: 1 },
                craft_time: 25,
                xp: 35
            },
            {
                name: "POLICE SOFT ARMOR",
                skill_level: 5,
                crafting_tier: 1,
                crafting_branch: "body_armor",
                unlock_node: "armor_police_soft_armor",
                crafting_minigame: "police_soft_armor",
                ingredients: [
                    { item_key: "cloth", quantity: 10 },
                    { item_key: "leather", quantity: 3 },
                    { item_key: "ballistic_fabric", quantity: 2 },
                    { item_key: "adhesive", quantity: 2 }
                ],
                output: { item_key: "police_soft_armor", quantity: 1 },
                craft_time: 28,
                xp: 42
            },
            {
                name: "RIOT HELMET",
                skill_level: 7,
                crafting_tier: 1,
                crafting_branch: "helmets",
                unlock_node: "armor_riot_helmet",
                crafting_minigame: "riot_helmet",
                ingredients: [
                    { item_key: "plastic", quantity: 6 },
                    { item_key: "steel_plate", quantity: 1 },
                    { item_key: "cloth", quantity: 2 },
                    { item_key: "screws", quantity: 2 }
                ],
                output: { item_key: "riot_helmet", quantity: 1 },
                craft_time: 28,
                xp: 48
            },
            {
                name: "SMALL HIKING PACK",
                skill_level: 8,
                crafting_tier: 1,
                crafting_branch: "bags",
                unlock_node: "armor_small_hiking_pack",
                crafting_minigame: "small_hiking_pack",
                ingredients: [
                    { item_key: "cloth", quantity: 10 },
                    { item_key: "leather", quantity: 4 },
                    { item_key: "rubber", quantity: 2 },
                    { item_key: "plastic", quantity: 3 },
                    { item_key: "adhesive", quantity: 2 }
                ],
                output: { item_key: "small_hiking_pack", quantity: 1 },
                craft_time: 40,
                xp: 60
            },
            {
                name: "LSHZ LIGHTWEIGHT HELMET",
                skill_level: 10,
                crafting_tier: 2,
                crafting_branch: "helmets",
                unlock_node: "armor_lshz",
                crafting_minigame: "improvised_steel_helmet",
                ingredients: [
                    { item_key: "steel_plate", quantity: 1 },
                    { item_key: "metal_scrap", quantity: 3 },
                    { item_key: "cloth", quantity: 2 },
                    { item_key: "bolts", quantity: 2 }
                ],
                output: { item_key: "improvised_steel_helmet", quantity: 1 },
                craft_time: 30,
                xp: 70
            }
        ],
        medical_crafting: [
            {
                name: "BANDAGE",
                skill_level: 1,
                crafting_tier: 1,
                crafting_branch: "medical",
                unlock_node: "medical_bandage",
                ingredients: [
                    { item_key: "cloth", quantity: 3 }
                ],
                output: { item_key: "bandage", quantity: 1 },
                craft_time: 3,
                xp: 18
            },
            {
                name: "SPLINT",
                skill_level: 3,
                crafting_tier: 1,
                crafting_branch: "medical",
                unlock_node: "medical_splint",
                ingredients: [
                    { item_key: "wood", quantity: 2 },
                    { item_key: "cloth", quantity: 2 }
                ],
                output: { item_key: "splint", quantity: 1 },
                craft_time: 5,
                xp: 28
            },
            {
                name: "TOURNIQUET",
                skill_level: 5,
                crafting_tier: 1,
                crafting_branch: "medical",
                unlock_node: "medical_tourniquet",
                ingredients: [
                    { item_key: "cloth", quantity: 3 },
                    { item_key: "rubber", quantity: 1 }
                ],
                output: { item_key: "tourniquet", quantity: 1 },
                craft_time: 6,
                xp: 38
            },
            {
                name: "MORROWLEAF PAINKILLERS",
                skill_level: 7,
                crafting_tier: 1,
                crafting_branch: "medical",
                unlock_node: "medical_painkillers",
                ingredients: [
                    { item_key: "raw_morrowleaf", quantity: 2 },
                    { item_key: "chemicals", quantity: 1 }
                ],
                output: { item_key: "painkillers", quantity: 1 },
                craft_time: 8,
                xp: 48
            },
            {
                name: "IFAK",
                skill_level: 9,
                crafting_tier: 1,
                crafting_branch: "medical",
                unlock_node: "medical_ifak",
                ingredients: [
                    { item_key: "medical_supplies", quantity: 4 },
                    { item_key: "bandage", quantity: 2 },
                    { item_key: "alcohol", quantity: 1 }
                ],
                output: { item_key: "medkit", quantity: 1 },
                craft_time: 15,
                xp: 60
            },
            {
                name: "SURGICAL KIT",
                skill_level: 10,
                crafting_tier: 2,
                crafting_branch: "medical",
                unlock_node: "medical_surgical_kit",
                ingredients: [
                    { item_key: "medical_supplies", quantity: 8 },
                    { item_key: "alcohol", quantity: 3 },
                    { item_key: "cloth", quantity: 4 },
                    { item_key: "steel_plate", quantity: 1 }
                ],
                output: { item_key: "surgical_kit", quantity: 1 },
                craft_time: 25,
                xp: 75
            }
        ],
        drugmaking: []
    };
}

function recipe_get_for_skill(_skill_key)
{
    if (!variable_struct_exists(recipe_db, _skill_key))
        return [];

    return variable_struct_get(recipe_db, _skill_key);
}

function recipe_can_craft(_skill_key, _recipe)
{
    if (!recipe_is_unlocked(_skill_key, _recipe))
        return false;

    if (debug_free_craft) return true;

    for (var i = 0; i < array_length(_recipe.ingredients); i++)
    {
        var ingredient = _recipe.ingredients[i];

        if (!stash_has(ingredient.item_key, ingredient.quantity))
            return false;
    }

    return true;
}

function recipe_is_unlocked(_skill_key, _recipe)
{
    if (skill_get_level(_skill_key) < _recipe.skill_level) return false;
    if (!variable_struct_exists(_recipe, "unlock_node")) return true;

    var _node = skill_node_find(skill_node_get_nodes(_skill_key), _recipe.unlock_node);
    return !is_undefined(_node) && skill_node_is_unlocked(_skill_key, _node);
}

function recipe_craft(_skill_key, _recipe)
{
    if (!recipe_can_craft(_skill_key, _recipe))
        return false;

    if (!stash_add(_recipe.output.item_key, _recipe.output.quantity))
        return false;

    if (!debug_free_craft) for (var i = 0; i < array_length(_recipe.ingredients); i++)
    {
        var ingredient = _recipe.ingredients[i];
        stash_remove(ingredient.item_key, ingredient.quantity);
    }

    if (variable_struct_exists(_recipe, "xp") && _recipe.xp > 0)
        player_skill_add_xp(_skill_key, _recipe.xp);

    audio_play_sound(snd_level_up, 0, false);
    return true;
}
