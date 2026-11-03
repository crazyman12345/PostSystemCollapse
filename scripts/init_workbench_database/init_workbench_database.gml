function init_workbench_database()
{
    workshop_db = {

        // ============================================================
        // SALVAGE BENCH
        // ============================================================

        salvage_bench: {
            name: "SALVAGE BENCH",
            description: "Break down scavenged junk into useful materials.",
            sprite: spr_salvage_bench, //spr_salvage_bench,
            function_name: "SALVAGE",
            max_level: 4,
            level_unlocks: [
                "Basic material recovery",
                "Improved salvage yields",
                "Advanced component recovery",
                "Maximum salvage efficiency"
            ],

            upgrade_requirements: [
                [
                    workshop_req("metal_scrap", 3),
                    workshop_req("wood", 4),
                    workshop_req("screws", 4),
                    workshop_req("bolts", 2)
                ],
                [
                    workshop_req("metal_scrap", 5),
                    workshop_req("wood", 5),
                    workshop_req("screws", 5),
                    workshop_req("bolts", 4),
                    workshop_req("mechanical_parts", 1)
                ],
                [
                    workshop_req("metal_scrap", 8),
                    workshop_req("screws", 6),
                    workshop_req("bolts", 6),
                    workshop_req("mechanical_parts", 3),
                    workshop_req("electronics", 2)
                ],
                [
                    workshop_req("metal_scrap", 10),
                    workshop_req("mechanical_parts", 5),
                    workshop_req("electronics", 4),
                    workshop_req("precision_parts", 2)
                ]
            ]
        },


        // ============================================================
        // WEAPON WORKBENCH
        // ============================================================

        workbench: {
            name: "WEAPON WORKBENCH",
            description: "Craft and modify firearms and weapon components.",
            sprite: spr_weapon_workbench, //spr_workbench,
            function_name: "CRAFTING",
            max_level: 4,
            level_unlocks: [
                "Basic firearm crafting",
                "Advanced firearm crafting",
                "Precision weapon crafting",
                "Masterwork weapon crafting"
            ],

            upgrade_requirements: [
                [
                    workshop_req("metal_scrap", 5),
                    workshop_req("screws", 3),
                    workshop_req("bolts", 2),
                    workshop_req("springs", 1),
                    workshop_req("weapon_parts", 1)
                ],
                [
                    workshop_req("metal_scrap", 7),
                    workshop_req("screws", 5),
                    workshop_req("springs", 3),
                    workshop_req("weapon_parts", 3),
                    workshop_req("mechanical_parts", 2)
                ],
                [
                    workshop_req("weapon_parts", 5),
                    workshop_req("springs", 4),
                    workshop_req("mechanical_parts", 4),
                    workshop_req("precision_parts", 2),
                    workshop_req("electronics", 2)
                ],
                [
                    workshop_req("weapon_parts", 6),
                    workshop_req("mechanical_parts", 5),
                    workshop_req("precision_parts", 4),
                    workshop_req("electronics", 3),
                    workshop_req("rare_weapon_parts", 2)
                ]
            ]
        },


        // ============================================================
        // DRUG STATION
        // ============================================================

        drug_station: {
            name: "DRUG STATION",
            description: "Produce and process illicit substances.",
            sprite: spr_drugtable,
            function_name: "PRODUCTION",
            max_level: 4,
            level_unlocks: [
                "Basic drug production",
                "Improved chemical processing",
                "Advanced compound production",
                "High-grade drug production"
            ],

            upgrade_requirements: [
                [
                    workshop_req("metal_scrap", 3),
                    workshop_req("wood", 2),
                    workshop_req("plastic", 2),
                    workshop_req("screws", 2),
                    workshop_req("chemicals", 1),
                    workshop_req("alcohol", 1)
                ],
                [
                    workshop_req("chemicals", 3),
                    workshop_req("alcohol", 3),
                    workshop_req("plastic", 4),
                    workshop_req("screws", 3),
                    workshop_req("medical_supplies", 2)
                ],
                [
                    workshop_req("chemicals", 5),
                    workshop_req("alcohol", 4),
                    workshop_req("plastic", 5),
                    workshop_req("electronics", 2),
                    workshop_req("medical_supplies", 3)
                ],
                [
                    workshop_req("chemicals", 7),
                    workshop_req("alcohol", 5),
                    workshop_req("electronics", 4),
                    workshop_req("precision_parts", 2),
                    workshop_req("medical_supplies", 5)
                ]
            ]
        },


        // ============================================================
        // MEDICAL STATION
        // ============================================================

        medical_station: {
            name: "MEDICAL STATION",
            description: "Produce medical supplies and field treatments.",
            sprite: spr_medical_bench,
            function_name: "CRAFTING",
            max_level: 4,
            level_unlocks: [
                "Basic medical crafting",
                "Improved field treatments",
                "Advanced medical supplies",
                "Surgical treatment crafting"
            ],

            upgrade_requirements: [
                [
                    workshop_req("metal_scrap", 3),
                    workshop_req("wood", 2),
                    workshop_req("screws", 2),
                    workshop_req("medical_supplies", 1),
                    workshop_req("alcohol", 1)
                ],
                [
                    workshop_req("medical_supplies", 3),
                    workshop_req("alcohol", 3),
                    workshop_req("cloth", 4),
                    workshop_req("plastic", 2),
                    workshop_req("adhesive", 2)
                ],
                [
                    workshop_req("medical_supplies", 5),
                    workshop_req("alcohol", 4),
                    workshop_req("chemicals", 3),
                    workshop_req("electronics", 2),
                    workshop_req("cloth", 6)
                ],
                [
                    workshop_req("medical_supplies", 8),
                    workshop_req("alcohol", 6),
                    workshop_req("chemicals", 5),
                    workshop_req("electronics", 4),
                    workshop_req("precision_parts", 2)
                ]
            ]
        },


        // ============================================================
        // ARMOR BENCH
        // ============================================================

        armor_bench: {
            name: "ARMOR BENCH",
            description: "Craft armor, protective equipment and bags.",
            sprite: spr_armor_workbench,
            function_name: "CRAFTING",
            max_level: 4,
            level_unlocks: [
                "Basic armor crafting",
                "Reinforced equipment crafting",
                "Advanced protective gear",
                "High-grade armor crafting"
            ],

            upgrade_requirements: [
                [
                    workshop_req("metal_scrap", 4),
                    workshop_req("cloth", 4),
                    workshop_req("leather", 2),
                    workshop_req("bolts", 2),
                    workshop_req("adhesive", 1)
                ],
                [
                    workshop_req("metal_scrap", 6),
                    workshop_req("cloth", 6),
                    workshop_req("leather", 4),
                    workshop_req("bolts", 4),
                    workshop_req("adhesive", 3)
                ],
                [
                    workshop_req("steel_plate", 3),
                    workshop_req("cloth", 8),
                    workshop_req("leather", 6),
                    workshop_req("adhesive", 4),
                    workshop_req("mechanical_parts", 2)
                ],
                [
                    workshop_req("steel_plate", 5),
                    workshop_req("cloth", 10),
                    workshop_req("adhesive", 6),
                    workshop_req("precision_parts", 2),
                    workshop_req("electronics", 2)
                ]
            ]
        }
    };


    workshop_keys = [
        "salvage_bench",
        "workbench",
        "drug_station",
        "medical_station",
        "armor_bench"
    ];


    workshop_progress = {
        salvage_bench: 0,
        workbench: 0,
        drug_station: 0,
        medical_station: 0,
        armor_bench: 0
    };
}
