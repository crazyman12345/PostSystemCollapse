function init_recipe_database()
{
    recipe_db = {
        gunmaking: [
            {
                name: "HANDLOADED 9MM",
                skill_level: 1,
                ingredients: [
                    { item_key: "metal_scrap", quantity: 2 },
                    { item_key: "gunpowder", quantity: 1 }
                ],
                output: { item_key: "ammo_9mm", quantity: 10 },
                craft_time: 5,
                xp: 10
            },
            {
                name: "M1911",
                skill_level: 5,
                ingredients: [
                    { item_key: "weapon_parts", quantity: 4 },
                    { item_key: "metal_scrap", quantity: 2 },
                    { item_key: "springs", quantity: 1 },
                    { item_key: "screws", quantity: 2 }
                ],
                output: { item_key: "m1911", quantity: 1 },
                craft_time: 20,
                xp: 30
            },
            {
                name: "DOUBLE-BARREL SHOTGUN",
                skill_level: 8,
                ingredients: [
                    { item_key: "metal_scrap", quantity: 5 },
                    { item_key: "weapon_parts", quantity: 2 },
                    { item_key: "wood", quantity: 2 },
                    { item_key: "springs", quantity: 1 },
                    { item_key: "screws", quantity: 2 }
                ],
                output: { item_key: "double_barrel_shotgun", quantity: 1 },
                craft_time: 30,
                xp: 45
            },
            {
                name: "PUMP SHOTGUN",
                skill_level: 15,
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
                name: "UZI",
                skill_level: 20,
                ingredients: [
                    { item_key: "weapon_parts", quantity: 5 },
                    { item_key: "metal_scrap", quantity: 4 },
                    { item_key: "springs", quantity: 2 },
                    { item_key: "mechanical_parts", quantity: 2 },
                    { item_key: "screws", quantity: 2 }
                ],
                output: { item_key: "uzi", quantity: 1 },
                craft_time: 50,
                xp: 85
            }
        ],
        armorcrafting: [
            {
                name: "PADDED JACKET",
                skill_level: 4,
                ingredients: [
                    { item_key: "cloth", quantity: 8 },
                    { item_key: "leather", quantity: 2 },
                    { item_key: "adhesive", quantity: 2 }
                ],
                output: { item_key: "padded_jacket", quantity: 1 },
                craft_time: 20,
                xp: 25
            },
            {
                name: "IMPROVISED PLATE VEST",
                skill_level: 12,
                ingredients: [
                    { item_key: "steel_plate", quantity: 2 },
                    { item_key: "cloth", quantity: 6 },
                    { item_key: "leather", quantity: 3 },
                    { item_key: "bolts", quantity: 4 },
                    { item_key: "adhesive", quantity: 2 }
                ],
                output: { item_key: "improvised_plate_vest", quantity: 1 },
                craft_time: 40,
                xp: 60
            },
            {
                name: "CONSTRUCTION HELMET",
                skill_level: 3,
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
                name: "IMPROVISED STEEL HELMET",
                skill_level: 9,
                ingredients: [
                    { item_key: "steel_plate", quantity: 1 },
                    { item_key: "metal_scrap", quantity: 3 },
                    { item_key: "cloth", quantity: 2 },
                    { item_key: "bolts", quantity: 2 }
                ],
                output: { item_key: "improvised_steel_helmet", quantity: 1 },
                craft_time: 30,
                xp: 45
            },
            {
                name: "SLING BAG",
                skill_level: 2,
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
                name: "SCHOOL BACKPACK",
                skill_level: 6,
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
                name: "SMALL HIKING PACK",
                skill_level: 12,
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
            }
        ],
        medical_crafting: [
            {
                name: "BANDAGE",
                skill_level: 1,
                ingredients: [
                    { item_key: "cloth", quantity: 3 }
                ],
                output: { item_key: "bandage", quantity: 1 },
                craft_time: 3,
                xp: 5
            }
        ],
        drugmaking: [
            {
                name: "MORROWLEAF PAINKILLERS",
                skill_level: 1,
                ingredients: [
                    { item_key: "raw_morrowleaf", quantity: 2 },
                    { item_key: "chemicals", quantity: 1 }
                ],
                output: { item_key: "painkillers", quantity: 1 },
                craft_time: 8,
                xp: 12
            }
        ]
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
    if (skill_get_level(_skill_key) < _recipe.skill_level)
        return false;

    for (var i = 0; i < array_length(_recipe.ingredients); i++)
    {
        var ingredient = _recipe.ingredients[i];

        if (!inventory_has(ingredient.item_key, ingredient.quantity))
            return false;
    }

    return true;
}

function recipe_craft(_skill_key, _recipe)
{
    if (!recipe_can_craft(_skill_key, _recipe))
        return false;

    for (var i = 0; i < array_length(_recipe.ingredients); i++)
    {
        var ingredient = _recipe.ingredients[i];
        inventory_remove(ingredient.item_key, ingredient.quantity);
    }

    inventory_add(_recipe.output.item_key, _recipe.output.quantity);

    if (variable_struct_exists(_recipe, "xp") && _recipe.xp > 0)
        player_skill_add_xp(_skill_key, _recipe.xp);

    log_add("Crafted " + _recipe.name + ".");
    return true;
}
