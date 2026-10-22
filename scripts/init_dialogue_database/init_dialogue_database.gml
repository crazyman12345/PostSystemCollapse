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
            dialogue_make_response("Have any quests for me?", "available:iron"),
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

    dialogue_register_node("mara_root_greeting", "Mara",
        "New channel, new face. I'm Mara. If the hideout needs something ordinary, I can usually find it.",
        [dialogue_make_response("Good to meet you.", "mara_root")]);
    dialogue_register_node("mara_onboarding", "Mara", "Good. You're awake. The Doc got you fixed up but you've been in a coma for a month.",
        [dialogue_make_response("...where am I?", "mara_onboarding_supplies")]);
    dialogue_register_node("mara_onboarding_supplies", "Mara",
        "You can stay here in the shack on the edge of town. There's a supply crate I left you by the bed. You're going to have to earn your keep if you want to stay in Junk City.",
        [dialogue_make_response("What do you mean?", "mara_onboarding_job")]);
    dialogue_register_node("mara_onboarding_job", "Mara",
        "Once you are up and around, there is an old store down the road with reported bandit activity. Investigate it and report back to me after.",
        [
            dialogue_make_response("Okay, I can check it out.", "mara_onboarding_accepted", undefined,
                { type: "accept_quest", key: "test_safe_return" }),
            dialogue_make_response("Who are you?", "mara_onboarding_identity"),
            dialogue_make_response("Not yet.", "", undefined, { type: "end" })
        ]);
    dialogue_register_node("mara_onboarding_identity", "Mara",
        "Mara. I keep people supplied here in Junk City. We don't trust outsiders. Maybe you can make yourself useful.",
        [dialogue_make_response("Back.", "mara_onboarding_job")]);
    dialogue_register_node("mara_onboarding_accepted", "Mara",
        "Then open the crate and gear up. I'll keep this channel open.",
        [dialogue_make_response("Understood.", "", undefined, { type: "end" })]);
    dialogue_register_node("mara_onboarding_reminder", "Mara",
        "Open the supply crate and gear up. The old store checkpoint is your objective.",
        [dialogue_make_response("Understood.", "", undefined, { type: "end" })]);
    dialogue_register_node("mara_onboarding_replacement", "Mara",
        "I replaced the essentials you lost. Gear up and try again.",
        [dialogue_make_response("Understood.", "", undefined, { type: "end" })]);
    dialogue_register_node("mara_first_quest_return", "Mara",
        "Wow, you actually made it back.",
        [dialogue_make_response("You sound surprised.", "mara_first_quest_reward")]);
    dialogue_register_node("mara_first_quest_reward", "Mara",
        "Here is your reward.\n\nREWARD: $150 + 30x 9MM AMMO\nTRADER ACCESS: MARA",
        [dialogue_make_response("Thanks.", "mara_useful_again_intro", undefined,
            { type: "turn_in_quest", key: "test_safe_return" })]);
    dialogue_register_node("mara_useful_again_intro", "Mara",
        "Now I need you to get the Salvage Bench working again. I'll provide the wood and hardware. You supply three pieces of Scrap Metal.",
        [dialogue_make_response("I'll get it working.", "mara_useful_again_accepted", undefined,
            { type: "accept_quest", key: "test_field_supplies" })]);
    dialogue_register_node("mara_useful_again_accepted", "Mara",
        "Good. I've sent over the repair materials. Once the bench is useful again, come find me.",
        [dialogue_make_response("Understood.", "", undefined,
            [
                { type: "end" },
                {
                    type: "tutorial",
                    message: "Go to the workshop tab and build the salvage table",
                    target_x: 24,
                    target_y: 480,
                    box_x: 430,
                    box_y: 290,
                    box_width: 650,
                    box_height: 140
                }
            ])]);
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
            dialogue_make_response("Have any quests for me?", "available:sawbones"),
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

    dialogue_register_node("clothman_root_greeting", "Clothman",
        "Clothman. Armor, packs, repairs. Everything between your skin and a bad decision.",
        [dialogue_make_response("I'll remember that.", "clothman_root")]);
    dialogue_register_node("clothman_root", "Clothman", "Need protection, work, or conversation?",
        [
            dialogue_make_response("Heard anything?", "clothman_rumor", { type: "level_unlocked", level: 2, value: false }),
            dialogue_make_response("Heard anything?", "clothman_rumor_sewers", { type: "level_unlocked", level: 2, value: true }),
            dialogue_make_response("Have any quests for me?", "available:bastion"),
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
            dialogue_make_response("Let me see your stock.", "", undefined, { type: "trade" }),
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
