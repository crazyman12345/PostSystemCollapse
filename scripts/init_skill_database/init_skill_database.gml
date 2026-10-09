function init_skill_database(){
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
	    },
			  salvaging:
	    {
	        name: "SALVAGING",
	        description: "Improves the ability to break down items."
	    }
	};
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
		"scavenging",
		"salvaging"
		
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
		
		salvaging:
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
