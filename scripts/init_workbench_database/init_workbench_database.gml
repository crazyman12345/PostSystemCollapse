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
            max_level: 3,

            upgrade_requirements: [
                [
                    workshop_req("metal_scrap", 3),
                    workshop_req("wood", 4),
                    workshop_req("screws", 4),
                    workshop_req("bolts", 2)
                ],
                [],
                []
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
            max_level: 3,

            upgrade_requirements: [
                [
                    workshop_req("metal_scrap", 12),
                    workshop_req("screws", 6),
                    workshop_req("bolts", 4),
                    workshop_req("springs", 2),
                    workshop_req("weapon_parts", 2)
                ],
                [],
                []
            ]
        },


        // ============================================================
        // DRUG STATION
        // ============================================================

        drug_station: {
            name: "DRUG STATION",
            description: "Produce and process illicit substances.",
            sprite: -1, //spr_drug_station,
            function_name: "PRODUCTION",
            max_level: 3,

            upgrade_requirements: [
                [
                    workshop_req("metal_scrap", 6),
                    workshop_req("wood", 4),
                    workshop_req("plastic", 4),
                    workshop_req("screws", 3),
                    workshop_req("chemicals", 2),
                    workshop_req("alcohol", 1)
                ],
                [],
                []
            ]
        },


        // ============================================================
        // MEDICAL STATION
        // ============================================================

        medical_station: {
            name: "MEDICAL STATION",
            description: "Produce medical supplies and field treatments.",
            sprite: -1, //spr_medical_station,
            function_name: "CRAFTING",
            max_level: 3,

            upgrade_requirements: [
                [
                    workshop_req("metal_scrap", 6),
                    workshop_req("wood", 4),
                    workshop_req("screws", 4),
                    workshop_req("medical_supplies", 2),
                    workshop_req("alcohol", 1)
                ],
                [],
                []
            ]
        },


        // ============================================================
        // ARMOR BENCH
        // ============================================================

        armor_bench: {
            name: "ARMOR BENCH",
            description: "Craft armor, protective equipment and bags.",
            sprite: -1, //spr_armor_bench,
            function_name: "CRAFTING",
            max_level: 3,

            upgrade_requirements: [
                [
                    workshop_req("metal_scrap", 10),
                    workshop_req("cloth", 8),
                    workshop_req("leather", 4),
                    workshop_req("bolts", 4),
                    workshop_req("adhesive", 2)
                ],
                [],
                []
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
