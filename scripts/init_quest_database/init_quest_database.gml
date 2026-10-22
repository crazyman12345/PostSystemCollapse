function init_quest_database()
{
    quest_definitions = [
        {
            key: "test_first_blood",
            title: "FIRST BLOOD [TEST]",
            trader_key: "mara",
            description: "Mara wants the nearby stalkers thinned out.",
            prerequisites: ["test_field_supplies"],
            objectives: [
                { type: QuestObjectiveType.KILL_ENEMY, target: RaidEnemyType.KNIFE_STALKER, amount: 3, text: "ELIMINATE STALKERS", requires_extraction: false }
            ],
            rewards: { cash: 100, items: [], flags: ["quest_first_blood_complete"] }
        },
        {
            key: "test_field_supplies",
            title: "USEFUL AGAIN",
            trader_key: "mara",
            description: "Repair the Salvage Bench. Mara will provide the wood and hardware; you need to supply three pieces of Scrap Metal.",
            prerequisites: ["test_safe_return"],
            objectives: [
                { type: QuestObjectiveType.REPAIR_BENCH, target: "salvage_bench", amount: 1, text: "REPAIR THE SALVAGE BENCH", requires_extraction: false }
            ],
            start_items: [
                { item_key: "wood", quantity: 4 },
                { item_key: "screws", quantity: 4 },
                { item_key: "bolts", quantity: 2 }
            ],
            rewards: { cash: 150, items: [{ item_key: "bandage", quantity: 1 }], flags: ["quest_field_supplies_complete"] }
        },
        {
            key: "test_safe_return",
            title: "COME BACK BREATHING",
            trader_key: "mara",
            description: "Mara wants you to reach a checkpoint in the Abandoned Store and return alive.",
            prerequisites: [],
            objectives: [
                { type: QuestObjectiveType.VISIT_LOCATION, target: "CHECKPOINT", amount: 1, text: "REACH A CHECKPOINT", requires_extraction: false },
                { type: QuestObjectiveType.EXTRACT_LEVEL, target: "ABANDONED STORE", amount: 1, text: "EXTRACT FROM ABANDONED STORE", requires_extraction: true }
            ],
            rewards: { cash: 150, items: [{ item_key: "ammo_9mm", quantity: 30 }], flags: ["quest_safe_return_complete"] }
        },
        {
            key: "test_bones_bounty",
            title: "BONES BOUNTY [TEST]",
            trader_key: "ghost",
            description: "Defeat Bones when the prototype boss encounter is active.",
            prerequisites: ["test_field_supplies"],
            objectives: [
                { type: QuestObjectiveType.DEFEAT_BOSS, target: RaidEnemyType.BONES, amount: 1, text: "DEFEAT BONES", requires_extraction: false }
            ],
            rewards: { cash: 500, items: [], flags: ["quest_bones_bounty_complete"] }
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
