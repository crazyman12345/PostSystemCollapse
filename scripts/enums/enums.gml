function enums(){
	enum GameState
	{
	    MAIN_MENU,
	    HIDEOUT,
		RAID
	}
	//hideout
	enum HideoutPage
	{
	    TRADERS,
	    STASH,
	    SALVAGE,
	    GUNMAKING,
	    ARMORCRAFTING,
	    DRUG_LAB,
	    MEDICAL_CRAFTING,
	    RAIDS,
	    WORKSHOP,
		SKILLS
	}
	hideout_focus = HideoutFocus.SIDEBAR;
	hideout_page = HideoutPage.TRADERS;
	hideout_menu_index = 0;
	hideout_menu_items = [
	
	    { name: "TRADERS", key: "traders", page: HideoutPage.TRADERS, header: "", skill_key: "", bench_key: "" },
	    { name: "STASH", key: "stash", page: HideoutPage.STASH, header: "", skill_key: "", bench_key: "" },
		{ name: "SKILLS", key: "skills", page: HideoutPage.SKILLS, header: "", skill_key: "", bench_key: "" },

		{ name: "SALVAGE", key: "salvaging", page: HideoutPage.SALVAGE, header: "CRAFTING", skill_key: "scavenging", bench_key: "salvage_bench" },
	    { name: "GUNMAKING", key: "gunmaking", page: HideoutPage.GUNMAKING, header: "", skill_key: "gunmaking", bench_key: "workbench" },
	    { name: "ARMORCRAFTING", key: "armorcrafting", page: HideoutPage.ARMORCRAFTING, header: "", skill_key: "armorcrafting", bench_key: "armor_bench" },
	    { name: "MEDICAL CRAFTING", key: "medical_crafting", page: HideoutPage.MEDICAL_CRAFTING, header: "", skill_key: "medical_crafting", bench_key: "medical_station" },
		{ name: "DRUGMAKING", key: "drugmaking", page: HideoutPage.DRUG_LAB, header: "", skill_key: "drugmaking", bench_key: "drug_station" },
		{ name: "WORKSHOP", key: "workshop", page: HideoutPage.WORKSHOP, header: "", skill_key: "", bench_key: "" },
		 
	    { name: "START RAID!", key: "raids", page: HideoutPage.RAIDS, header: "", skill_key: "", bench_key: "" },
	   
	];
	enum HideoutFocus{
		SIDEBAR,
		CONTENT
	}
	enum SkillNodeUnlockType
	{
		LEVEL,
		MONEY,
		INFO
	}
	enum TraderMode{
		BUY,
		SELECT,
		SELL
	}

	enum ItemCategory
	{
	    MATERIAL,
	    LAB_MATERIAL,
	    PRODUCT,
	    WEAPON,
	    AMMO,
	    HEAD_ARMOR,
		BODY_ARMOR,
		MEDICAL,
		BAG,
		CURRENCY,
		SECURE_CONTAINER
	}

	enum EquipmentSlot
	{
	    WEAPON,
	    WEAPON_2,
	    HEAD,
	    CHEST,
	    BAG
	}
	enum LoadoutFocus
	{
	    EQUIPMENT,
	    RAID_BAG,
	    INVENTORY,
		START_RAID
	}
	enum InventoryAction
	{
	    USE,
	    SALVAGE,
	    DESTROY,
	    CANCEL
	}
	enum RaidState
	{
		INACTIVE,
		COMBAT,
		ENTERING,
		EXITING,
		PAUSED,
		DEATH,
		RESULT
	}

	//COMBAT
	enum EffectType
	{
		HEAL
	}
	enum CrewStatus
	{
	    READY,
	    CRITICALLY_INJURED
	}
	enum OverlayMode
	{
	    NONE,
	    SKILLS,
	    LOADOUT,
	    INVENTORY
	}
	enum WorkshopFocus
	{
	    STATIONS,
	    CONTENT
	}
	enum WorkshopTab
	{
	    UPGRADES,
	    FUNCTION
	}
	enum CombatMenuFocus
	{
		AREAS,
		ENEMIES,
		COMBAT
	}


}
