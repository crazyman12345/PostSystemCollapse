function init_raid_vars(){
enum RaidRoomType
{
	START,
    NORMAL,
    CHECKPOINT,
    BOSS
}

enum RaidRewardType
{
    FILING_CABINETS,
    SUPPLY_CRATES,
    TOOLBOX,
    CASH_REGISTER,
    MEDICAL_CRATE,
    ELECTRONICS,
    FOOD_STORAGE,
    WEAPON_CRATE,
    ARMOR_CRATE,
    BACKROOM_STASH
}

enum RaidEnemyType
{
    BURST_SHOOTER,
    KNIFE_STALKER,
    SPINNER,
    KNIFE_DASHER,
	WALL_RUSHER
}

enum RaidEnemyState
{
    MOVE,
    ATTACK,
    PAUSE,
    DASH
}

enum WeaponFireMode
{
    SEMI,
    BURST,
    AUTO
}
raid =
{
    active: false,
    crew_index: 0,
    location_key: "",
    // Current position
    junction_key: "",
    junction_action_index: 0,
	visited_junctions: {},
    // Current raid screen/activity
    mode: RaidMode.START,
    paused: false,
    pause_menu_index: 1,
    // Raid bag
    bag: {},
    // Loot currently on ground
    last_loot: [],
    loot_index: 0,
    // Noise / danger
    noise: 0,
    threat_level: 0,
    // Timed actions
    action_active: false,
    action_timer: 0,
    action_duration: 0,
    pending_action: undefined,
    // Tracks searched/opened/etc. things
    completed_actions: {},
    // Combat
	room_cleared: false,
    enemy_key: "",
    enemy_hp: 0,
    combat_active: false,
	combat_action_index: 0,
	combat_item_index: 0,
	combat_timer: 0,
	combat_delay: 1,
	combat_exchanges_remaining: 0,
	combat_exchanges_per_burst: 3,
	enemy_key: "",
	enemy_hp: 0,
	combat_source_action:
	    undefined,
    // Results
    result_title: "",
    result_message: ""
};


raid.rooms_cleared = 0;
raid.rooms_in_section = 0;
raid.section = 1;
raid.current_reward_type = RaidRewardType.FILING_CABINETS;
raid.reward_unlocked = false;
raid.doors_active = false;
raid_doors = [];
raid_enemy_bullets = [];
raid.current_room_type = RaidRoomType.START;
raid.room_cleared = true;
raid.extract_active = false;
loadout_focused_item_key = "";
raid_player_max_hp = 30;
raid_player_hp = 30;
combat_area_index = 0;
combat_menu_focus = CombatMenuFocus.AREAS;
raid_player_armor = 0;
raid_player_max_armor = 0;

raid_player_invincible = false;
raid_player_invincible_timer = 0;
raid_player_invincible_time = 90; // about 1 second at 60 FPS

raid_player_moving = false;
raid_player_anim_frame = 0;
raid_player_anim_speed = 0.15;
raid_player_was_moving = false;
raid_shot_cooldown = 0;
raid_map_surface = -1;
raid_player_x = 960;
raid_player_y = 540;
raid_aim_dir = 0;
raid_gun_length = 12;
raid_gun_width = 6;
raid_gun_offset = 14;
raid_player_speed = 3;
raid_player_facing = 1;
raid_player_radius = 16;
raid_player_dash_active = false;
raid_player_dash_timer = 0;
raid_player_dash_time = 8;
raid_player_dash_speed = 12;
raid_player_dash_x = 0;
raid_player_dash_y = 0;
raid_player_dash_trail = [];
raid_player_dash_trail_time = 12;
raid_player_max_stamina = 20;
raid_player_stamina = 20;
raid_player_dash_stamina_cost = 10;
raid_player_stamina_regen = 0.02;
raid_gun_recoil = 0;
raid_gun_recoil_return = 0.8;
raid_weapon_mag = 0;
raid_weapon_loaded_key = "";
raid_reload_active = false;
raid_reload_timer = 0;
raid_burst_remaining = 0;
raid_fire_mode_index = 0;
raid_current_fire_mode = WeaponFireMode.SEMI;
raid_enemy_death_effects = [];
player_equipment = {
    armor_sprite_idle: -1,
    armor_sprite_run: -1,

    helmet_sprite_idle: -1,
    helmet_sprite_run: -1,

    bag_sprite_idle: -1,
    bag_sprite_run: -1
};
raid_lootables = [];
raid_ground_items = [];
}
