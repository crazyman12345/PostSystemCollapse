function init_enemy_database()
{
    global.enemies = {};
    // ==============================
    // BASIC SCAVENGER
    // ==============================
    global.enemies.scavenger = {
        enemy_key : "scavenger",
        name : "Scavenger",
        max_hp : 40,
        accuracy : 0.65,
        damage_min : 12,
        damage_max : 24,
        loot_table_key : "scavenger_basic",
        boss : false,
        ascii : [
            "   .-.   ",
            "  /|_|\\  ",
            "   / \\  "
        ]
    };
    // ==============================
    // BLOCK ENFORCER
    // ==============================
    global.enemies.block_enforcer = {
        enemy_key : "block_enforcer",
        name : "Block Enforcer",
        max_hp : 100,
        accuracy : 0.65,
        damage_min : 10,
        damage_max : 18,
        loot_table_key : "block_enforcer",
        boss : true,
        ascii : [
            "   _____    ",
            "  | . . |   ",
            "  |  -  |   ",
            "  /|___|\   ",
            "    / \     "
        ]
    };
	global.enemies.prototype_scav =
	{
	    enemy_key: "prototype_scav",
	    name: "PROTO SCAV",
	    max_hp: 40,
	    accuracy: 0.45,
	    damage_min: 4,
	    damage_max: 8,
	    loot_table_key:
	        "prototype_residential",
	    boss: false,
	    ascii:
	    [
	        @"    O    ",
	        @"   /|\   ",
	        @"   / \   "
	    ]
	};
	global.enemies.prototype_boss =
	{
	    enemy_key: "prototype_boss",
	    name: "LEWIS",
	    max_hp: 90,
	    accuracy: 0.58,
	    damage_min: 7,
	    damage_max: 13,
	    loot_table_key:
	        "prototype_boss",
	    boss: true,
	    ascii:
	    [
	        @"     _____     ",
	        @"    /_____\    ",
	        @"      |O|      ",
	        @"    __/|\__    ",
	        @"      / \      "
	    ]
	};
	global.enemies.security_guard =
	{
	    name: "SECURITY GUARD",
		accuracy: 0.55,
	    max_hp: 40,
	    damage_min: 4,
	    damage_max: 8,
		loot_table_key:
	        "prototype_residential",
	    ascii: [
	        @"  [#]  ",
	        @" /|S|\ ",
	        @"  / \  " ]
	};
	global.enemies.raider =
	{
	    name: "RAIDER",
		accuracy: 0.7,
	    max_hp: 40,
	    damage_min: 8,
	    damage_max: 12,
		loot_table_key:
	        "prototype_residential",
	    ascii: [
	         @"  (x)  ",
	         @" /|#|\ ",
	         @"  / \  " ]
	};	
	
	//IDLE ENEMIES
	global.enemies.training_target = {
	    enemy_key: "training_target",
	    name: "Training Target",
	    level: 1,
	    max_hp: 20,
	    sprite: -1,
		attack_interval: 3,
		min_damage: 0,
		max_damage: 0,
		accuracy: 0
	};
	
	global.enemies.looter = {
	    enemy_key: "looter",
	    name: "Looter",
	    level: 2,
	    max_hp: 80,
	    sprite: -1
	};

	global.enemies.scavenger = {
	    enemy_key: "scavenger",
	    name: "Scavenger",
	    level: 6,
	    max_hp: 80,
	    sprite: -1
	};

	global.enemies.armed_looter = {
	    enemy_key: "armed_looter",
	    name: "Armed Looter",
	    level: 23,
	    max_hp: 200,
	    sprite: -1
	};

	global.enemies.store_raider = {
	    enemy_key: "store_raider",
	    name: "Store Raider",
	    level: 47,
	    max_hp: 280,
	    sprite: -1
	};
}