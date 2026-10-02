function init_loot_tables()
{
    global.loot_tables = {};


    // ==============================
    // BASIC SCAVENGER
    // ==============================

    global.loot_tables.scavenger_basic = [
        {
            item_key : "cloth_scraps",
            chance : 0.75,
            quantity_min : 1,
            quantity_max : 4
        },

        {
            item_key : "sewing_kit",
            chance : 0.30,
            quantity_min : 1,
            quantity_max : 2
        },

        {
            item_key : "ammo_9mm",
            chance : 0.40,
            quantity_min : 3,
            quantity_max : 10
        },

        {
            item_key : "pistol",
            chance : 0.08,
            quantity_min : 1,
            quantity_max : 1
        }
    ];


    // ==============================
    // BLOCK ENFORCER BOSS
    // ==============================

    global.loot_tables.block_enforcer = [
        {
            item_key : "metal_scrap",
            chance : 1.00,
            quantity_min : 4,
            quantity_max : 8
        },

        {
            item_key : "electronics",
            chance : 0.80,
            quantity_min : 2,
            quantity_max : 5
        },

        {
            item_key : "ammo_9mm",
            chance : 0.75,
            quantity_min : 10,
            quantity_max : 25
        },

        {
            item_key : "pistol",
            chance : 0.35,
            quantity_min : 1,
            quantity_max : 1
        }
    ];
	
	global.loot_tables.junction_basic = [
    {
        item_key : "metal_scrap",
        chance : 0.80,
        quantity_min : 1,
        quantity_max : 4
    },

    {
        item_key : "wires",
        chance : 0.45,
        quantity_min : 1,
        quantity_max : 2
    },

    {
        item_key : "ammo_9mm",
        chance : 0.25,
        quantity_min : 2,
        quantity_max : 8
    }
];

global.loot_tables.prototype_residential =
[
    {
        item_key: "cash",
        quantity_min: 5,
        quantity_max: 25,
        chance: 0.80
    },

    {
        item_key: "cloth_scraps",
        quantity_min: 1,
        quantity_max: 3,
        chance: 0.65
    },

    {
        item_key: "sewing_kit",
        quantity_min: 1,
        quantity_max: 1,
        chance: 0.30
    },

    {
        item_key: "fuse",
        quantity_min: 1,
        quantity_max: 2,
        chance: 1
    }
];
global.loot_tables.prototype_industrial =
[
    {
        item_key: "metal_pipe",
        quantity_min: 1,
        quantity_max: 2,
        chance: 0.70
    },

    {
        item_key: "metal_gear",
        quantity_min: 1,
        quantity_max: 2,
        chance: 0.50
    },

    {
        item_key: "metal_spring",
        quantity_min: 1,
        quantity_max: 1,
        chance: 0.35
    },

    {
        item_key: "sheet_metal",
        quantity_min: 1,
        quantity_max: 1,
        chance: 0.20
    },

    {
        item_key: "fuse",
        quantity_min: 1,
        quantity_max: 2,
        chance: 0.50
    }
];
global.loot_tables.prototype_boss =
[
    {
        item_key: "cash",
        quantity_min: 75,
        quantity_max: 150,
        chance: 1.00
    },

    {
        item_key: "circuit_board",
        quantity_min: 1,
        quantity_max: 3,
        chance: 1.00
    },

    {
        item_key: "steel_bar",
        quantity_min: 1,
        quantity_max: 2,
        chance: 0.75
    }
];
}