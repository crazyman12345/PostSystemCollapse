function init_quest_database()
{
    quest_definitions = [
        {
            key: "gundlach_proof_load",
            title: "WEAPON PARTS",
            trader_key: "gundlach",
            description: "Bring Gundlach one set of Weapon Parts from the Abandoned Store and kill three enemies.",
            prerequisites: ["test_field_supplies"],
            objectives: [
                { type: QuestObjectiveType.KILL_ENEMY, target: "ABANDONED STORE", amount: 3, text: "ELIMINATE ENEMIES IN THE ABANDONED STORE", requires_extraction: false },
                { type: QuestObjectiveType.COLLECT_ITEM, target: "weapon_parts", amount: 1, text: "OBTAIN WEAPON PARTS", requires_extraction: false },
                { type: QuestObjectiveType.EXTRACT_WITH_ITEM, target: "weapon_parts", amount: 1, text: "EXTRACT WITH WEAPON PARTS", requires_extraction: true }
            ],
            delivery_items: [{ item_key: "weapon_parts", quantity: 1 }],
            guaranteed_item: { item_key: "weapon_parts", quantity: 1 },
            offer_node: "gundlach_proof_load_offer",
            completion_node: "gundlach_proof_load_complete",
            active_message: "Bring me the Weapon Parts and kill three enemies at the store.",
            rewards: { cash: 175, items: [{ item_key: "ammo_9mm", quantity: 30 }, { item_key: "springs", quantity: 2 }], flags: [] }
        },
        {
            key: "test_field_supplies",
            title: "REPAIR THE BENCH",
            trader_key: "ghost",
            description: "Repair the Salvage Bench and use it to salvage Ghost's Broken Radio.",
            prerequisites: ["test_safe_return"],
            objectives: [
                { type: QuestObjectiveType.REPAIR_BENCH, target: "salvage_bench", amount: 1, text: "REPAIR THE SALVAGE BENCH", requires_extraction: false },
                { type: QuestObjectiveType.SALVAGE_ITEM, target: "broken_radio", amount: 1, text: "SALVAGE THE BROKEN RADIO", requires_extraction: false }
            ],
            start_items: [
                { item_key: "wood", quantity: 4 },
                { item_key: "screws", quantity: 4 },
                { item_key: "bolts", quantity: 2 },
                { item_key: "broken_radio", quantity: 1 }
            ],
            completion_node: "ghost_useful_again_complete",
            reputation: 0,
            rewards: { cash: 150, items: [{ item_key: "bandage", quantity: 1 }], flags: ["quest_field_supplies_complete"] }
        },
        {
            key: "test_safe_return",
            title: "FIRST RUN",
            trader_key: "ghost",
            description: "Reach the checkpoint in the Abandoned Store and bring back three pieces of Scrap Metal.",
            prerequisites: [],
            objectives: [
                { type: QuestObjectiveType.COLLECT_ITEM, target: "metal_scrap", amount: 3, text: "FIND SCRAP METAL", requires_extraction: false },
                { type: QuestObjectiveType.EXTRACT_LEVEL, target: "ABANDONED STORE", amount: 1, text: "CLEAR 2 ROOMS AND EXTRACT", requires_extraction: true }
            ],
            reputation: 0,
            rewards: { cash: 150, items: [{ item_key: "ammo_9mm", quantity: 30 }], flags: ["quest_safe_return_complete"] }
        },
        {
            key: "mara_clear_routes",
            title: "CLEAR THE STORE",
            trader_key: "mara",
            description: "Kill five enemies in the Abandoned Store for Mara.",
            prerequisites: ["test_field_supplies"],
            objectives: [
                { type: QuestObjectiveType.KILL_ENEMY, target: "ABANDONED STORE", amount: 5, text: "ELIMINATE ENEMIES IN THE ABANDONED STORE", requires_extraction: false }
            ],
            rewards: { cash: 150, items: [{ item_key: "metal_scrap", quantity: 3 }], flags: [] }
        },
        {
            key: "sawbones_clean_supply",
            title: "MEDICAL SUPPLIES",
            trader_key: "sawbones",
            description: "Bring Sawbones two Medical Supply packs from the Abandoned Store.",
            prerequisites: ["test_field_supplies"],
            objectives: [
                { type: QuestObjectiveType.COLLECT_ITEM, target: "medical_supplies", amount: 2, text: "FIND MEDICAL SUPPLIES", requires_extraction: false },
                { type: QuestObjectiveType.EXTRACT_WITH_ITEM, target: "medical_supplies", amount: 2, text: "EXTRACT WITH MEDICAL SUPPLIES", requires_extraction: true }
            ],
            delivery_items: [{ item_key: "medical_supplies", quantity: 2 }],
            guaranteed_item: { item_key: "medical_supplies", quantity: 2 },
            offer_node: "sawbones_clean_supply_offer",
            completion_node: "sawbones_clean_supply_complete",
            active_message: "Bring me two Medical Supply packs from the old pharmacy.",
            rewards: { cash: 150, items: [{ item_key: "bandage", quantity: 2 }, { item_key: "painkillers", quantity: 1 }], flags: [] }
        },
        {
            key: "clothman_worth_carrying",
            title: "CLOTH SUPPLY",
            trader_key: "clothman",
            description: "Bring Clothman three pieces of Cloth from the Abandoned Store.",
            prerequisites: ["test_field_supplies"],
            objectives: [
                { type: QuestObjectiveType.COLLECT_ITEM, target: "cloth", amount: 3, text: "FIND CLOTH", requires_extraction: false },
                { type: QuestObjectiveType.EXTRACT_WITH_ITEM, target: "cloth", amount: 3, text: "EXTRACT WITH CLOTH", requires_extraction: true }
            ],
            delivery_items: [{ item_key: "cloth", quantity: 3 }],
            guaranteed_item: { item_key: "cloth", quantity: 3 },
            offer_node: "clothman_worth_carrying_offer",
            completion_node: "clothman_worth_carrying_complete",
            active_message: "Bring me three pieces of Cloth from the Abandoned Store.",
            rewards: { cash: 200, items: [], flags: [] }
        },
        {
            key: "ghost_bones_bounty",
            title: "KILL BONES",
            trader_key: "ghost",
            description: "Kill Bones at the Abandoned Store for Ghost.",
            prerequisites: ["test_field_supplies"],
            objectives: [
                { type: QuestObjectiveType.DEFEAT_BOSS, target: RaidEnemyType.BONES, amount: 1, text: "DEFEAT BONES", requires_extraction: false }
            ],
            rewards: { cash: 300, items: [], flags: ["quest_bones_bounty_complete"] }
        }
    ];

    quest_progress = {};
    for (var i = 0; i < array_length(quest_definitions); i++)
    {
        var definition = quest_definitions[i];
        var objective_progress = array_create(array_length(definition.objectives), 0);
        variable_struct_set(quest_progress, definition.key, {
            state: QuestState.LOCKED,
            objectives: objective_progress,
            reward_claimed: false
        });
    }

    tracked_quest_key = "";
    quest_overlay_index = 0;
    quest_overlay_scroll = 0;
    quest_overlay_quests = [];
    quest_tracker_expanded_remaining = 0;
    quest_raid_begin();
    quest_refresh_states();
}
