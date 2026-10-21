function init_item_database()
{
    // ============================================================
    // ITEM DATABASE
    // ============================================================

    global.items = {};


    // ============================================================
    // CRAFTING MATERIALS
    // ============================================================

    global.items.metal_scrap = {
        item_key: "metal_scrap",
        name: "Scrap Metal",
        category: ItemCategory.MATERIAL,
        description: "Assorted pieces of scrap metal useful for crafting and repairs.",
        base_value: 8,
        weight: 0.6,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_metal_scrap
    };

    global.items.weapon_parts = {
        item_key: "weapon_parts",
        name: "Weapon Parts",
        category: ItemCategory.MATERIAL,
        description: "Usable firearm components recovered from damaged or dismantled weapons.",
        base_value: 20,
        weight: 0.3,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_weapon_parts
    };

    global.items.springs = {
        item_key: "springs",
        name: "Springs",
        category: ItemCategory.MATERIAL,
        description: "Small mechanical springs used in weapons and machinery.",
        base_value: 12,
        weight: 0.1,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_springs
    };

    global.items.screws = {
        item_key: "screws",
        name: "Screws",
        category: ItemCategory.MATERIAL,
        description: "Assorted screws used for construction and repairs.",
        base_value: 5,
        weight: 0.05,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_screws
    };

    global.items.bolts = {
        item_key: "bolts",
        name: "Bolts",
        category: ItemCategory.MATERIAL,
        description: "Assorted bolts used for construction, repairs, and crafting.",
        base_value: 8,
        weight: 0.1,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_bolts
    };

    global.items.wood = {
        item_key: "wood",
        name: "Wood",
        category: ItemCategory.MATERIAL,
        description: "Salvaged pieces of usable wood.",
        base_value: 5,
        weight: 0.5,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_wood
    };

    global.items.plastic = {
        item_key: "plastic",
        name: "Plastic",
        category: ItemCategory.MATERIAL,
        description: "Salvaged plastic suitable for crafting and repairs.",
        base_value: 6,
        weight: 0.1,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_plastic_scrap
    };

    global.items.cloth = {
        item_key: "cloth",
        name: "Cloth",
        category: ItemCategory.MATERIAL,
        description: "Scraps of fabric useful for clothing, bags, armor, and medical supplies.",
        base_value: 6,
        weight: 0.1,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_cloth
    };

    global.items.leather = {
        item_key: "leather",
        name: "Leather",
        category: ItemCategory.MATERIAL,
        description: "Durable pieces of leather useful for clothing, armor, and bags.",
        base_value: 10,
        weight: 0.2,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_leather
    };

    global.items.rubber = {
        item_key: "rubber",
        name: "Rubber",
        category: ItemCategory.MATERIAL,
        description: "Flexible rubber material recovered from old equipment.",
        base_value: 8,
        weight: 0.2,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_rubber
    };

    global.items.adhesive = {
        item_key: "adhesive",
        name: "Adhesive",
        category: ItemCategory.MATERIAL,
        description: "Industrial adhesive used to bind and repair materials.",
        base_value: 12,
        weight: 0.2,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_adhesive,
		grid_height: 2
    };

    global.items.chemicals = {
        item_key: "chemicals",
        name: "Chemicals",
        category: ItemCategory.MATERIAL,
        description: "Assorted chemical compounds useful for advanced crafting.",
        base_value: 18,
        weight: 0.3,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_chemicals
    };

    global.items.gunpowder = {
        item_key: "gunpowder",
        name: "Gunpowder",
        category: ItemCategory.MATERIAL,
        description: "Propellant used in the production of ammunition.",
        base_value: 18,
        weight: 0.2,
		grid_height: 2,
        stackable: true,
		max_stack: 5
    };

    global.items.mechanical_parts = {
        item_key: "mechanical_parts",
        name: "Mechanical Parts",
        category: ItemCategory.MATERIAL,
        description: "Gears, bearings, and other useful mechanical components.",
        base_value: 25,
        weight: 0.4,
        stackable: true,
		grid_width: 2,
		max_stack: 5,
		icon_sprite: spr_mechanicalparts
    };

    global.items.precision_parts = {
        item_key: "precision_parts",
        name: "Precision Parts",
        category: ItemCategory.MATERIAL,
        description: "Finely manufactured components required for advanced equipment.",
        base_value: 45,
        weight: 0.2,
		grid_width: 2,
		icon_sprite: spr_precisionparts,
        stackable: true,
		max_stack: 5
    };

    global.items.electronics = {
        item_key: "electronics",
        name: "Electronics",
        category: ItemCategory.MATERIAL,
        description: "Reusable electronic components recovered from old devices.",
        base_value: 30,
        weight: 0.2,
		icon_sprite: spr_electronics,
		grid_width: 2,
        stackable: true,
		max_stack: 5
    };

    global.items.steel_plate = {
        item_key: "steel_plate",
        name: "Steel Plate",
        category: ItemCategory.MATERIAL,
        description: "A heavy plate of steel suitable for protective equipment.",
        base_value: 35,
        weight: 1.5,
		grid_width: 2,
		grid_height: 2,
        stackable: true,
		max_stack: 5
    };

    global.items.aluminum = {
        item_key: "aluminum",
        name: "Aluminum",
        category: ItemCategory.MATERIAL,
        description: "Lightweight metal useful for advanced equipment.",
        base_value: 25,
        weight: 0.5,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_aluminum
    };

    global.items.polymer = {
        item_key: "polymer",
        name: "Polymer",
        category: ItemCategory.MATERIAL,
        description: "Durable synthetic material used in modern equipment and firearms.",
        base_value: 30,
        weight: 0.2,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_polymer
    };

    global.items.ballistic_fabric = {
        item_key: "ballistic_fabric",
        name: "Ballistic Fabric",
        category: ItemCategory.MATERIAL,
        description: "High-strength fabric designed to resist ballistic impacts.",
        base_value: 45,
        weight: 0.3,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_ballisticfabric
    };

    global.items.ceramic_plate = {
        item_key: "ceramic_plate",
        name: "Ceramic Plate",
        category: ItemCategory.MATERIAL,
        description: "A hardened ceramic armor plate used in advanced protective equipment.",
        base_value: 70,
        weight: 1.2,
		grid_width: 2,
		grid_height: 2,
        stackable: true,
		max_stack: 5
    };

    global.items.medical_supplies = {
        item_key: "medical_supplies",
        name: "Medical Supplies",
        category: ItemCategory.MATERIAL,
        description: "General medical materials used to craft treatment items.",
        base_value: 25,
        weight: 0.2,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_medical_parts
    };

    global.items.alcohol = {
        item_key: "alcohol",
        name: "Alcohol",
        category: ItemCategory.MATERIAL,
        description: "Medical-grade alcohol useful for disinfecting and crafting medicine.",
        base_value: 20,
        weight: 0.3,
        stackable: true,
		max_stack: 5,
		grid_height: 2,
		icon_sprite: spr_alcohol
    };

    global.items.rare_weapon_parts = {
        item_key: "rare_weapon_parts",
        name: "Rare Weapon Parts",
        category: ItemCategory.MATERIAL,
        description: "High-quality firearm components used to build advanced weapons.",
        base_value: 80,
        weight: 0.3,
        stackable: true,
		max_stack: 5,
		icon_sprite: spr_rare_weapparts
    };


    // ============================================================
    // SALVAGE / JUNK ITEMS
    // ============================================================

    global.items.broken_toaster = {
        item_key: "broken_toaster",
        name: "Broken Toaster",
        category: ItemCategory.MATERIAL,
        description: "A dead toaster. Mostly useful for the metal and hardware inside.",
        base_value: 15,
        weight: 1.5,
        stackable: false,
		icon_sprite: spr_brokentoaster,
		grid_width: 2,
		grid_height: 2,
        salvage: [
            { item_key: "metal_scrap", quantity: 4 },
            { item_key: "screws", quantity: 2 }
        ]
    };

    global.items.desk_fan = {
        item_key: "desk_fan",
        name: "Desk Fan",
        category: ItemCategory.MATERIAL,
        description: "An old electric fan containing useful mechanical components.",
        base_value: 22,
        weight: 2.0,
        stackable: false,
		icon_sprite: spr_deskfan,
		grid_width: 2,
		grid_height: 2,
        salvage: [
            { item_key: "metal_scrap", quantity: 3 },
            { item_key: "screws", quantity: 2 },
            { item_key: "mechanical_parts", quantity: 1 }
        ]
    };

    global.items.power_drill = {
        item_key: "power_drill",
        name: "Power Drill",
        category: ItemCategory.MATERIAL,
        description: "A damaged power drill containing several useful mechanical components.",
        base_value: 35,
        weight: 1.5,
        stackable: false,
		icon_sprite: spr_powerdrill,
		grid_width: 2,
		grid_height: 2,
        salvage: [
            { item_key: "metal_scrap", quantity: 2 },
            { item_key: "mechanical_parts", quantity: 2 },
            { item_key: "springs", quantity: 1 },
            { item_key: "plastic", quantity: 2 }
        ]
    };

    global.items.broken_radio = {
        item_key: "broken_radio",
        name: "Broken Radio",
        category: ItemCategory.MATERIAL,
        description: "A damaged radio containing salvageable plastic and electronic components.",
        base_value: 30,
        weight: 1.0,
        stackable: false,
		grid_width: 2,
		grid_height: 2,
		icon_sprite: spr_brokenradio,
        salvage: [
            { item_key: "metal_scrap", quantity: 1 },
            { item_key: "plastic", quantity: 2 },
            { item_key: "electronics", quantity: 1 }
        ]
    };

    global.items.car_battery = {
        item_key: "car_battery",
        name: "Car Battery",
        category: ItemCategory.MATERIAL,
        description: "A heavy automotive battery containing useful materials.",
        base_value: 35,
        weight: 6.0,
        stackable: false,
		grid_width: 2,
		grid_height: 2,
		icon_sprite: spr_carbattery,
        salvage: [
            { item_key: "metal_scrap", quantity: 3 },
            { item_key: "chemicals", quantity: 1 },
            { item_key: "plastic", quantity: 1 }
        ]
    };

    global.items.old_rifle = {
        item_key: "old_rifle",
        name: "Old Rifle",
        category: ItemCategory.MATERIAL,
        description: "A ruined rifle that is no longer usable but contains valuable weapon components.",
        base_value: 60,
        weight: 3.5,
        stackable: false,
        salvage: [
            { item_key: "weapon_parts", quantity: 4 },
            { item_key: "metal_scrap", quantity: 2 },
            { item_key: "springs", quantity: 1 },
            { item_key: "wood", quantity: 1 }
        ]
    };

    global.items.broken_pistol = {
        item_key: "broken_pistol",
        name: "Broken Pistol",
        category: ItemCategory.MATERIAL,
        description: "A damaged handgun useful only for spare parts.",
        base_value: 40,
        weight: 1.1,
        stackable: false,
        salvage: [
            { item_key: "weapon_parts", quantity: 3 },
            { item_key: "metal_scrap", quantity: 1 },
            { item_key: "springs", quantity: 1 }
        ]
    };

    global.items.metal_toolbox = {
        item_key: "metal_toolbox",
        name: "Metal Toolbox",
        category: ItemCategory.MATERIAL,
        description: "A battered toolbox containing a useful amount of hardware and scrap.",
        base_value: 35,
        weight: 3.0,
        stackable: false,
        salvage: [
            { item_key: "metal_scrap", quantity: 5 },
            { item_key: "screws", quantity: 3 },
            { item_key: "bolts", quantity: 2 }
        ]
    };

    global.items.computer = {
        item_key: "computer",
        name: "Computer",
        category: ItemCategory.MATERIAL,
        description: "An obsolete computer packed with salvageable electronics.",
        base_value: 70,
        weight: 5.0,
        stackable: false,
        salvage: [
            { item_key: "metal_scrap", quantity: 2 },
            { item_key: "plastic", quantity: 3 },
            { item_key: "electronics", quantity: 3 },
            { item_key: "precision_parts", quantity: 1 }
        ]
    };

    global.items.printer = {
        item_key: "printer",
        name: "Printer",
        category: ItemCategory.MATERIAL,
        description: "A broken office printer containing plastic, electronics, and mechanical components.",
        base_value: 45,
        weight: 4.0,
        stackable: false,
        salvage: [
            { item_key: "metal_scrap", quantity: 2 },
            { item_key: "plastic", quantity: 4 },
            { item_key: "electronics", quantity: 1 },
            { item_key: "mechanical_parts", quantity: 1 }
        ]
    };

    global.items.sewing_kit = {
        item_key: "sewing_kit",
        name: "Sewing Kit",
        category: ItemCategory.MATERIAL,
        description: "A collection of sewing supplies useful for breaking down into textile materials.",
        base_value: 25,
        weight: 0.4,
        stackable: false,
        salvage: [
            { item_key: "cloth", quantity: 3 },
            { item_key: "leather", quantity: 1 },
            { item_key: "adhesive", quantity: 1 }
        ]
    };

    global.items.medical_bag = {
        item_key: "medical_bag",
        name: "Medical Bag",
        category: ItemCategory.MATERIAL,
        description: "An abandoned medical bag containing useful treatment supplies.",
        base_value: 50,
        weight: 1.2,
        stackable: false,
        salvage: [
            { item_key: "cloth", quantity: 2 },
            { item_key: "medical_supplies", quantity: 3 },
            { item_key: "alcohol", quantity: 1 }
        ]
    };

    global.items.broken_armor = {
        item_key: "broken_armor",
        name: "Broken Armor",
        category: ItemCategory.MATERIAL,
        description: "Damaged protective equipment that can be stripped for useful materials.",
        base_value: 50,
        weight: 4.0,
        stackable: false,
        salvage: [
            { item_key: "cloth", quantity: 3 },
            { item_key: "metal_scrap", quantity: 2 },
            { item_key: "steel_plate", quantity: 1 }
        ]
    };

    global.items.hiking_pack_junk = {
        item_key: "hiking_pack_junk",
        name: "Damaged Hiking Pack",
        category: ItemCategory.MATERIAL,
        description: "A badly damaged hiking pack that can be cut apart for materials.",
        base_value: 35,
        weight: 1.5,
        stackable: false,
        salvage: [
            { item_key: "cloth", quantity: 5 },
            { item_key: "leather", quantity: 2 },
            { item_key: "rubber", quantity: 1 },
            { item_key: "plastic", quantity: 1 }
        ]
    };


    // ============================================================
    // AMMUNITION
    // ============================================================

    global.items.ammo_9mm = {
        item_key: "ammo_9mm",
        name: "9mm Ammo",
        category: ItemCategory.AMMO,
        description: "Common 9mm ammunition.",
        base_value: 2,
        weight: 0.02,
        stackable: true,
		max_stack: 60,
		icon_sprite: spr_9mm
    };

    global.items.ammo_45 = {
        item_key: "ammo_45",
        name: ".45 ACP Ammo",
        category: ItemCategory.AMMO,
        description: "Heavy pistol ammunition used by weapons such as the M1911.",
        base_value: 3,
		max_stack: 60,
        weight: 0.025,
        stackable: true,
		icon_sprite: spr_45acp
    };

    global.items.ammo_12g = {
        item_key: "ammo_12g",
        name: "12 Gauge Shell",
        category: ItemCategory.AMMO,
        description: "A common shotgun shell.",
        base_value: 4,
		max_stack: 60,
        weight: 0.05,
        stackable: true,
		icon_sprite: spr_buckshot
    };


    // ============================================================
    //  WEAPON
    // ============================================================

    global.items.pipe_pistol = {
        item_key: "pipe_pistol",
        name: "Pipe Pistol",
        category: ItemCategory.WEAPON,
        description: "A crude homemade pistol. Unreliable and weak, but better than nothing.",
        base_value: 75,
        weight: 1.3,
        stackable: false,

        damage_min: 12,
        damage_max: 18,
        fire_rate: 2,
        mag_size: 5,
        reload_time: 90,
        bullet_speed: 7,
        accuracy_bonus: -0.05,
		grid_width: 2,
		grid_height: 1,
        ammo_key: "ammo_9mm",
        ammo_per_attack: 1,
        weapon_sprite: spr_pipe_pistol,
		sound_shoot: nine_shot,
        sound_reload: nine_reload,
        sound_empty: nine_empty,

   		weapon_offset_x: 11,
		weapon_draw_width: 28,
        hand1_x: 0,
        hand1_y: 0,
        hand2_x: 0,
        hand2_y: 0,
        has_second_hand: false,
        muzzle_x: 24,
        muzzle_y: 5,

        fire_modes: [WeaponFireMode.SEMI]
    };

    global.items.m1911 = {
        item_key: "m1911",
        name: "M1911 Pistol",
        category: ItemCategory.WEAPON,
        description: "A reliable semi-automatic pistol with strong stopping power.",
        base_value: 250,
        weight: 1.1,
        stackable: false,

        damage_min: 18,
        damage_max: 24,
        fire_rate: 4,
        mag_size: 7,
        reload_time: 60,
        bullet_speed: 8,
        accuracy_bonus: 0.05,
	
        ammo_key: "ammo_9mm",
        ammo_per_attack: 1,

        weapon_sprite: spr_1911,
        sound_shoot: nine_shot,
        sound_reload: nine_reload,
        sound_empty: nine_empty,
		grid_width: 2,
		grid_height: 1,
		
		weapon_offset_x: 14,
		weapon_draw_width: 22,
        hand1_x: 0,
        hand1_y: 0,
        hand2_x: 0,
        hand2_y: 0,
        has_second_hand: false,
        muzzle_x: 19,
        muzzle_y: 5.8,

        fire_modes: [WeaponFireMode.SEMI]
    };

    global.items.double_barrel_shotgun = {
        item_key: "double_barrel_shotgun",
        name: "Double-Barrel Shotgun",
        category: ItemCategory.WEAPON,
        description: "A simple break-action shotgun capable of devastating close-range damage.",
        base_value: 325,
        weight: 3.0,
        stackable: false,

        damage_min: 8,
        damage_max: 10,
        fire_rate: 2,
        mag_size: 2,
        reload_time: 100,
        bullet_speed: 7,
        accuracy_bonus: -0.10,
		pellet_count: 8,
		pellet_spread: 6,
		weapon_draw_width: 64,
        ammo_key: "ammo_12g",
        ammo_per_attack: 1,

        weapon_sprite: spr_double_barrel,
        sound_shoot: shotgun_shoot,
        sound_reload: nine_reload,
        sound_empty: nine_empty,

		grid_width: 5,
		grid_height: 1,

      	weapon_offset_x: 10,
		weapon_draw_width: 44,
        hand1_x: 0,
        hand1_y: 0,
        hand2_x: 15,
        hand2_y: 0,
        has_second_hand: true,
        muzzle_x: 28,
        muzzle_y: 1,

        fire_modes: [WeaponFireMode.SEMI]
    };

    global.items.pump_shotgun = {
        item_key: "pump_shotgun",
        name: "Pump Shotgun",
        category: ItemCategory.WEAPON,
        description: "A dependable pump-action shotgun with considerably more capacity than a break-action.",
        base_value: 500,
        weight: 3.5,
        stackable: false,

        damage_min: 8,
        damage_max: 11,
        fire_rate: 1.2,
        mag_size: 5,
        reload_time: 120,
        bullet_speed: 7,
        accuracy_bonus: -0.05,
		pellet_count: 8,
		pellet_spread: 8,

        ammo_key: "ammo_12g",
        ammo_per_attack: 1,

        weapon_sprite: spr_pump_shotgun,
        sound_shoot: shotgun_shoot,
        sound_reload: shotgun_reload,
        sound_empty: nine_empty,
		
		grid_width: 5,
		grid_height: 1,
		
		weapon_offset_x: 6,
		weapon_draw_width: 44,
        hand1_x: 0,
        hand1_y: 0,
        hand2_x: 17,
        hand2_y: 0,
        has_second_hand: true,
        muzzle_x: 33,
        muzzle_y: 2,

        fire_modes: [WeaponFireMode.SEMI]
    };

    global.items.uzi = {
        item_key: "uzi",
        name: "Uzi",
        category: ItemCategory.WEAPON,
        description: "A compact automatic submachine gun with a high rate of fire.",
        base_value: 550,
        weight: 3.2,
        stackable: false,

        damage_min: 7,
        damage_max: 11,
        fire_rate: 9,
        mag_size: 20,
        reload_time: 80,
        bullet_speed: 8,
        accuracy_bonus: -0.05,
        light_enabled: true,
        light_color: make_color_rgb(255, 190, 80),
        light_radius: 20,
        light_intensity: 0.15,

        ammo_key: "ammo_9mm",
        ammo_per_attack: 1,

        weapon_sprite: spr_uzi,
        sound_shoot: nine_shot,
        sound_reload: nine_reload,
        sound_empty: nine_empty,
		
		weapon_offset_x: 14,
		weapon_draw_width: 30,
        hand1_x: 0,
        hand1_y: 0,
        hand2_x: 10,
        hand2_y: 3,
        has_second_hand: true,
		grid_height: 2,
		grid_width: 2,
        muzzle_x: 19,
        muzzle_y: 6,

        fire_modes: [WeaponFireMode.SEMI, WeaponFireMode.AUTO]
    };


    // ============================================================
    // CHEST ARMOR
    // ============================================================

    global.items.paca = {
        item_key: "paca",
        name: "PACA Soft Armor",
        category: ItemCategory.BODY_ARMOR,
        description: "A level 1 body armor that offers minimal protection.",
        base_value: 100,
        weight: 2.0,
        armor: 10,
		grid_width: 3,
		grid_height: 3,
        stackable: false,
        body_sprite: paca_torso,
		icon_sprite: spr_PACA
    };

    global.items.improvised_plate_vest = {
        item_key: "improvised_plate_vest",
        name: "Improvised Plate Vest",
        category: ItemCategory.BODY_ARMOR,
        description: "A crude armored vest reinforced with salvaged steel plates.",
        base_value: 275,
        weight: 6.0,
        armor: 20,
        stackable: false,
    };


    // ============================================================
    // HEAD ARMOR
    // ============================================================

    global.items.construction_helmet = {
        item_key: "construction_helmet",
        name: "Construction Helmet",
        category: ItemCategory.HEAD_ARMOR,
        description: "A plastic construction helmet offering limited protection.",
        base_value: 80,
        weight: 0.8,
        armor: 10,
        stackable: false,
        head_sprite: construction_helmet_head,
		icon_sprite: spr_conshelmet,
		grid_width: 2,
		grid_height: 2
    };

    global.items.improvised_steel_helmet = {
        item_key: "improvised_steel_helmet",
        name: "LSHZ Lightweight Helmet",
        category: ItemCategory.HEAD_ARMOR,
        description: "A crude helmet fabricated from salvaged steel.",
        base_value: 200,
        weight: 2.0,
        armor: 20,
        stackable: false,

        sprite_idle: -1,
        sprite_run: -1
    };


    // ============================================================
    // BAGS
    // ============================================================

    global.items.sling_bag = {
        item_key: "sling_bag",
        name: "Sling Bag",
        category: ItemCategory.BAG,
        description: "A small shoulder bag with limited storage space.",
        base_value: 100,
        weight: 0.8,
        stackable: false,
        bag_capacity: 8.0,
        grid_width: 3,
        grid_height: 3,
		icon_sprite: spr_sling_bag
    };

    global.items.school_backpack = {
        item_key: "school_backpack",
        name: "School Backpack",
        category: ItemCategory.BAG,
        description: "An ordinary backpack with enough room for a modest scavenging haul.",
        base_value: 180,
        weight: 1.2,
        stackable: false,
        bag_capacity: 14.0,
        grid_width: 4,
        grid_height: 4
    };

    global.items.small_hiking_pack = {
        item_key: "small_hiking_pack",
        name: "Small Hiking Pack",
        category: ItemCategory.BAG,
        description: "A durable hiking pack capable of carrying a substantial amount of salvage.",
        base_value: 300,
        weight: 1.8,
        stackable: false,
        bag_capacity: 20.0,
        grid_width: 5,
        grid_height: 5
    };


    // ============================================================
    // SECURE CONTAINERS
    // ============================================================

    global.items.small_container = {
        item_key: "small_container",
        name: "Small Container",
        category: ItemCategory.SECURE_CONTAINER,
        description: "A compact secure container that protects a small amount of loot.",
        base_value: 100,
        weight: 1.0,
        stackable: false,
        grid_width: 2,
        grid_height: 2,
        icon_sprite: spr_container1
    };


    // ============================================================
    // MEDICAL
    // ============================================================

    global.items.bandage = {
        item_key: "bandage",
        name: "Bandage",
        category: ItemCategory.MEDICAL,
        description: "A simple cloth bandage that stops light bleeding.",
        base_value: 35,
        weight: 0.2,
        stackable: false,
        combat_usable: true,
		icon_sprite: spr_bandage,
        treatment_effect: "light_bleed",
        treatment_duration: 1.5,
        medical_capacity: 2
    };

    global.items.tourniquet = {
        item_key: "tourniquet",
        name: "Tourniquet",
        category: ItemCategory.MEDICAL,
        description: "A field tourniquet that stops heavy bleeding.",
        base_value: 65,
        weight: 0.2,
        stackable: false,
        combat_usable: true,
        icon_sprite: spr_tourniquet,
        treatment_effect: "heavy_bleed",
        treatment_duration: 2,
        medical_capacity: 2
    };

    global.items.painkillers = {
        item_key: "painkillers",
        name: "Painkillers",
        category: ItemCategory.MEDICAL,
        description: "Suppresses injury penalties for 60 seconds.",
        base_value: 30,
        weight: 0.1,
        stackable: false,
        combat_usable: true,
		icon_sprite: spr_painkillers,
        treatment_effect: "painkillers",
        treatment_duration: 1,
        medical_capacity: 3
    };

    global.items.splint = {
        item_key: "splint",
        name: "Splint",
        category: ItemCategory.MEDICAL,
        description: "Stabilizes and repairs a fractured limb.",
        base_value: 75,
        weight: 0.5,
        stackable: false,
        combat_usable: true,
        icon_sprite: spr_splint,
        treatment_effect: "fracture",
        treatment_duration: 3,
        medical_capacity: 2
    };

    global.items.medkit = {
        item_key: "medkit",
        name: "IFAK",
        category: ItemCategory.MEDICAL,
        description: "Restores up to 10 HP to one global or limb health target.",
        base_value: 100,
        weight: 1,
        stackable: false,
        combat_usable: true,
        icon_sprite: spr_ifak,
        treatment_effect: "heal",
        treatment_duration: 3,
        medical_capacity: 100
    };

    global.items.surgical_kit = {
        item_key: "surgical_kit",
        name: "Surgical Kit",
        category: ItemCategory.MEDICAL,
        description: "Restores a blacked-out limb to 10 HP.",
        base_value: 180,
        weight: 1.5,
        stackable: false,
        combat_usable: true,
        icon_sprite: spr_surgicalkit,
        grid_width: 2,
        treatment_effect: "surgery",
        treatment_duration: 6,
        medical_capacity: 2
    };


    // ============================================================
    // FOOD AND DRINK
    // ============================================================

    global.items.canned_chicken = {
        item_key: "canned_chicken", name: "Canned Chicken", category: ItemCategory.CONSUMABLE,
        description: "Canned chicken packed for long-term storage.", base_value: 35, weight: 0.5,
        stackable: false, combat_usable: true, grid_width: 1, grid_height: 1,
        icon_sprite: spr_cannedchicken,
        use_duration: 5, max_servings: 1, consumable_animation: "eat",
        use_effects: [{ type: EffectType.ENERGY, amount: 50 }, { type: EffectType.HYDRATION, amount: -5 }]
    };

    global.items.canned_tuna = {
        item_key: "canned_tuna", name: "Canned Tuna", category: ItemCategory.CONSUMABLE,
        description: "A preserved tin of tuna.", base_value: 30, weight: 0.4,
        stackable: false, combat_usable: true, grid_width: 1, grid_height: 1,
        icon_sprite: spr_cannedtuna,
        use_duration: 5, max_servings: 1, consumable_animation: "eat",
        use_effects: [{ type: EffectType.ENERGY, amount: 45 }, { type: EffectType.HYDRATION, amount: -5 }]
    };

    global.items.canned_ravioli = {
        item_key: "canned_ravioli", name: "Canned Ravioli", category: ItemCategory.CONSUMABLE,
        description: "A filling can of ready-to-eat ravioli.", base_value: 40, weight: 0.6,
        stackable: false, combat_usable: true, grid_width: 1, grid_height: 1,
        icon_sprite: spr_cannedravioli,
        use_duration: 5, max_servings: 1, consumable_animation: "eat",
        use_effects: [{ type: EffectType.ENERGY, amount: 55 }, { type: EffectType.HYDRATION, amount: -3 }]
    };

    global.items.beef_jerky = {
        item_key: "beef_jerky", name: "Beef Jerky", category: ItemCategory.CONSUMABLE,
        description: "Dried beef split into several servings.", base_value: 55, weight: 0.3,
        stackable: false, combat_usable: true, grid_width: 2, grid_height: 2,
        icon_sprite: spr_beefjerky,
        use_duration: 2, max_servings: 3, consumable_animation: "eat",
        use_effects: [{ type: EffectType.ENERGY, amount: 20 }, { type: EffectType.HYDRATION, amount: -5 }]
    };

    global.items.snickers = {
        item_key: "snickers", name: "Snickers", category: ItemCategory.CONSUMABLE,
        description: "A sweet, calorie-dense chocolate bar.", base_value: 25, weight: 0.1,
        stackable: false, combat_usable: true, grid_width: 2, grid_height: 1,
        icon_sprite: spr_snickers,
        use_duration: 2, max_servings: 1, consumable_animation: "eat",
        use_effects: [{ type: EffectType.ENERGY, amount: 30 }, { type: EffectType.HYDRATION, amount: -15 }]
    };

    global.items.water_bottle = {
        item_key: "water_bottle", name: "Water Bottle", category: ItemCategory.CONSUMABLE,
        description: "A bottle containing three servings of water.", base_value: 30, weight: 0.8,
        stackable: false, combat_usable: true, grid_width: 1, grid_height: 2,
        icon_sprite: spr_waterbottle,
        use_duration: 2, max_servings: 3, consumable_animation: "drink",
        use_effects: [{ type: EffectType.ENERGY, amount: 0 }, { type: EffectType.HYDRATION, amount: 20 }]
    };

    global.items.fiji_water = {
        item_key: "fiji_water", name: "Fiji Water", category: ItemCategory.CONSUMABLE,
        description: "Premium bottled water with four servings.", base_value: 50, weight: 1.0,
        stackable: false, combat_usable: true, grid_width: 1, grid_height: 2,
        icon_sprite: spr_fiji,
        use_duration: 2, max_servings: 4, consumable_animation: "drink",
        use_effects: [{ type: EffectType.ENERGY, amount: 0 }, { type: EffectType.HYDRATION, amount: 20 }]
    };

    global.items.diet_coke = {
        item_key: "diet_coke", name: "Diet Coke", category: ItemCategory.CONSUMABLE,
        description: "A can of diet cola.", base_value: 20, weight: 0.4,
        stackable: false, combat_usable: true, grid_width: 1, grid_height: 1,
        icon_sprite: spr_dietcoke,
        use_duration: 2, max_servings: 1, consumable_animation: "drink",
        use_effects: [{ type: EffectType.ENERGY, amount: 5 }, { type: EffectType.HYDRATION, amount: 25 }]
    };

    global.items.red_bull = {
        item_key: "red_bull", name: "Red Bull", category: ItemCategory.CONSUMABLE,
        description: "A caffeinated energy drink.", base_value: 30, weight: 0.3,
        stackable: false, combat_usable: true, grid_width: 1, grid_height: 1,
        icon_sprite: spr_redbull,
        use_duration: 2, max_servings: 1, consumable_animation: "drink",
        use_effects: [{ type: EffectType.ENERGY, amount: 12 }, { type: EffectType.HYDRATION, amount: 20 }]
    };


    // ============================================================
    // CASH
    // ============================================================

    global.items.cash = {
        item_key: "cash",
        name: "Cash",
        category: ItemCategory.CURRENCY,
        description: "Physical currency used for trade.",
        base_value: 1,
        weight: 0,
        stackable: true,
		max_stack: 10000,
		icon_sprite: spr_cash
    };


    // ============================================================
    // OLD
    // ============================================================
    // Old / unused items are kept here so existing references do
    // not immediately break. These can be deleted later once all
    // old systems have been cleaned up.
    // ============================================================


    // ------------------------------------------------------------
    // OLD MATERIALS
    // ------------------------------------------------------------

    global.items.wires = {
        item_key: "wires",
        name: "Wires",
        category: ItemCategory.MATERIAL,
        description: "A bundle of electrical wiring useful for electronics and repairs.",
        base_value: 10,
        weight: 0.2,
        stackable: true
    };

    global.items.cloth_scraps = {
        item_key: "cloth_scraps",
        name: "Cloth Scraps",
        category: ItemCategory.MATERIAL,
        description: "Scraps of fabric useful for repairs, medical supplies, and crafting.",
        base_value: 6,
        weight: 0.2,
        stackable: true
    };

    global.items.steel_bar = {
        item_key: "steel_bar",
        name: "Steel Bar",
        category: ItemCategory.MATERIAL,
        description: "A solid bar of steel useful for heavy-duty crafting.",
        base_value: 25,
        weight: 1.5,
        stackable: true
    };

    global.items.light_bulb = {
        item_key: "light_bulb",
        name: "Light Bulb",
        category: ItemCategory.LAB_MATERIAL,
        description: "A common light bulb used for repairs and basic electrical projects.",
        base_value: 10,
        weight: 0.2,
        stackable: true
    };

    global.items.plastic_scrap = {
        item_key: "plastic_scrap",
        name: "Plastic Scrap",
        category: ItemCategory.LAB_MATERIAL,
        description: "Discarded plastic pieces useful for crafting and repairs.",
        base_value: 6,
        weight: 0.1,
        stackable: true
    };

    global.items.circuit_board = {
        item_key: "circuit_board",
        name: "Circuit Board",
        category: ItemCategory.MATERIAL,
        description: "A salvaged electronic circuit board containing reusable components.",
        base_value: 18,
        weight: 0.2,
        stackable: true,

        salvage: [
            { item_key: "wires", quantity: 1 },
            { item_key: "fuse", quantity: 1 }
        ]
    };

    global.items.metal_pipe = {
        item_key: "metal_pipe",
        name: "Metal Pipe",
        category: ItemCategory.MATERIAL,
        description: "A length of metal pipe that can be reused or broken down for scrap.",
        base_value: 15,
        weight: 1.2,
        stackable: true,

        salvage: [
            { item_key: "metal_scrap", quantity: 2 }
        ]
    };

    global.items.fuse = {
        item_key: "fuse",
        name: "Fuse",
        category: ItemCategory.MATERIAL,
        description: "An electrical fuse commonly recovered from old equipment.",
        base_value: 12,
        weight: 0.1,
        stackable: true,

        salvage: [
            { item_key: "wires", quantity: 1 }
        ]
    };

    global.items.metal_gear = {
        item_key: "metal_gear",
        name: "Metal Gear",
        category: ItemCategory.MATERIAL,
        description: "A heavy mechanical gear that can be broken down for scrap metal.",
        base_value: 18,
        weight: 0.8,
        stackable: true,

        salvage: [
            { item_key: "metal_scrap", quantity: 2 }
        ]
    };

    global.items.sheet_metal = {
        item_key: "sheet_metal",
        name: "Sheet Metal",
        category: ItemCategory.MATERIAL,
        description: "A sturdy sheet of metal useful for construction and fabrication.",
        base_value: 35,
        weight: 2.0,
        stackable: true,

        salvage: [
            { item_key: "metal_scrap", quantity: 2 },
            { item_key: "steel_bar", quantity: 1 }
        ]
    };

    global.items.metal_spring = {
        item_key: "metal_spring",
        name: "Metal Spring",
        category: ItemCategory.MATERIAL,
        description: "A heavy mechanical spring recovered from machinery.",
        base_value: 30,
        weight: 0.8,
        stackable: true,

        salvage: [
            { item_key: "metal_scrap", quantity: 1 },
            { item_key: "steel_bar", quantity: 1 }
        ]
    };


    // ------------------------------------------------------------
    // OLD DRUG / LAB SYSTEM
    // ------------------------------------------------------------

    global.items.raw_morrowleaf = {
        item_key: "raw_morrowleaf",
        name: "Raw Morrowleaf",
        category: ItemCategory.PRODUCT,
        description: "Freshly harvested Morrowleaf ready for sale or processing.",
        base_value: 30,
        weight: 0.6,
        stackable: true
    };


    // ------------------------------------------------------------
    // OLD BAGS
    // ------------------------------------------------------------

    global.items.patrol_pack = {
        item_key: "patrol_pack",
        name: "Patrol Pack",
        category: ItemCategory.BAG,
        description: "A compact field pack with enough room for a modest haul.",
        base_value: 350,
        weight: 1.4,
        stackable: false,
        bag_capacity: 14.0
    };

    global.items.scav_pack = {
        item_key: "scav_pack",
        name: "Scav Pack",
        category: ItemCategory.BAG,
        description: "A large improvised pack built for hauling salvage.",
        base_value: 700,
        weight: 2.2,
        stackable: false,
        bag_capacity: 22.0
    };

    global.items.hauler_pack = {
        item_key: "hauler_pack",
        name: "Hauler Pack",
        category: ItemCategory.BAG,
        description: "A reinforced heavy pack intended for serious scavenging runs.",
        base_value: 1400,
        weight: 3.2,
        stackable: false,
        bag_capacity: 32.0
    };


    // ------------------------------------------------------------
    // OLD ARMOR
    // ------------------------------------------------------------

    global.items.security_vest = {
        item_key: "security_vest",
        name: "Security Vest",
        category: ItemCategory.BODY_ARMOR,
        description: "A light vest used for security.",
        base_value: 100,
        weight: 5,
        stackable: false,
        sprite_idle: spr_security_vest_idle,
        sprite_run: -1
    };

    var item_keys = variable_struct_get_names(global.items);

    for (var i = 0; i < array_length(item_keys); i++)
    {
        var item = variable_struct_get(global.items, item_keys[i]);

        if (!variable_struct_exists(item, "grid_width")) item.grid_width = 1;
        if (!variable_struct_exists(item, "grid_height")) item.grid_height = 1;
        if (item.stackable && !variable_struct_exists(item, "max_stack")) item.max_stack = 100;
    }
}
