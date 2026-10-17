function init_skill_database(){
	skill_xp_awards =
	{
		marksmanship_shot: 1,
		marksmanship_reload: 2,
		marksmanship_kill: 5,
		vitality_damage: 5,
		vitality_heal: 5,
		athleticism_move: 1,
		athleticism_move_distance: 300,
		athleticism_dash: 3,
		strength_knife_hit: 1,
		strength_carry_distance: 300,
		scavenging_container: 5,
		scavenging_trade: 2,
		scavenging_scrap: 5
	};

	skill_db =
	{
		drugmaking:
	    {
	        name: "DRUGMAKING",
	        description: "Improves drug production and unlocks recipes."
	    },

	    gunmaking:
	    {
	        name: "GUNMAKING",
	        description: "Improves firearm crafting and modification."
	    },

	    medical_crafting:
	    {
	        name: "MEDICAL CRAFTING",
	        description: "Improves medical item crafting."
	    },

	    armorcrafting:
	    {
	        name: "ARMORCRAFTING",
	        description: "Improves armor and bag crafting."
	    },

	    marksmanship:
	    {
	        name: "MARKSMANSHIP",
	        description: "Improves combat effectiveness with firearms."
	    },

	    vitality:
	    {
	        name: "VITALITY",
	        description: "Improves survivability in raids."
	    },
	    athleticism:
	    {
	        name: "ATHLETICISM",
	        description: "Improves the player's athletic ability."
	    },
		scavenging:
		{
			name: "SCAVENGING",
			description: "Improves searching speed."
		},
	    medical:
	    {
	        name: "MEDICAL",
	        description: "Improves the effectiveness of medical actions."
	    },
		strength:
	    {
	        name: "STRENGTH",
	        description: "Improves the player's strength."
	    }
	};
	skill_nodes =
	{
		marksmanship:
		[
			{
				key: "marksmanship_info",
				name: "Marksmanship",
				description: "Gain XP by firing weapons, reloading, and killing enemies.",
				icon: -1,
				required_level: 1,
				lane: 0,
				unlock_type: SkillNodeUnlockType.INFO,
				prerequisites: []
			},
			{
				key: "lethal_aim",
				name: "LETHAL AIM I",
				description: "Increases gun damage by 5%.",
				icon: -1,
				required_level: 5,
				lane: -1,
				unlock_type: SkillNodeUnlockType.LEVEL,
				prerequisites: ["marksmanship_info"]
			},
			{
				key: "quick_hands_1",
				name: "QUICK HANDS I",
				description: "Increases reload speed by 5%.",
				icon: -1,
				required_level: 5,
				lane: 0,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 250,
				prerequisites: ["marksmanship_info"]
			}
		],
		vitality:
		[
			{
				key: "vitality_info",
				name: "Vitality",
				description: "Gain XP by taking damage and healing.",
				icon: -1,
				required_level: 1,
				lane: 0,
				unlock_type: SkillNodeUnlockType.INFO,
				prerequisites: []
			},
			{
				key: "thick_skin",
				name: "THICK SKIN",
				description: "Increases maximum health by 10.",
				icon: -1,
				required_level: 5,
				lane: 0,
				unlock_type: SkillNodeUnlockType.LEVEL,
				prerequisites: ["vitality_info"]
			}
		],
		athleticism:
		[
			{
				key: "athleticism_info",
				name: "Athleticism",
				description: "Gain XP by moving and dashing.",
				icon: -1,
				required_level: 1,
				lane: 0,
				unlock_type: SkillNodeUnlockType.INFO,
				prerequisites: []
			},
			{
				key: "conditioning",
				name: "CONDITIONING I",
				description: "Increases movement speed by 2.5%.",
				icon: -1,
				required_level: 5,
				lane: 0,
				unlock_type: SkillNodeUnlockType.LEVEL,
				prerequisites: ["athleticism_info"]
			}
		],
		strength:
		[
			{
				key: "strength_info",
				name: "Strength",
				description: "Gain XP through strength-related actions such as carrying heavy loads.",
				icon: -1,
				required_level: 1,
				lane: 0,
				unlock_type: SkillNodeUnlockType.INFO,
				prerequisites: []
			},
			{
				key: "strong_legs_1",
				name: "STRONG LEGS I",
				description: "Increases maximum carry weight by 2 kg.",
				icon: -1,
				required_level: 5,
				lane: 0,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 250,
				prerequisites: ["strength_info"]
			},
			{
				key: "strong_legs_2",
				name: "STRONG LEGS II",
				description: "Increases maximum carry weight by 2 kg.",
				icon: -1,
				required_level: 10,
				lane: 0,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 500,
				prerequisites: ["strong_legs_1"]
			},
			{
				key: "strong_legs_3",
				name: "STRONG LEGS III",
				description: "Increases maximum carry weight by 2 kg.",
				icon: -1,
				required_level: 15,
				lane: 0,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 750,
				prerequisites: ["strong_legs_2"]
			},
			{
				key: "strong_legs_4",
				name: "STRONG LEGS IV",
				description: "Increases maximum carry weight by 2 kg.",
				icon: -1,
				required_level: 20,
				lane: 0,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 1000,
				prerequisites: ["strong_legs_3"]
			},
			{
				key: "strong_legs_5",
				name: "STRONG LEGS V",
				description: "Increases maximum carry weight by 2 kg.",
				icon: -1,
				required_level: 30,
				lane: 0,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 1500,
				prerequisites: ["strong_legs_4"]
			},
			{
				key: "strong_legs_6",
				name: "STRONG LEGS VI",
				description: "Increases maximum carry weight by 2 kg.",
				icon: -1,
				required_level: 40,
				lane: 0,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 2250,
				prerequisites: ["strong_legs_5"]
			},
			{
				key: "strong_legs_7",
				name: "STRONG LEGS VII",
				description: "Increases maximum carry weight by 2 kg.",
				icon: -1,
				required_level: 50,
				lane: 0,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 3250,
				prerequisites: ["strong_legs_6"]
			},
			{
				key: "strong_legs_8",
				name: "STRONG LEGS VIII",
				description: "Increases maximum carry weight by 2 kg.",
				icon: -1,
				required_level: 65,
				lane: 0,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 4500,
				prerequisites: ["strong_legs_7"]
			},
			{
				key: "strong_legs_9",
				name: "STRONG LEGS IX",
				description: "Increases maximum carry weight by 2 kg.",
				icon: -1,
				required_level: 80,
				lane: 0,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 6000,
				prerequisites: ["strong_legs_8"]
			},
			{
				key: "strong_legs_10",
				name: "STRONG LEGS X",
				description: "Increases maximum carry weight by 2 kg.",
				icon: -1,
				required_level: 100,
				lane: 0,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 8000,
				prerequisites: ["strong_legs_9"]
			}
		],
		scavenging:
		[
			{
				key: "scavenging_info",
				name: "Scavenging",
				description: "Gain XP by looting containers, scrapping items, and buying or selling with traders.",
				icon: -1,
				required_level: 1,
				lane: 0,
				unlock_type: SkillNodeUnlockType.INFO,
				prerequisites: []
			},
			{
				key: "lucky_looter",
				name: "LUCKY LOOTER",
				description: "Increases loot quantities by 5%.",
				icon: -1,
				required_level: 5,
				lane: -1,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 250,
				prerequisites: ["scavenging_info"]
			},
			{
				key: "lucky_looter_2",
				name: "LUCKY LOOTER II",
				description: "Increases loot quantities by an additional 5%.",
				icon: -1,
				required_level: 10,
				lane: -1,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 500,
				prerequisites: ["lucky_looter"]
			},
			{
				key: "charisma",
				name: "CHARISMA",
				description: "Improves trader buy and sell prices by 5%.",
				icon: -1,
				required_level: 5,
				lane: 0,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 250,
				prerequisites: ["scavenging_info"]
			},
			{
				key: "charisma_2",
				name: "CHARISMA II",
				description: "Improves trader buy and sell prices by an additional 5%.",
				icon: -1,
				required_level: 10,
				lane: 0,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 500,
				prerequisites: ["charisma"]
			},
			{
				key: "salvage_tech",
				name: "SALVAGE TECH",
				description: "Increases materials gained from salvaging by 10%.",
				icon: -1,
				required_level: 5,
				lane: 1,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 250,
				prerequisites: ["scavenging_info"]
			},
			{
				key: "salvage_tech_2",
				name: "SALVAGE TECH II",
				description: "Increases materials gained from salvaging by an additional 10%.",
				icon: -1,
				required_level: 10,
				lane: 1,
				unlock_type: SkillNodeUnlockType.MONEY,
				cost: 500,
				prerequisites: ["salvage_tech"]
			}
		],
		gunmaking:
		[
			{
				key: "gunmaking_info",
				name: "Gunmaking",
				description: "Gain XP by crafting weapons and related items.",
				icon: -1,
				required_level: 1,
				lane: 0,
				unlock_type: SkillNodeUnlockType.INFO,
				prerequisites: []
			}
		],
		armorcrafting:
		[
			{
				key: "armorcrafting_info",
				name: "Armorcrafting",
				description: "Gain XP by crafting armor and related equipment.",
				icon: -1,
				required_level: 1,
				lane: 0,
				unlock_type: SkillNodeUnlockType.INFO,
				prerequisites: []
			}
		],
		medical_crafting:
		[
			{
				key: "medical_crafting_info",
				name: "Medical Crafting",
				description: "Gain XP by crafting medical items.",
				icon: -1,
				required_level: 1,
				lane: 0,
				unlock_type: SkillNodeUnlockType.INFO,
				prerequisites: []
			}
		],
		drugmaking:
		[
			{
				key: "drugmaking_info",
				name: "Drugmaking",
				description: "Gain XP through drugmaking activities.",
				icon: -1,
				required_level: 1,
				lane: 0,
				unlock_type: SkillNodeUnlockType.INFO,
				prerequisites: []
			}
		]
	};
	skill_node_unlocks = { marksmanship: {}, athleticism: {}, strength: {}, scavenging: {} };
	player_skill_keys =
    [
        "drugmaking",
        "gunmaking",
        "medical_crafting",
        "armorcrafting",
		"marksmanship",
		"vitality",
		"athleticism",
		"strength",
		"scavenging"
		
    ];
	player_skills =
	{

	    drugmaking:
	    {
	        level: 1,
	        xp: 0
	    },

	    gunmaking:
	    {
	        level: 1,
	        xp: 0
	    },

	    medical_crafting:
	    {
	        level: 1,
	        xp: 0
	    },

	    armorcrafting:
	    {
	        level: 1,
	        xp: 0
	    },
		
		scavenging:
	    {
	        level: 1,
	        xp: 0
	    },
		marksmanship:
	    {
	        level: 1,
	        xp: 0
	    },
		vitality:
	    {
	        level: 1,
	        xp: 0
	    },
		athleticism:
	    {
	        level: 1,
	        xp: 0
	    },
		strength:
	    {
	        level: 1,
	        xp: 0
	    }
	};
}

function skill_node_get_nodes(_skill_key)
{
	if (!variable_struct_exists(skill_nodes, _skill_key)) return [];
	return variable_struct_get(skill_nodes, _skill_key);
}

function skill_node_find(_nodes, _node_key)
{
	for (var i = 0; i < array_length(_nodes); i++)
	{
		if (_nodes[i].key == _node_key) return _nodes[i];
	}
	return undefined;
}

function skill_node_is_unlocked(_skill_key, _node)
{
	if (_node.unlock_type == SkillNodeUnlockType.INFO) return true;

	if (_node.unlock_type == SkillNodeUnlockType.LEVEL)
		return skill_get_level(_skill_key) >= _node.required_level;

	if (!variable_struct_exists(skill_node_unlocks, _skill_key)) return false;
	var unlocks = variable_struct_get(skill_node_unlocks, _skill_key);
	return variable_struct_exists(unlocks, _node.key) && variable_struct_get(unlocks, _node.key);
}

function skill_node_prerequisites_met(_skill_key, _node)
{
	var nodes = skill_node_get_nodes(_skill_key);
	for (var i = 0; i < array_length(_node.prerequisites); i++)
	{
		var prerequisite = skill_node_find(nodes, _node.prerequisites[i]);
		if (is_undefined(prerequisite) || !skill_node_is_unlocked(_skill_key, prerequisite)) return false;
	}
	return true;
}

function skill_node_can_purchase(_skill_key, _node)
{
	return _node.unlock_type == SkillNodeUnlockType.MONEY
		&& !skill_node_is_unlocked(_skill_key, _node)
		&& skill_get_level(_skill_key) >= _node.required_level
		&& skill_node_prerequisites_met(_skill_key, _node);
}

function skill_node_purchase(_skill_key, _node)
{
	if (!skill_node_can_purchase(_skill_key, _node) || !spend_cash(_node.cost)) return false;

	if (!variable_struct_exists(skill_node_unlocks, _skill_key))
		variable_struct_set(skill_node_unlocks, _skill_key, {});
	var unlocks = variable_struct_get(skill_node_unlocks, _skill_key);
	variable_struct_set(unlocks, _node.key, true);
	save_mark_dirty();
	return true;
}
