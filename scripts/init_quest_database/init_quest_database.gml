function init_quest_database()
{
    quest_definitions = [
        {
            key: "gundlach_proof_load",
            title: "PROOF LOAD",
            trader_key: "gundlach",
            description: "Recover usable Weapon Parts from the Abandoned Store and eliminate three enemies while you are there.",
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
            active_message: "You still owe me Weapon Parts and three bodies from the Abandoned Store. Extract with the parts intact.",
            rewards: { cash: 175, items: [{ item_key: "ammo_9mm", quantity: 30 }, { item_key: "springs", quantity: 2 }], flags: [] }
        },
        {
            key: "test_field_supplies",
            title: "USEFUL AGAIN",
            trader_key: "mara",
            description: "Repair the Salvage Bench, then use it to salvage the Broken Radio Mara provided. She will provide the wood and hardware; you need to supply three pieces of Scrap Metal.",
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
            completion_node: "mara_useful_again_complete",
            rewards: { cash: 150, items: [{ item_key: "bandage", quantity: 1 }], flags: ["quest_field_supplies_complete"] }
        },
        {
            key: "test_safe_return",
            title: "COME BACK BREATHING",
            trader_key: "mara",
            description: "Mara wants you to reach a checkpoint in the Abandoned Store, recover three pieces of Scrap Metal, and return alive.",
            prerequisites: [],
            objectives: [
                { type: QuestObjectiveType.VISIT_LOCATION, target: "CHECKPOINT", amount: 1, text: "REACH A CHECKPOINT", requires_extraction: false },
                { type: QuestObjectiveType.COLLECT_ITEM, target: "metal_scrap", amount: 3, text: "FIND SCRAP METAL", requires_extraction: false },
                { type: QuestObjectiveType.EXTRACT_LEVEL, target: "ABANDONED STORE", amount: 1, text: "EXTRACT FROM ABANDONED STORE", requires_extraction: true }
            ],
            rewards: { cash: 150, items: [{ item_key: "ammo_9mm", quantity: 30 }], flags: ["quest_safe_return_complete"] }
        },
        {
            key: "sawbones_clean_supply",
            title: "CLEAN SUPPLY",
            trader_key: "sawbones",
            description: "Recover usable Medical Supplies from the pharmacy in the Abandoned Store and bring them back intact.",
            prerequisites: ["test_field_supplies"],
            objectives: [
                { type: QuestObjectiveType.COLLECT_ITEM, target: "medical_supplies", amount: 2, text: "FIND MEDICAL SUPPLIES", requires_extraction: false },
                { type: QuestObjectiveType.EXTRACT_WITH_ITEM, target: "medical_supplies", amount: 2, text: "EXTRACT WITH MEDICAL SUPPLIES", requires_extraction: true }
            ],
            delivery_items: [{ item_key: "medical_supplies", quantity: 2 }],
            guaranteed_item: { item_key: "medical_supplies", quantity: 2 },
            offer_node: "sawbones_clean_supply_offer",
            completion_node: "sawbones_clean_supply_complete",
            active_message: "The pharmacy supplies are still out there. Bring back two units in usable condition.",
            rewards: { cash: 150, items: [{ item_key: "bandage", quantity: 2 }, { item_key: "painkillers", quantity: 1 }], flags: [] }
        },
        {
            key: "clothman_worth_carrying",
            title: "WORTH CARRYING",
            trader_key: "clothman",
            description: "Recover decent Cloth from the Abandoned Store and bring it back to Clothman intact.",
            prerequisites: ["test_field_supplies"],
            objectives: [
                { type: QuestObjectiveType.COLLECT_ITEM, target: "cloth", amount: 3, text: "FIND CLOTH", requires_extraction: false },
                { type: QuestObjectiveType.EXTRACT_WITH_ITEM, target: "cloth", amount: 3, text: "EXTRACT WITH CLOTH", requires_extraction: true }
            ],
            delivery_items: [{ item_key: "cloth", quantity: 3 }],
            guaranteed_item: { item_key: "cloth", quantity: 3 },
            offer_node: "clothman_worth_carrying_offer",
            completion_node: "clothman_worth_carrying_complete",
            active_message: "I need three pieces of decent Cloth from the Abandoned Store. Don't come back with shreds.",
            rewards: { cash: 200, items: [], flags: [] }
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
