function enums(){
	enum GameState
	{
	    MAIN_MENU,
	    HIDEOUT,
		RAID
	}
	enum RaidPrep
	{
		CREW_SELECT,
		PREP,
		LOCATION_SELECT
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
	
	    { name: "TRADERS", key: "traders", page: HideoutPage.TRADERS, header: "", skill_key: "" },
	    { name: "STASH", key: "stash", page: HideoutPage.STASH, header: "", skill_key: "" },
		{ name: "SKILLS", key: "skills", page: HideoutPage.SKILLS, header: "", skill_key: "" },

		{ name: "SALVAGE", key: "salvage", page: HideoutPage.SALVAGE, header: "CRAFTING", skill_key: "salvage" },
	    { name: "GUNMAKING", key: "gunmaking", page: HideoutPage.GUNMAKING, header: "", skill_key: "gunmaking" },
	    { name: "ARMORCRAFTING", key: "armorcrafting", page: HideoutPage.ARMORCRAFTING, header: "", skill_key: "armorcrafting" },
	    { name: "MEDICAL CRAFTING", key: "medical_crafting", page: HideoutPage.MEDICAL_CRAFTING, header: "", skill_key: "medical_crafting" },
		{ name: "DRUGMAKING", key: "drugmaking", page: HideoutPage.DRUG_LAB, header: "", skill_key: "drugmaking" },
		{ name: "WORKSHOP", key: "workshop", page: HideoutPage.WORKSHOP, header: "", skill_key: "" },
		 
	    { name: "GO RAID!", key: "raids", page: HideoutPage.RAIDS, header: "", skill_key: "" },
	   
	];
	enum HideoutFocus{
		SIDEBAR,
		CONTENT
	}
	enum TraderMode{
		BUY,
		SELECT,
		SELL
	}
	enum DrugState{
		MORROWLEAF_GROW,
		MORROWLEAF_FAIL,
		MORROWLEAF_HARVEST,
		DRUG_LAB
	}
	enum CombatTactic{
		MIXED,
		OFFENSIVE,
		DEFENSIVE
	}
	enum ItemCategory
	{
	    MATERIAL,
	    LAB_MATERIAL,
	    SEED,
	    PRODUCT,
	    WEAPON,
	    AMMO,
	    HEAD_ARMOR,
		BODY_ARMOR,
		MEDICAL,
		BAG,
		CURRENCY
	}
	enum DrugMinigameType
	{
	    CULTIVATION,
	    SYNTHESIS,
	    REFINING
	}
	enum EquipmentSlot
	{
	    WEAPON,
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
	enum RaidMode
	{
		START,
		LOOT,
		RESULT
	}
	enum JunctionType
	{
	    ROOM,
	    HALLWAY,
	    RESOURCE,
	    EVENT,
	    HAZARD,
	    REST,
	    BOSS,
	    EXTRACT
	}
	enum RaidActionType
	{
	    MOVE,
	    SEARCH,
	    EXTRACT,
	    REST,
	    FORCE,
	    USE_ITEM,
	    START_COMBAT,
	    EVENT
	}
	enum EffectType
	{
	    GIVE_ITEM,
	    REMOVE_ITEM,
	    ADD_NOISE,
	    HEAL,
	    DAMAGE,
	    SET_FLAG,
	    ADD_SKILL_XP
	}
	enum RequirementType
	{
	    CREW_SKILL,
	    PLAYER_SKILL,
	    ITEM,
	    FLAG
	}
	//COMBAT
	enum CombatPhase
	{
		DECISION,
		AUTO_BURST,
		ITEM_SELECT
	}
	enum CombatAction
	{
	    ATTACK,
	    USE_ITEM
	}
	enum CombatTurn
	{
	    PLAYER,
	    ENEMY
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
	    CREW_SKILLS,
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
	enum IdleCombatBox
	{
		MEDS,
		EQUIPMENT,
		TACTIC,
		BACK
	}
// ==========================================
// COMBAT AREA / ENEMY SELECTION
// ==========================================

combat_menu_focus = CombatMenuFocus.AREAS;
combat_area_index = 0;
combat_enemy_index = 0;

// ==========================================
// COMBAT TACTIC
// ==========================================

combat_tactic = CombatTactic.OFFENSIVE;


// ==========================================
// IDLE COMBAT UI
// ==========================================

idle_combat_box = IdleCombatBox.MEDS;
idle_combat_in_box = false;

idle_combat_med_index = 0;
idle_combat_equipment_index = 0;
idle_combat_tactic_index = 0;


// ==========================================
// IDLE COMBAT STATE
// ==========================================

idle_combat_active = false;

idle_combat_enemy_key = "";
idle_combat_enemy_hp = 0;

idle_combat_player_hp = 100;
idle_combat_player_max_hp = 100;


// ==========================================
// PLAYER COMBAT STATS
// TEMP VALUES FOR NOW
// ==========================================

idle_combat_player_min_damage = 4;
idle_combat_player_max_damage = 8;

idle_combat_player_accuracy = 72;

idle_combat_player_crit_chance = 5;
idle_combat_player_crit_damage = 150;

idle_combat_player_attack_interval = 1.8;


// ==========================================
// ENEMY COMBAT
// ==========================================

idle_combat_enemy_attack_interval = 0;


// ==========================================
// ATTACK TIMERS
// ==========================================

idle_combat_player_attack_timer = 0;
idle_combat_enemy_attack_timer = 0;

idle_combat_respawn_timer = 0;
}