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
        "Gundlach. Firearms, ammunition, repairs. Keep your weapon clean and your messages shorter than your firefights.",
        [dialogue_make_response("Understood.", "gundlach_root")]);
    dialogue_register_node("gundlach_root", "Gundlach", "What are you looking for?",
        [
            dialogue_make_response("Heard anything?", "gundlach_rumor", { type: "boss_defeated", key: "prototype_boss_dead", value: false }),
            dialogue_make_response("Heard anything?", "gundlach_rumor_after_bones", { type: "boss_defeated", key: "prototype_boss_dead", value: true }),
            dialogue_make_response("Have any work for me?", "available:iron"),
            dialogue_make_response("About my current job...", "active:iron"),
            dialogue_make_response("I finished what you asked.", "claim:iron", { type: "trader_quest_ready", key: "iron" }),
            dialogue_make_response("Tell me about yourself.", "gundlach_background"),
            dialogue_make_response("Let me see your stock.", "", undefined, { type: "trade" }),
            dialogue_make_response("Goodbye.", "", undefined, { type: "end" })
        ]);
    dialogue_register_node("gundlach_rumor", "Gundlach",
        "Someone is buying ammunition in bulk near the old store. Either they're afraid of Bones, or they know what's coming after him.",
        [dialogue_make_response("Back.", "gundlach_root")]);
    dialogue_register_node("gundlach_rumor_after_bones", "Gundlach",
        "Bones is dead and ammunition prices are still climbing. That means the smart money expects another fight.",
        [dialogue_make_response("Back.", "gundlach_root")]);
    dialogue_register_node("gundlach_background", "Gundlach",
        "I maintained weapons before the collapse. Now I maintain the people carrying them, mostly by refusing to sell them garbage.",
        [dialogue_make_response("Back.", "gundlach_root")]);
    dialogue_register_node("gundlach_proof_load_offer", "Gundlach",
        "That pipe pistol of yours is barely a weapon. If you want something better, you're going to have to work for it.",
        [dialogue_make_response("What do you need?", "gundlach_proof_load_details")]);
    dialogue_register_node("gundlach_proof_load_details", "Gundlach",
        "Bring me some usable weapon parts from the store. And while you're out there, put a few of those bastards down. Three should do.",
        [
            dialogue_make_response("I'll do it.", "gundlach_root", undefined, { type: "accept_quest", key: "gundlach_proof_load" }),
            dialogue_make_response("Maybe later.", "gundlach_root")
        ]);
    dialogue_register_node("gundlach_proof_load_complete", "Gundlach",
        "Well, I'll be damned. You actually brought something useful.",
        [dialogue_make_response("Good enough?", "gundlach_proof_load_reward")]);
    dialogue_register_node("gundlach_proof_load_reward", "Gundlach",
        "Good enough. Here's your payment. Come back when you need something that shoots straight.",
        [dialogue_make_response("Take payment.", "gundlach_root", undefined,
            { type: "turn_in_quest", key: "gundlach_proof_load" })]);

    dialogue_register_node("mara_root_greeting", "Mara",
        "New channel, new face. I'm Mara. If the hideout needs something ordinary, I can usually find it.",
        [dialogue_make_response("Good to meet you.", "mara_root")]);
    dialogue_register_node("ghost_onboarding", "Ghost", "You're awake. Good. The doctor was starting to lose his wager.",
        [dialogue_make_response("...where am I?", "ghost_onboarding_supplies")]);
    dialogue_register_node("ghost_onboarding_supplies", "Ghost",
        "Junk City. The shack is yours until someone more dangerous objects. There's a supply crate by the bed. Start there.",
        [dialogue_make_response("Why help me?", "ghost_onboarding_job")]);
    dialogue_register_node("ghost_onboarding_job", "Ghost",
        "Help is an investment. Reach the old store checkpoint and bring back three pieces of Scrap Metal. Survive, and maybe you become useful.",
        [
            dialogue_make_response("I'll check it out.", "ghost_onboarding_accepted", undefined,
                { type: "accept_quest", key: "test_safe_return" }),
            dialogue_make_response("Who are you?", "ghost_onboarding_identity"),
            dialogue_make_response("Not yet.", "", undefined, { type: "end" })
        ]);
    dialogue_register_node("ghost_onboarding_identity", "Ghost",
        "Ghost. I connect desperate people with expensive solutions. Names beyond that are liabilities.",
        [dialogue_make_response("Back.", "ghost_onboarding_job")]);
    dialogue_register_node("ghost_onboarding_accepted", "Ghost",
        "Open the crate and gear up. Prove you can make yourself useful before we discuss better equipment.",
        [dialogue_make_response("Understood.", "", undefined, { type: "end" })]);
    dialogue_register_node("ghost_onboarding_reminder", "Ghost",
        "The crate first. Then the old store checkpoint. Try not to confuse confidence with preparation.",
        [dialogue_make_response("Understood.", "", undefined, { type: "end" })]);
    dialogue_register_node("ghost_onboarding_replacement", "Ghost",
        "I replaced the essentials you lost. Charity would be sentimental; consider this debt.",
        [dialogue_make_response("Understood.", "", undefined, { type: "end" })]);
    dialogue_register_node("ghost_first_quest_return", "Ghost",
        "You came back breathing. Low standard, but most people still miss it.",
        [dialogue_make_response("You sound surprised.", "ghost_first_quest_reward")]);
    dialogue_register_node("ghost_first_quest_reward", "Ghost",
        "Cynical, not surprised. Here's your payment.\n\nREWARD: $150 + 30x 9MM AMMO",
        [dialogue_make_response("Thanks.", "ghost_useful_again_intro", undefined,
            { type: "turn_in_quest", key: "test_safe_return" })]);
    dialogue_register_node("ghost_useful_again_intro", "Ghost",
        "Now get the Salvage Bench working. I'll send wood, hardware, and a Broken Radio. You supply three pieces of Scrap Metal.",
        [dialogue_make_response("I'll get it working.", "ghost_useful_again_accepted", undefined,
            { type: "accept_quest", key: "test_field_supplies" })]);
    dialogue_register_node("ghost_useful_again_accepted", "Ghost",
        "The materials are waiting. Repair the bench, salvage the radio, then report back. Even junk should earn its keep.",
        [dialogue_make_response("Understood.", "", undefined,
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
        "The Salvage Bench works. Good. Waste is just inventory nobody has priced correctly.",
        [dialogue_make_response("What's next?", "ghost_useful_again_reward")]);
    dialogue_register_node("ghost_useful_again_reward", "Ghost",
        "Take your payment. The others have decided you're worth acknowledging.",
        [dialogue_make_response("Take payment.", "ghost_root", undefined,
            { type: "turn_in_quest", key: "test_field_supplies" })]);
    dialogue_register_node("mara_root", "Mara", "What do you need?",
        [
            dialogue_make_response("Heard anything?", "mara_rumor", { type: "boss_defeated", key: "prototype_boss_dead", value: false }),
            dialogue_make_response("Heard anything?", "mara_rumor_after_bones", { type: "boss_defeated", key: "prototype_boss_dead", value: true }),
            dialogue_make_response("Have any quests for me?", "available:mara"),
            dialogue_make_response("About my current job...", "active:mara"),
            dialogue_make_response("I finished what you asked.", "claim:mara", { type: "trader_quest_ready", key: "mara" }),
            dialogue_make_response("Tell me about yourself.", "mara_background"),
            dialogue_make_response("Let me see your stock.", "", undefined, { type: "trade" }),
            dialogue_make_response("Goodbye.", "", undefined, { type: "end" })
        ]);
    dialogue_register_node("mara_rumor", "Mara",
        "Scavengers keep finding fresh tracks near the old store. Too deliberate for animals. Watch the blind corners.",
        [dialogue_make_response("Back.", "mara_root")]);
    dialogue_register_node("mara_rumor_after_bones", "Mara",
        "Word about Bones is spreading. The sewer routes are busier now; success attracts traders and predators alike.",
        [dialogue_make_response("Back.", "mara_root")]);
    dialogue_register_node("mara_background", "Mara",
        "I kept warehouses supplied before the collapse. The buildings changed, but the work didn't: know what people need before they ask.",
        [dialogue_make_response("Back.", "mara_root")]);

    dialogue_register_node("sawbones_root_greeting", "Sawbones",
        "Sawbones. Injuries persist after a raid unless you treat them or give them time to recover. I sell medical supplies, and I can patch you up when you return.",
        [dialogue_make_response("Understood.", "sawbones_root")]);
    dialogue_register_node("sawbones_root", "Sawbones", "Talk. I'm sorting sutures.",
        [
            dialogue_make_response("Heard anything?", "sawbones_rumor", { type: "quest_completed", key: "test_safe_return", value: false }),
            dialogue_make_response("Heard anything?", "sawbones_rumor_safe", { type: "quest_completed", key: "test_safe_return", value: true }),
            dialogue_make_response("Have any work for me?", "available:sawbones"),
            dialogue_make_response("About my current job...", "active:sawbones"),
            dialogue_make_response("I finished what you asked.", "claim:sawbones", { type: "trader_quest_ready", key: "sawbones" }),
            dialogue_make_response("Tell me about yourself.", "sawbones_background"),
            dialogue_make_response("Let me see your stock.", "", undefined, { type: "trade" }),
            dialogue_make_response("Goodbye.", "", undefined, { type: "end" })
        ]);
    dialogue_register_node("sawbones_rumor", "Sawbones",
        "The checkpoints aren't safe, merely safer. Reach one, breathe, and keep enough strength for the road home.",
        [dialogue_make_response("Back.", "sawbones_root")]);
    dialogue_register_node("sawbones_rumor_safe", "Sawbones",
        "People noticed you came back from that checkpoint in one piece. Try not to make them think that's easy.",
        [dialogue_make_response("Back.", "sawbones_root")]);
    dialogue_register_node("sawbones_background", "Sawbones",
        "Field surgeon, once. Now I'm a doctor, undertaker, and persistent critic of reckless scavengers.",
        [dialogue_make_response("Back.", "sawbones_root")]);
    dialogue_register_node("sawbones_clean_supply_offer", "Sawbones",
        "Running a little low on supplies. Turns out people keep getting shot, stabbed, and otherwise mangled.",
        [dialogue_make_response("What do you need?", "sawbones_clean_supply_details")]);
    dialogue_register_node("sawbones_clean_supply_details", "Sawbones",
        "The old store had a pharmacy. See if you can find anything useful. Preferably something that hasn't expired.",
        [
            dialogue_make_response("I'll look around.", "sawbones_root", undefined, { type: "accept_quest", key: "sawbones_clean_supply" }),
            dialogue_make_response("Not right now.", "sawbones_root")
        ]);
    dialogue_register_node("sawbones_clean_supply_complete", "Sawbones",
        "Not bad. Half of this is even usable.",
        [dialogue_make_response("Half?", "sawbones_clean_supply_reward")]);
    dialogue_register_node("sawbones_clean_supply_reward", "Sawbones",
        "That's better than I expected. Here's your payment.",
        [dialogue_make_response("Take payment.", "sawbones_root", undefined,
            { type: "turn_in_quest", key: "sawbones_clean_supply" })]);

    dialogue_register_node("clothman_root_greeting", "Clothman",
        "Clothman. Armor, packs, repairs. Everything between your skin and a bad decision.",
        [dialogue_make_response("I'll remember that.", "clothman_root")]);
    dialogue_register_node("clothman_root", "Clothman", "Need protection, work, or conversation?",
        [
            dialogue_make_response("Heard anything?", "clothman_rumor", { type: "level_unlocked", level: 2, value: false }),
            dialogue_make_response("Heard anything?", "clothman_rumor_sewers", { type: "level_unlocked", level: 2, value: true }),
            dialogue_make_response("Have any work for me?", "available:bastion"),
            dialogue_make_response("About my current job...", "active:bastion"),
            dialogue_make_response("I finished what you asked.", "claim:bastion", { type: "trader_quest_ready", key: "bastion" }),
            dialogue_make_response("Tell me about yourself.", "clothman_background"),
            dialogue_make_response("Let me see your stock.", "", undefined, { type: "trade" }),
            dialogue_make_response("Goodbye.", "", undefined, { type: "end" })
        ]);
    dialogue_register_node("clothman_rumor", "Clothman",
        "Most deaths begin with someone deciding a torn strap can survive one more raid. Inspect your gear.",
        [dialogue_make_response("Back.", "clothman_root")]);
    dialogue_register_node("clothman_rumor_sewers", "Clothman",
        "The sewer crews want sealed packs and thick gloves. Whatever opened down there, it isn't clean.",
        [dialogue_make_response("Back.", "clothman_root")]);
    dialogue_register_node("clothman_background", "Clothman",
        "I learned tailoring from my mother and armor repair from necessity. Clothman was a joke until everyone needed one.",
        [dialogue_make_response("Back.", "clothman_root")]);
    dialogue_register_node("clothman_worth_carrying_offer", "Clothman",
        "You know what the problem with scavengers is? They always bring back less than they could.",
        [dialogue_make_response("What's that supposed to mean?", "clothman_worth_carrying_details")]);
    dialogue_register_node("clothman_worth_carrying_details", "Clothman",
        "Means you need better equipment. Bring me some decent textiles from the store. I'll make it worth your time.",
        [
            dialogue_make_response("I'll find some.", "clothman_root", undefined, { type: "accept_quest", key: "clothman_worth_carrying" }),
            dialogue_make_response("Maybe later.", "clothman_root")
        ]);
    dialogue_register_node("clothman_worth_carrying_complete", "Clothman",
        "Now that's something I can work with.",
        [dialogue_make_response("What do I get?", "clothman_worth_carrying_reward")]);
    dialogue_register_node("clothman_worth_carrying_reward", "Clothman",
        "A little something to keep you alive. Try not to ruin it immediately.",
        [dialogue_make_response("Take payment.", "clothman_root", undefined,
            { type: "turn_in_quest", key: "clothman_worth_carrying" })]);

    dialogue_register_node("ghost_root_greeting", "Ghost",
        "Encrypted enough for today. Call me Ghost. Don't ask where the goods come from unless you want the answer to cost extra.",
        [dialogue_make_response("Fair enough.", "ghost_root")]);
    dialogue_register_node("ghost_root", "Ghost", "The channel is clean. For now.",
        [
            dialogue_make_response("Heard anything?", "ghost_rumor", { type: "boss_defeated", key: "prototype_boss_dead", value: false }),
            dialogue_make_response("Heard anything?", "ghost_rumor_after_bones", { type: "boss_defeated", key: "prototype_boss_dead", value: true }),
            dialogue_make_response("Have any quests for me?", "available:ghost"),
            dialogue_make_response("About my current job...", "active:ghost"),
            dialogue_make_response("I finished what you asked.", "claim:ghost", { type: "trader_quest_ready", key: "ghost" }),
            dialogue_make_response("Tell me about yourself.", "ghost_background"),
            dialogue_make_response("Show me what you've got.", "", { type: "quest_completed", key: "test_field_supplies", value: true }, { type: "trade" }),
            dialogue_make_response("Goodbye.", "", undefined, { type: "end" })
        ]);
    dialogue_register_node("ghost_rumor", "Ghost",
        "A name keeps surfacing on dead frequencies: Bones. Find the source before the source finds this place.",
        [dialogue_make_response("Back.", "ghost_root")]);
    dialogue_register_node("ghost_rumor_after_bones", "Ghost",
        "Bones went quiet. Good work. Unfortunately, someone has already started buying the silence he left behind.",
        [dialogue_make_response("Back.", "ghost_root")]);
    dialogue_register_node("ghost_background", "Ghost",
        "Backgrounds are leverage. Mine stays blank. What matters is that I know who has what, and who shouldn't.",
        [dialogue_make_response("Back.", "ghost_root")]);
}
