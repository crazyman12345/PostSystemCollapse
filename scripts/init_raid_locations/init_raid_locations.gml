function init_raid_locations()
{
	global.raid_locations = {};
	
	global.raid_locations.prototype_block =
	{
    location_key:
        "prototype_block",

    name:
        "Prototype Block",

    danger_level:
        0,

    description:
        "A test location used to validate raid systems.",

    start_junction:
        "entrance",

    junctions:
    {
		 entrance:
        {
            junction_key:
                "entrance",

            name:
                "Entrance",

            junction_type:
                JunctionType.ROOM,

            description:
                "The entrance to the abandoned block. The exit remains behind you.",

            ascii:
            [
                @" __________________ ",
                @"|                  |",
                @"|     ENTRANCE     |",
                @"|________  ________|",
                @"         ||         "
            ],
			
			map_x: 0,
			map_y: 0,
			connections: ["central_hall"],
            actions:
            [
                {
                    action_key:
                        "entrance_search_bag",

                    label:
                        "SEARCH ABANDONED BAG",

                    action_type:
                        RaidActionType.SEARCH,

                    duration:
                        3,

                    noise:
                        1,

                    loot_table_key:
                        "prototype_residential",

                    repeatable:
                        false,

                    requirements:
                        [],

                    effects:
                        []
                },


                {
                    action_key:
                        "entrance_go_hall",

                    label:
                        "ENTER CENTRAL HALL",

                    action_type:
                        RaidActionType.MOVE,

                    target:
                        "central_hall",

                    duration:
                        2,

                    noise:
                        0,

                    repeatable:
                        true,

                    requirements:
                        [],

                    effects:
                        []
                },


                {
                    action_key:
                        "entrance_extract",

                    label:
                        "EXTRACT",

                    action_type:
                        RaidActionType.EXTRACT,

                    duration:
                        3,

                    noise:
                        0,

                    repeatable:
                        true,

                    requirements:
                        [],

                    effects:
                        []
                }
            ]
        },
		 central_hall:
        {
            junction_key:
                "central_hall",

            name:
                "Central Hall",

            junction_type:
                JunctionType.HALLWAY,

            description:
                "Several paths branch from the ruined hallway.",
			map_x: 0,
			map_y: 1,
			connections: ["apartment", "clinic", "maintenance"],
            ascii:
            [
                @"|----|----------|----|",
                @"|APT |   HALL   |MED |",
                @"|----|-----+----|----|",
                @"           |          ",
                @"         MAINT        "
            ],

            actions:
            [
                {
                    action_key:
                        "hall_apartment",
                    label:
                        "ENTER APARTMENT",
                    action_type:
                        RaidActionType.MOVE,
                    target:
                        "apartment",
                    duration:
                        2,
                    noise:
                        0,
                    repeatable:
                        true,
                    requirements:
                        [],
                    effects:
                        []
                },
                {
                    action_key:
                        "hall_clinic",
                    label:
                        "ENTER CLINIC",
                    action_type:
                        RaidActionType.MOVE,
                    target:
                        "clinic",
                    duration:
                        2,
                    noise:
                        0,
                    repeatable:
                        true,
                    requirements:
                        [],
                    effects:
                        []
                },
                {
                    action_key:
                        "open_maintenance_door",
                    label:
                        "INSTALL FUSE AND OPEN DOOR",
                    action_type:
                        RaidActionType.MOVE,
                    target:
                        "maintenance",
                    duration:
                        2,
                    noise:
                        0,
                    repeatable:
                        true,
                    requirements:
                        [
						{
							type: RequirementType.ITEM,
							item_key: "fuse",
							quantity: 1
						}
						],

                    effects:
                        [
						{
							type: EffectType.REMOVE_ITEM,
							item_key: "fuse",
							quantity: 1
						}
						]
                },
                {
                    action_key:
                        "hall_return",

                    label:
                        "RETURN TO ENTRANCE",

                    action_type:
                        RaidActionType.MOVE,

                    target:
                        "entrance",

                    duration:
                        2,

                    noise:
                        0,

                    repeatable:
                        true,

                    requirements:
                        [],

                    effects:
                        []
                }
            ]
        },
		 apartment:
        {
            junction_key:
                "apartment",
            name:
                "Abandoned Apartment",
            junction_type:
                JunctionType.ROOM,
            description:
                "The apartment has already been picked through, but some containers remain.",
			map_x: -1,
			map_y: 1,
			connections: ["central_hall"],
            ascii:
            [
                @" ___________________ ",
                @"| BED      | DESK    |",
                @"|          |         |",
                @"|____   _____________|",
                @"     | |              "
            ],
            actions:
            [
                {
                    action_key:
                        "apartment_search_desk",
                    label:
                        "SEARCH DESK",
                    action_type:
                        RaidActionType.SEARCH,
                    duration:
                        4,
                    noise:
                        1,
                    loot_table_key:
                        "prototype_residential",
                    repeatable:
                        false,
                    requirements:
                        [],
                    effects:
                        []
                },
                {
                    action_key:
                        "apartment_search_closet",
                    label:
                        "SEARCH CLOSET",
                    action_type:
                        RaidActionType.SEARCH,
                    duration:
                        6,
                    noise:
                        2,
                    loot_table_key:
                        "prototype_residential",
                    repeatable:
                        false,
                    requirements:
                        [],
                    effects:
                        []
                },
                {
                    action_key:
                        "apartment_return",
                    label:
                        "RETURN TO HALL",
                    action_type:
                        RaidActionType.MOVE,
                    target:
                        "central_hall",
                    duration:
                        2,
                    noise:
                        0,
                    repeatable:
                        true,
                    requirements:
                        [],
                    effects:
                        []
                }
            ]
        },
		    clinic:
        {
            junction_key:
                "clinic",
            name:
                "Ruined Clinic",
            junction_type:
                JunctionType.REST,
            description:
                "The room is quiet. Medical cabinets line the wall.",
			map_x: 1,
			map_y: 1,
			connections: ["central_hall"],
            ascii:
            [
                @" __________________ ",
                @"|      +           |",
                @"|    CLINIC        |",
                @"|   [ ][ ][ ]      |",
                @"|__________________|"
            ],
            actions:
            [
                {
                    action_key:
                        "clinic_search",
                    label:
                        "SEARCH MEDICAL CABINET",
                    action_type:
                        RaidActionType.SEARCH,
                    duration:
                        5,
                    noise:
                        1,
                    loot_table_key:
                        "prototype_medical",
                    repeatable:
                        false,
                    requirements:
                        [],
                    effects:
                        []
                },
                {
                    action_key:
                        "clinic_rest",
                    label:
                        "REST",
                    action_type:
                        RaidActionType.REST,
                    duration:
                        5,
                    noise:
                        0,
                    repeatable:
                        true,
                    requirements:
                        [],
                    effects:
                        []
                },
                {
                    action_key:
                        "clinic_return",
                    label:
                        "RETURN TO HALL",
                    action_type:
                        RaidActionType.MOVE,
                    target:
                        "central_hall",
                    duration:
                        2,
                    noise:
                        0,
                    repeatable:
                        true,
                    requirements:
                        [],
                    effects:
                        []
                }
            ]
        },
		 maintenance:
        {
            junction_key:
                "maintenance",
            name:
                "Maintenance Room",
            junction_type:
                JunctionType.RESOURCE,
            description:
                "Tools and ruined machinery fill the cramped room.",
            ascii:
            [
                @" __________________ ",
                @"|  O==O   [###]    |",
                @"|   TOOLS / PARTS  |",
                @"|__________________|"
            ],
			map_x: 0,
			map_y: 2,
			connections: [ "central_hall", "security_room"],
            actions:
            [
                {
                    action_key:
                        "maintenance_search",
                    label:
                        "SEARCH MACHINERY",
                    action_type:
                        RaidActionType.SEARCH,
                    duration:
                        7,
                    noise:
                        3,
                    loot_table_key:
                        "prototype_industrial",
                    repeatable:
                        false,
                    requirements:
                        [],
                    effects:
                        []
                },
                {
                    action_key:
                        "maintenance_security",
                    label:
                        "ENTER SECURITY ROOM",
                    action_type:
                        RaidActionType.MOVE,
                    target:
                        "security_room",
                    duration:
                        3,
                    noise:
                        0,
                    repeatable:
                        true,
                    requirements:
                        [],
                    effects:
                        []
                },
                {
                    action_key:
                        "maintenance_return",
                    label:
                        "RETURN",
                    action_type:
                        RaidActionType.MOVE,
                    target:
                        "central_hall",
                    duration:
                        2,
                    noise:
                        0,
                    repeatable:
                        true,
                    requirements:
                        [],
                    effects:
                        []
                }
            ]
        },
		security_room:
        {
            junction_key:
                "security_room",
            name:
                "Security Room",
            junction_type:
                JunctionType.ROOM,
            description:
                "Someone is inside.",
            ascii:
            [
                @" __________________ ",
                @"|                  |",
                @"|       !!!        |",
                @"|    SECURITY      |",
                @"|__________________|"
            ],
			map_x: 0,
			map_y: 3,
			connections: ["maintenance", "restricted_hall"],
            actions:
            [
                {
                    action_key:
                        "security_fight",
                    label:
                        "ENGAGE SCAVENGER",
                    action_type:
                        RaidActionType.START_COMBAT,
                    enemy_key:
                        "prototype_scav",
                    duration:
                        1,
                    noise:
                        5,
                    repeatable:
                        false,
                    requirements:
                        [],
                    on_defeat_effects:
                        [
						{
							type: EffectType.SET_FLAG,
							flag_key: "prototype_security_cleared",
							value: true
						}
						]
                },
						{
			    action_key:
			        "security_continue",
			    label:
			        "ENTER RESTRICTED HALL",
			    action_type:
			        RaidActionType.MOVE,
			    target:
			        "restricted_hall",
			    duration:
			        2,
			    noise:
			        0,
			    repeatable:
			        true,
			    requirements:
			    [
			        {
			            type:
			                RequirementType.FLAG,
			            flag_key:
			                "prototype_security_cleared",
			            value:
			                true
			        }
			    ],
			    effects:
			        []
			}
            ]
        },
		  restricted_hall:
        {
            junction_key:
                "restricted_hall",
            name:
                "Restricted Hall",
            junction_type:
                JunctionType.HALLWAY,
            description:
                "A reinforced corridor leads deeper into the block.",
            ascii:
            [
                @"====================",
                @"   RESTRICTED AREA  ",
                @"===================="
            ],
			map_x: 1,
			map_y: 3,
			connections:["security_room", "boss_room"],
            actions:
            [
                {
                    action_key:
                        "restricted_terminal",
                    label:
                        "READ SECURITY TERMINAL",
                    action_type:
                        RaidActionType.EVENT,
                    duration:
                        3,
                    noise:
                        0,
                    repeatable:
                        false,
                    requirements:
                        [],
					event_text:
				    "SECURITY LOG:\n\n"
				    + "Unauthorized access detected.\n"
				    + "Maintenance sector lockdown active.",
                    effects:
                    [
                        {
                            type:
                                EffectType.SET_FLAG,
                            flag_key:
                                "prototype_terminal_read",
                            value:
                                true
                        }
                    ]
                },
                {
                    action_key:
                        "restricted_boss",
                    label:
                        "ENTER COMMAND ROOM",
                    action_type:
                        RaidActionType.MOVE,
                    target:
                        "boss_room",
                    duration:
                        3,
                    noise:
                        0,
                    repeatable:
                        true,
                    requirements:
                    [
                        {
                            type:
                                RequirementType.FLAG,
                            flag_key:
                                "prototype_terminal_read",
                            value:
                                true
                        }
                    ],
                    effects:
                        []
                },
            ]
        },
		boss_room:
        {
            junction_key:
                "boss_room",
            name:
                "Command Room",
            junction_type:
                JunctionType.BOSS,
            description:
                "The block's enforcer waits inside.",
            ascii:
            [
                @"####################",
                @"#                  #",
                @"#      BOSS        #",
                @"#                  #",
                @"####################"
            ],
			map_x: 2,
			map_y: 3,
			connections: ["restricted_hall", "rear_exit"],
            actions:
            [
                {
                    action_key:
                        "boss_fight",
                    label:
                        "FIGHT BLOCK ENFORCER",
                    action_type:
                        RaidActionType.START_COMBAT,
                    enemy_key:
                        "prototype_boss",
                    duration:
                        1,
                    noise:
                        10,
                    repeatable:
                        false,
                    requirements:
                        [],
                    effects:
                        [],
                    on_defeat_effects:
                    [
                        {
                            type:
                                EffectType.SET_FLAG,
                            flag_key:
                                "prototype_boss_dead",
                            value:
                                true
                        }
                    ]
                },
                {
                    action_key:
                        "boss_exit",
                    label:
                        "ENTER REAR EXIT",
                    action_type:
                        RaidActionType.MOVE,
                    target:
                        "rear_exit",
                    duration:
                        3,
                    noise:
                        0,
                    repeatable:
                        true,
                    requirements:
                    [
                        {
                            type:
                                RequirementType.FLAG,
                            flag_key:
                                "prototype_boss_dead",
                            value:
                                true
                        }
                    ],
                    effects:
                        []
                }
            ]
        },
		rear_exit:
        {
            junction_key:
                "rear_exit",
            name:
                "Rear Exit",
            junction_type:
                JunctionType.EXTRACT,
            description:
                "The way out is clear.",
			map_x: 3,
			map_y: 3,
			connections: ["boss_room"],
            actions:
            [
                {
                    action_key:
                        "rear_extract",
                    label:
                        "EXTRACT",
                    action_type:
                        RaidActionType.EXTRACT,
                    duration:
                        5,
                    noise:
                        0,
                    repeatable:
                        true,
                    requirements:
                    [
                        {
                            type:
                                RequirementType.FLAG,
                            flag_key:
                                "prototype_boss_dead",
                            value:
                                true
                        }
                    ],
                    effects:
                    [
                        {
                            type:
                                EffectType.SET_FLAG,
                            flag_key:
                                "prototype_raid_complete",
                            value:
                                true
                        }
                    ]
                }
            ]
        }
    }
};
	global.raid_locations.abandoned_warehouse = {
	   location_key: "abandoned_warehouse",
	   name: "Abandoned Warehouse",
		danger_level: 0,
		description: "An abandoned warehouse but you see a fire burning inside.",
		start_junction: "entrance",
		junctions: {
	    entrance: raid_room(
	        "entrance",
	        "Entrance to Warehouse",
	        "Two rusty metal doors are standing in front of you.",
	        0, 0,
	        ["reception"],
	        [
				raid_move("reception", "ENTER THE WAREHOUSE", 0.5, 1, true)
			]
	    ),
	    reception: raid_room(
	        "reception",
	        "Reception Lobby",
	        "A desk sits in front of you.",
	        0, 1,
	        ["entrance", "main_area"],
	        [
				raid_move("entrance", "Move back to entrance.", 0.5, 1, true),
				raid_move("main_area", "Proceed to the main room", 0.5, 1, true),
				raid_search("filing_cabinet", "Search the filing cabinet", "junction_basic", 0.5, 5, false),
				raid_combat("fight_scav", "!!FIGHT SCAVENGER!!", "scavenger")
			]
	    ),
	    main_area: raid_room(
	        "main_area",
	        "Main Warehouse Storage",
	        "Shelves are lined with pallets of boxes.",
	        0, 2,
	        ["reception", "hallway", "loading_dock"],
	        [
				raid_move("reception", "Move back to reception.", 0.5, 1, true),
				raid_move("hallway", "Enter the hallway", 0.5, 1, true),
				raid_move("loading_dock", "Enter the loading dock", 0.5, 1, true),
				raid_search("industrial_crate", "Search the large crate", "prototype_industrial", 0.5, 5, false),
				raid_combat("fight_scav", "!!FIGHT SCAVENGER!!", "scavenger")
			]
	    ),
	    loading_dock: raid_room(
	        "loading_dock",
	        "Loading Dock",
	        "An old loading dock lined with abandoned equipment.",
	        0, 3,
	        ["main_area", "rear_exit"],
	        [
				raid_move("main_area", "Move back to main room.", 0.5, 1, true),
				raid_search("industrial_palette", "Search the palettes", "prototype_industrial", 0.5, 5, false),
				raid_move("rear_exit", "An electronic door blocks the exit. Open?", 0.5, 1, true, [
					req_flag("warehouse_power")
				]),
			]
	    ),
	    rear_exit: raid_room(
	        "rear_exit",
	        "Rear Exit",
	        "The way out is clear.",
	        1, 3,
	        ["loading_dock"],
	        [
				raid_move("loading_dock", "Move back to the loading dock.", 0.5, 1, true),
				raid_room_extract("rear_exit", "EXTRACT from rear exit")
			]
	    ),
	    hallway: raid_room(
	        "hallway",
	        "Hallway",
	        "A long corridor.",
	        -1, 2,
	        ["main_area", "office", "hallway_2"],
	        [
				raid_move("main_area", "Move back to main room.", 0.5, 1, true),
				raid_move("office", "Enter the office", 0.5, 1, true),
				raid_move("hallway_2", "Move further down the hallway", 0.5, 1, true),
				raid_combat("fight_scav", "!!FIGHT SCAVENGER!!", "scavenger")
			]
	    ),
	    hallway_2: raid_room(
	        "hallway_2",
	        "Hallway",
	        "The corridor continues deeper into the offices.",
	        -1, 3,
	        ["hallway", "managers_office", "office_2"],
	        [
				raid_move("hallway", "Move back down the hallway", 0.5, 1, true),
				raid_move("office_2", "Enter the office", 0.5, 1, true),
				raid_move("managers_office", "'MANAGER'S OFFICE' Enter?", 0.5, 1, true),	
			]
	    ),
	    office: raid_room(
	        "office",
	        "Office",
	        "A ransacked room with blood on the walls.",
	        -2, 2,
	        ["hallway"],
	        [
				raid_move("hallway", "Go back into hallway", 0.5, 1, true),
				raid_search("filing_cabinet", "Search the filing cabinet", "junction_basic", 0.5, 5, false),
				raid_combat("fight_scav", "!!FIGHT SCAVENGER!!", "scavenger")
			]
	    ),
	    office_2: raid_room(
	        "office_2",
	        "Office",
	        "A ransacked room with blood on the walls.",
	        -2, 3,
	        ["hallway_2"],
	        [
				raid_move("hallway_2", "Go back into hallway", 0.5, 1, true),
				raid_search("filing_cabinet", "Search the filing cabinet", "junction_basic", 0.5, 5, false),
			]
	    ),
	    managers_office: raid_room(
	        "managers_office",
	        "Manager's Office",
	        "Motivational signs hang on the walls.",
	        -1, 4,
	        ["hallway_2"],
	        [
				raid_combat("fight_raider", "!!FIGHT RAIDER!!", "raider"),
				raid_move("hallway_2", "Go back into hallway", 0.5, 1, true),
				raid_search("desk", "Search the desk", "prototype_resedential", 0.5, 5, false),
				raid_event("terminal", "Interact with the computer on desk.", "Iniating power protocol. POWER RESTORED TO REAR EXIT.", 0.5, 1, false, [], [effect_flag("warehouse_power")])		
			]
	    )
	}
}
		
	
}