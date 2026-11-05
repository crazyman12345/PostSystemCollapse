function init_dialogue_database()
{
    global.dialogue_nodes = {};
    global.dialogue_roots = {
        iron: "gundlach_root",
        mara: "mara_root",
        sawbones: "sawbones_root",
        bastion: "clothman_root",
        ghost: "ghost_root"
    };
    dialogue_flags = {};

    dialogue_register_node("gundlach_root_greeting", "Gundlach",
        "I'm Gundlach. I sell guns, ammunition, and weapon parts.",
        [dialogue_make_response("Good to meet you.", "gundlach_root")]);
    dialogue_register_node("gundlach_root", "Gundlach", "What do you need?",
        [
            dialogue_make_response("Heard anything?", "gundlach_rumor", { type: "boss_defeated", key: "prototype_boss_dead", value: false }),
            dialogue_make_response("Heard anything?", "gundlach_rumor_after_bones", { type: "boss_defeated", key: "prototype_boss_dead", value: true }),
            dialogue_make_response("Have any work for me?", "available:iron"),
            dialogue_make_response("I finished what you asked.", "claim:iron", { type: "trader_quest_ready", key: "iron" }),
            dialogue_make_response("Let me see your stock.", "", undefined, { type: "trade" }),
            dialogue_make_response("Goodbye.", "", undefined, { type: "end" })
        ]);
    dialogue_register_node("gundlach_rumor", "Gundlach",
        "People near the old store have been buying more ammunition. Bones is probably the reason.",
        [dialogue_make_response("Back.", "gundlach_root")]);
    dialogue_register_node("gundlach_rumor_after_bones", "Gundlach",
        "Ammunition is still selling fast, even with Bones dead.",
        [dialogue_make_response("Back.", "gundlach_root")]);
    dialogue_register_node("gundlach_background", "Gundlach",
        "I repaired weapons before the collapse. I still do.",
        [dialogue_make_response("Back.", "gundlach_root")]);
    dialogue_register_node("gundlach_proof_load_offer", "Gundlach",
        "I need weapon parts from the old store. I can pay you for them.",
        [dialogue_make_response("What do you need?", "gundlach_proof_load_details")]);
    dialogue_register_node("gundlach_proof_load_details", "Gundlach",
        "Bring me one set of weapon parts and kill three enemies while you're there.",
        [
            dialogue_make_response("Show me the contract.", "", undefined,
                { type: "show_quest_offer", key: "gundlach_proof_load", next_node: "gundlach_root" }),
            dialogue_make_response("Maybe later.", "gundlach_root")
        ]);
    dialogue_register_node("gundlach_proof_load_complete", "Gundlach",
        "These parts are usable.",
        [dialogue_make_response("Good.", "gundlach_proof_load_reward")]);
    dialogue_register_node("gundlach_proof_load_reward", "Gundlach",
        "Here's your payment.",
        [dialogue_make_response("View rewards.", "", undefined,
            { type: "show_quest_claim", key: "gundlach_proof_load", next_node: "gundlach_root" })]);

    dialogue_register_node("mara_root_greeting", "Mara",
        "I'm Mara. I sell supplies and basic materials.",
        [dialogue_make_response("Good to meet you.", "mara_root")]);
    dialogue_register_node("ghost_onboarding", "Ghost", "You're awake.",
        [dialogue_make_response("Where am I?", "ghost_onboarding_supplies")]);
    dialogue_register_node("ghost_onboarding_supplies", "Ghost",
        "Junk City. You can use this place for now. There's a supply crate by the bed.",
        [dialogue_make_response("Why help me?", "ghost_onboarding_job")]);
    dialogue_register_node("ghost_onboarding_job", "Ghost",
        "I need three pieces of scrap metal from the old store. Reach the checkpoint and come back.",
        [
            dialogue_make_response("Show me the contract.", "", undefined,
                { type: "show_quest_offer", key: "test_safe_return", next_node: "ghost_onboarding_accepted" }),
            dialogue_make_response("Who are you?", "ghost_onboarding_identity"),
            dialogue_make_response("Not yet.", "", undefined, { type: "end" })
        ]);
    dialogue_register_node("ghost_onboarding_identity", "Ghost",
        "Call me Ghost. I buy and sell things that are hard to find.",
        [dialogue_make_response("Back.", "ghost_onboarding_job")]);
    dialogue_register_node("ghost_onboarding_accepted", "Ghost",
        "Open the crate and take what you need.",
        [dialogue_make_response("All right.", "", undefined, { type: "end" })]);
    dialogue_register_node("ghost_onboarding_reminder", "Ghost",
        "Open the crate, then go to the old store checkpoint.",
        [dialogue_make_response("All right.", "", undefined, { type: "end" })]);
    dialogue_register_node("ghost_onboarding_replacement", "Ghost",
        "I replaced the basic gear you lost.",
        [dialogue_make_response("Thanks.", "", undefined, { type: "end" })]);
    dialogue_register_node("ghost_first_quest_return", "Ghost",
        "You made it back.",
        [dialogue_make_response("I got the scrap.", "ghost_first_quest_reward")]);
    dialogue_register_node("ghost_first_quest_reward", "Ghost",
        "Good. I have your payment ready.",
        [dialogue_make_response("View rewards.", "", undefined,
            { type: "show_quest_claim", key: "test_safe_return", next_node: "ghost_useful_again_intro" })]);
    dialogue_register_node("ghost_useful_again_intro", "Ghost",
        "The Salvage Bench needs repairs. I'll provide most of the parts. You'll need three pieces of scrap metal.",
        [dialogue_make_response("Show me the contract.", "", undefined,
            { type: "show_quest_offer", key: "test_field_supplies", next_node: "ghost_useful_again_accepted" })]);
    dialogue_register_node("ghost_useful_again_accepted", "Ghost",
        "The materials are waiting. Repair the bench and use it to salvage the radio.",
        [dialogue_make_response("All right.", "", undefined,
            [
                { type: "end" },
                { type: "set_dialogue_flag", key: "field_supplies_tutorial_started", value: true },
                {
                    type: "tutorial",
                    message: "Go to your stash and bank your extracted loot",
                    target_x: 24,
                    target_y: onboarding_sidebar_callout_y(2),
                    box_x: 530,
                    box_y: 305,
                    box_width: 650,
                    box_height: 140
                }
            ])]);
    dialogue_register_node("ghost_useful_again_complete", "Ghost",
        "The bench is working.",
        [dialogue_make_response("Yes.", "ghost_useful_again_reward")]);
    dialogue_register_node("ghost_useful_again_reward", "Ghost",
        "Here's your payment. The other traders will speak with you now.",
        [dialogue_make_response("View rewards.", "", undefined,
            { type: "show_quest_claim", key: "test_field_supplies", next_node: "ghost_root" })]);
    dialogue_register_node("mara_root", "Mara", "What can I do for you?",
        [
            dialogue_make_response("Heard anything?", "mara_rumor", { type: "boss_defeated", key: "prototype_boss_dead", value: false }),
            dialogue_make_response("Heard anything?", "mara_rumor_after_bones", { type: "boss_defeated", key: "prototype_boss_dead", value: true }),
            dialogue_make_response("Have any quests for me?", "available:mara"),
            dialogue_make_response("I finished what you asked.", "claim:mara", { type: "trader_quest_ready", key: "mara" }),
            dialogue_make_response("Let me see your stock.", "", undefined, { type: "trade" }),
            dialogue_make_response("Goodbye.", "", undefined, { type: "end" })
        ]);
    dialogue_register_node("mara_rumor", "Mara",
        "There have been more people around the old store lately. Be careful there.",
        [dialogue_make_response("Back.", "mara_root")]);
    dialogue_register_node("mara_rumor_after_bones", "Mara",
        "People heard about Bones. The routes around the store are busier now.",
        [dialogue_make_response("Back.", "mara_root")]);
    dialogue_register_node("mara_background", "Mara",
        "I worked in warehouse supply before the collapse.",
        [dialogue_make_response("Back.", "mara_root")]);

    dialogue_register_node("sawbones_root_greeting", "Sawbones",
        "I'm Sawbones. I sell medical supplies and treat injuries.",
        [dialogue_make_response("Good to meet you.", "sawbones_root")]);
    dialogue_register_node("sawbones_root", "Sawbones", "What do you need?",
        [
            dialogue_make_response("Heard anything?", "sawbones_rumor", { type: "quest_completed", key: "test_safe_return", value: false }),
            dialogue_make_response("Heard anything?", "sawbones_rumor_safe", { type: "quest_completed", key: "test_safe_return", value: true }),
            dialogue_make_response("Have any work for me?", "available:sawbones"),
            dialogue_make_response("I finished what you asked.", "claim:sawbones", { type: "trader_quest_ready", key: "sawbones" }),
            dialogue_make_response("Heal my wounds.", "", { type: "treatment_needed" }, { type: "heal_wounds" }),
            dialogue_make_response("Let me see your stock.", "", undefined, { type: "trade" }),
            dialogue_make_response("Goodbye.", "", undefined, { type: "end" })
        ]);
    dialogue_register_node("sawbones_rumor", "Sawbones",
        "The checkpoint is safer than the rest of the store, but don't stay there too long.",
        [dialogue_make_response("Back.", "sawbones_root")]);
    dialogue_register_node("sawbones_rumor_safe", "Sawbones",
        "I heard you made it back from the checkpoint.",
        [dialogue_make_response("Back.", "sawbones_root")]);
    dialogue_register_node("sawbones_background", "Sawbones",
        "I was a field surgeon before the collapse.",
        [dialogue_make_response("Back.", "sawbones_root")]);
    dialogue_register_node("sawbones_clean_supply_offer", "Sawbones",
        "I'm running low on medical supplies.",
        [dialogue_make_response("What do you need?", "sawbones_clean_supply_details")]);
    dialogue_register_node("sawbones_clean_supply_details", "Sawbones",
        "The old store had a pharmacy. Bring back two medical supply packs.",
        [
            dialogue_make_response("Show me the contract.", "", undefined,
                { type: "show_quest_offer", key: "sawbones_clean_supply", next_node: "sawbones_root" }),
            dialogue_make_response("Not right now.", "sawbones_root")
        ]);
    dialogue_register_node("sawbones_clean_supply_complete", "Sawbones",
        "These will help.",
        [dialogue_make_response("Good.", "sawbones_clean_supply_reward")]);
    dialogue_register_node("sawbones_clean_supply_reward", "Sawbones",
        "Here's your payment.",
        [dialogue_make_response("View rewards.", "", undefined,
            { type: "show_quest_claim", key: "sawbones_clean_supply", next_node: "sawbones_root" })]);

    dialogue_register_node("clothman_root_greeting", "Clothman",
        "I'm Clothman. I sell armor, bags, and repair materials.",
        [dialogue_make_response("Good to meet you.", "clothman_root")]);
    dialogue_register_node("clothman_root", "Clothman", "What do you need?",
        [
            dialogue_make_response("Heard anything?", "clothman_rumor", { type: "level_unlocked", level: 2, value: false }),
            dialogue_make_response("Heard anything?", "clothman_rumor_sewers", { type: "level_unlocked", level: 2, value: true }),
            dialogue_make_response("Have any work for me?", "available:bastion"),
            dialogue_make_response("I finished what you asked.", "claim:bastion", { type: "trader_quest_ready", key: "bastion" }),
            dialogue_make_response("Let me see your stock.", "", undefined, { type: "trade" }),
            dialogue_make_response("Goodbye.", "", undefined, { type: "end" })
        ]);
    dialogue_register_node("clothman_rumor", "Clothman",
        "Check your armor and bag before you leave. Damaged straps are easy to miss.",
        [dialogue_make_response("Back.", "clothman_root")]);
    dialogue_register_node("clothman_rumor_sewers", "Clothman",
        "People going into the sewers have been asking for sealed bags and gloves.",
        [dialogue_make_response("Back.", "clothman_root")]);
    dialogue_register_node("clothman_background", "Clothman",
        "I learned tailoring from my mother. I started repairing armor later.",
        [dialogue_make_response("Back.", "clothman_root")]);
    dialogue_register_node("clothman_worth_carrying_offer", "Clothman",
        "I need cloth from the old store.",
        [dialogue_make_response("How much?", "clothman_worth_carrying_details")]);
    dialogue_register_node("clothman_worth_carrying_details", "Clothman",
        "Bring me three pieces in usable condition.",
        [
            dialogue_make_response("Show me the contract.", "", undefined,
                { type: "show_quest_offer", key: "clothman_worth_carrying", next_node: "clothman_root" }),
            dialogue_make_response("Maybe later.", "clothman_root")
        ]);
    dialogue_register_node("clothman_worth_carrying_complete", "Clothman",
        "This cloth is usable.",
        [dialogue_make_response("Good.", "clothman_worth_carrying_reward")]);
    dialogue_register_node("clothman_worth_carrying_reward", "Clothman",
        "Here's your payment.",
        [dialogue_make_response("View rewards.", "", undefined,
            { type: "show_quest_claim", key: "clothman_worth_carrying", next_node: "clothman_root" })]);

    dialogue_register_node("ghost_root_greeting", "Ghost",
        "Call me Ghost. I deal in weapons that are hard to find.",
        [dialogue_make_response("All right.", "ghost_root")]);
    dialogue_register_node("ghost_root", "Ghost", "What do you need?",
        [
            dialogue_make_response("Heard anything?", "ghost_rumor", { type: "boss_defeated", key: "prototype_boss_dead", value: false }),
            dialogue_make_response("Heard anything?", "ghost_rumor_after_bones", { type: "boss_defeated", key: "prototype_boss_dead", value: true }),
            dialogue_make_response("Have any quests for me?", "available:ghost"),
            dialogue_make_response("I finished what you asked.", "claim:ghost", { type: "trader_quest_ready", key: "ghost" }),
            dialogue_make_response("Show me what you've got.", "", { type: "quest_completed", key: "test_field_supplies", value: true }, { type: "trade" }),
            dialogue_make_response("Goodbye.", "", undefined, { type: "end" })
        ]);
    dialogue_register_node("ghost_rumor", "Ghost",
        "Bones controls the old store. He could become a problem for us.",
        [dialogue_make_response("Back.", "ghost_root")]);
    dialogue_register_node("ghost_rumor_after_bones", "Ghost",
        "Bones is dead. Someone else will probably take over the store soon.",
        [dialogue_make_response("Back.", "ghost_root")]);
    dialogue_register_node("ghost_background", "Ghost",
        "I find buyers and sellers. That's all you need to know.",
        [dialogue_make_response("Back.", "ghost_root")]);
}
