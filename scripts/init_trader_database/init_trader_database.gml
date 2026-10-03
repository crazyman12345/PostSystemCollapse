function init_trader_database()
{
    global.traders = {};

    // ==============================
    // GENERAL SUPPLY / MATERIAL TRADER
    // ==============================

    global.traders.mara = {
        trader_key : "mara",
        name : "Mara",
        title : "Supply Dealer",
        portrait : spr_trader_mara,
        description :
            "Trades common crafting supplies, basic materials, and useful scavenging goods.",

        stock : [
            {
                item_key : "metal_scrap",
                price : 10
            },

            {
                item_key : "screws",
                price : 6
            },

            {
                item_key : "bolts",
                price : 8
            },

            {
                item_key : "wood",
                price : 7
            },

            {
                item_key : "plastic",
                price : 8
            },

            {
                item_key : "cloth",
                price : 8
            },

            {
                item_key : "adhesive",
                price : 16
            }
        ],

        accepted_categories : [
            ItemCategory.LAB_MATERIAL,
			ItemCategory.MATERIAL
        ]
    };


    // ==============================
    // MEDICAL TRADER
    // ==============================

    global.traders.sawbones = {
        trader_key : "sawbones",
        name : "Sawbones",
        title : "Field Medic",
        portrait : spr_trader_sawbones,
        description :
            "Deals in medical supplies, recovery items, and emergency gear.",

        stock : [
            {
                item_key : "bandage",
                price : 40
            },

            {
                item_key : "medical_supplies",
                price : 30
            },

            {
                item_key : "alcohol",
                price : 25
            }
        ],

        accepted_categories : [
            ItemCategory.MEDICAL
        ]
    };


    // ==============================
    // WEAPONS TRADER
    // ==============================

    global.traders.iron = {
        trader_key : "gundlach",
        name : "Gundlach",
        title : "Arms Dealer",
        portrait : iron_portrait_spr,
        description :
            "Moves firearms, ammunition, and weapon-related salvage.",

        stock : [
            {
                item_key : "m1911",
                price : 300
            },

            {
                item_key : "ammo_45",
                price : 4
            },

            {
                item_key : "ammo_9mm",
                price : 3
            },

            {
                item_key : "ammo_12g",
                price : 5
            },

            {
                item_key : "weapon_parts",
                price : 28
            },

            {
                item_key : "springs",
                price : 15
            }
        ],

        accepted_categories : [
            ItemCategory.WEAPON,
            ItemCategory.AMMO       
        ]
    };


    // ==============================
    // ARMOR / EQUIPMENT TRADER
    // ==============================

    global.traders.bastion = {
        trader_key : "clothman",
        name : "Clothman",
        title : "Equipment Dealer",
        portrait : spr_trader_clothman,
        description :
            "Specializes in armor, packs, protective equipment, and basic field gear.",

        stock : [
            {
                item_key : "sling_bag",
                price : 120
            },

            {
                item_key : "school_backpack",
                price : 220
            },

            {
                item_key : "padded_jacket",
                price : 140
            },

            {
                item_key : "construction_helmet",
                price : 100
            },

            {
                item_key : "cloth",
                price : 10
            },

            {
                item_key : "leather",
                price : 14
            }
        ],

        accepted_categories : [
            ItemCategory.BODY_ARMOR,
            ItemCategory.HEAD_ARMOR,
            ItemCategory.BAG
        ]
    };


    // ==============================
    // BLACK MARKET / RARE GOODS TRADER
    // ==============================

    global.traders.ghost = {
        trader_key : "ghost",
        name : "Ghost",
        title : "Black Market Broker",
        portrait : spr_trader_ghost,
        description :
            "Deals in rare materials, restricted components, and hard-to-find equipment.",

        stock : [
            {
                item_key : "electronics",
                price : 45
            },

            {
                item_key : "mechanical_parts",
                price : 35
            }
        ],

        accepted_categories : [
            ItemCategory.PRODUCT
        ]
    };
	
	
	// ==============================
	// ADMIN / DEBUG TRADER
	// ==============================

	var _admin_stock = [];
	var _item_keys = variable_struct_get_names(global.items);

	for (var i = 0; i < array_length(_item_keys); i++)
	{
		var _key = _item_keys[i];
		var _item = item_get(_key);

		var _price = 1;

		if (variable_struct_exists(_item, "base_value"))
		{
		    _price = max(1, _item.base_value);
		}

		array_push(
		    _admin_stock,
		    {
		        item_key : _key,
		        price : _price
		    }
		);
	}

	global.traders.admin = {
		trader_key : "admin",
		name : "ADMIN",
		title : "DEBUG TRADER",
		portrait : -1,

		description :
		    "Developer trader containing every registered item.",

		stock : _admin_stock,

		accepted_categories : [ItemCategory.AMMO,
		ItemCategory.WEAPON,
		ItemCategory.BAG,
		ItemCategory.BODY_ARMOR,
		ItemCategory.HEAD_ARMOR,
		ItemCategory.MEDICAL,
		ItemCategory.MATERIAL,
		ItemCategory.LAB_MATERIAL,
		ItemCategory.SEED,
		ItemCategory.PRODUCT
		]
	};
}