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
                    workshop_req("metal_scrap", 5),
                    workshop_req("screws", 3),
                    workshop_req("bolts", 2),
                    workshop_req("springs", 1),
                    workshop_req("weapon_parts", 1)
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
            sprite: spr_drugtable,
            function_name: "PRODUCTION",
            max_level: 3,

            upgrade_requirements: [
                [
                    workshop_req("metal_scrap", 3),
                    workshop_req("wood", 2),
                    workshop_req("plastic", 2),
                    workshop_req("screws", 2),
                    workshop_req("chemicals", 1),
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
            sprite: spr_medical_bench,
            function_name: "CRAFTING",
            max_level: 3,

            upgrade_requirements: [
                [
                    workshop_req("metal_scrap", 3),
                    workshop_req("wood", 2),
                    workshop_req("screws", 2),
                    workshop_req("medical_supplies", 1),
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
            sprite: spr_armor_workbench,
            function_name: "CRAFTING",
            max_level: 3,

            upgrade_requirements: [
                [
                    workshop_req("metal_scrap", 4),
                    workshop_req("cloth", 4),
                    workshop_req("leather", 2),
                    workshop_req("bolts", 2),
                    workshop_req("adhesive", 1)
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
