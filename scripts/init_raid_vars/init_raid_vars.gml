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

raid_lootable_visuals = [
    {sprite: spr_filing_cabinet, scale: 0.098, shadow_offset_x: 0, shadow_offset_y: -12}, // FILING_CABINETS
    {sprite: spr_crate, scale: 0.07, shadow_offset_x: 0, shadow_offset_y: -12}, // SUPPLY_CRATES
    {sprite: spr_toolbox, scale: 0.08, shadow_offset_x: 0, shadow_offset_y: -12}, // TOOLBOX
    {sprite: spr_cashregister, scale: 0.029, shadow_offset_x: 0, shadow_offset_y: -12}, // CASH_REGISTER
    {sprite: spr_crate, scale: 0.07, shadow_offset_x: 0, shadow_offset_y: -12}, // MEDICAL_CRATE
    {sprite: spr_shelves, scale: 0.075, shadow_offset_x: 0, shadow_offset_y: -12}, // ELECTRONICS
    {sprite: spr_foodshelf, scale: 0.029, shadow_offset_x: 0, shadow_offset_y: -12}, // FOOD_STORAGE
    {sprite: spr_crate, scale: 0.07, shadow_offset_x: 0, shadow_offset_y: -12}, // WEAPON_CRATE
    {sprite: spr_crate, scale: 0.07, shadow_offset_x: 0, shadow_offset_y: -12}, // ARMOR_CRATE
    {sprite: spr_shelves, scale: 0.075, shadow_offset_x: 0, shadow_offset_y: -12}  // BACKROOM_STASH
];

enum RaidEnemyType
{
    BURST_SHOOTER,
    KNIFE_STALKER,
    SPINNER,
    KNIFE_DASHER,
	WALL_RUSHER,
    BONES
}

enum RaidEnemyState
{
    MOVE,
    ATTACK,
    PAUSE,
    DASH,
    BOSS_ATTACK,
    PHASE_TRANSITION
}

enum BossAttackType
{
    BONES_ATTACK_SHOOT_DASH_SHOOT,
    BOSS_ATTACK_ROOM_SHOCKWAVE,
    BOSS_ATTACK_WALKDOWN,
    BOSS_ATTACK_GRENADE_WALKDOWN
}

enum BossAttackState
{
    SELECT,
    AIM,
    SHOOT_FIRST,
    PRE_DASH,
    DASH,
    POST_DASH,
    SHOOT_SECOND,
    RECOVERY,
    WALKDOWN,
    SHOCKWAVE_MOVE,
    SHOCKWAVE_WINDUP,
    SHOCKWAVE_RECOVERY
}

enum WeaponFireMode
{
    SEMI,
    BURST,
    AUTO
}
raid =
{
    state: RaidState.INACTIVE,
    crew_index: 0,
    location_key: "",
    // Current position
    junction_key: "",
    junction_action_index: 0,
	visited_junctions: {},
    pause_menu_index: 2,
    pause_menu_tab: 0,
    pause_graphics_index: 0,
    pause_graphics_scroll: 0,
    pause_fps_index: 1,
    // Selection references the carried grid item; it never removes it from storage.
    inventory_item: undefined,
    inventory_container: undefined,
    inventory_equipment_slot: -1,
    active_loot_container: undefined,
    hotbar: [undefined, undefined, undefined, undefined, undefined, undefined],
    hotbar_feedback_slot: -1,
    hotbar_feedback_timer: 0,
    hotbar_feedback_success: false,
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
raid_ring_hazards = [];
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
raid_godmode = false;

raid_player_moving = false;
raid_player_anim_frame = 0;
raid_player_anim_speed = 0.15;
raid_player_was_moving = false;
raid_player_entry_target_y = 0;
raid_player_entry_speed = 3 / 1.3;
raid_player_exit_target_y = 0;
raid_player_exit_reward_type = RaidRewardType.FILING_CABINETS;
raid_shot_cooldown = 0;
raid_knife_attack_time = 8;
raid_knife_attack_timer = 0;
raid_knife_attack_hit = false;
raid_knife_attack_dir = 0;
raid_knife_trail = [];
raid_knife_trail_time = 6;
raid_knife_trail_accumulator = 0;
raid_enemy_hit_sound = snd_hit;
raid_map_surface = -1;
raid_lighting_surface = -1;
raid_colored_lighting_surface = -1;
raid_emissive_surface = -1;
raid_bloom_blur_surface = -1;
raid_bloom_surface = -1;
raid_color_grade_saturation = 1.15;
raid_color_grade_contrast = 1.05;
raid_color_grade_brightness = 1.0;
raid_lighting_ambient_alpha = 0.90;
raid_lighting_clip_offset = 46;
raid_colored_light_strength = 0.38;
raid_smoke_min_light = 0.525;
raid_smoke_light_response = 1.4;
raid_smoke_colored_light_strength = 2.75;
raid_smoke_alpha_scale = 1.75;
raid_bloom_enabled = true;
raid_bloom_intensity = 0.6;
raid_bloom_blur_radius = 3;
raid_bloom_blur_passes = 2;
raid_bloom_wall_lamp_source_scale = 2.0;
raid_bloom_projectile_source_scale = 1.5;
raid_bloom_muzzle_flash_source_scale = 1.6;
raid_bloom_explosion_source_scale = 1;
raid_muzzle_flash_radius = 200;
raid_muzzle_flash_shotgun_radius = 240;
raid_muzzle_flash_auto_radius = 180;
raid_muzzle_flash_lifetime = 5;
raid_muzzle_flash_shotgun_lifetime = 6;
raid_muzzle_flash_auto_lifetime = 4;
raid_muzzle_flash_intensity = 1.15;
raid_muzzle_flash_color = make_color_rgb(255, 210, 122);
raid_muzzle_flash_core_radius = 28;
raid_muzzle_flash_core_intensity = 1.3;
raid_muzzle_flash_shadow_height = 48;
raid_muzzle_flash_decay_power = 2.4;
raid_player_light_radius = 55;
raid_player_light_strength = 0.22;
raid_player_light_color = make_color_rgb(255, 220, 175);
raid_player_light_offset_y = -8;
raid_enemy_light_strength = 0.14;
// Shared defaults copied onto lootables so individual objects can override them.
loot_halo_enabled = true;
loot_halo_radius = 65;
loot_halo_intensity = 0.60;
loot_halo_color = c_white;
loot_halo_offset_x = 0;
loot_halo_offset_y = -10;
loot_door_halo_intensity = 0.75;
loot_door_halo_offset_y = -32;
loot_door_halo_xscale = 1;
loot_door_halo_yscale = 1;
raid_light_sources = [];
raid_wall_lights = [];
raid_room_clear_light = undefined;
raid_temporary_lights = [];
raid_shadow_occluders = [];
raid_shadow_silhouette_cache = {};
raid_shadow_debug = false;
raid_character_shadows_enabled = true;
raid_character_shadow_size = 20;
raid_character_shadow_opacity = 0.35;
raid_shadow_hand_extra_offset_scale = 0.75;
raid_shadow_gun_extra_offset_scale = 0.75;
raid_blood_surface = -1;
raid_blood_surface_x = 0;
raid_blood_surface_y = 0;
raid_blood_surface_width = 1;
raid_blood_surface_height = 1;
raid_floor_tiles = [];
raid_player_x = 960;
raid_player_y = 540;
raid_player_velocity_x = 0;
raid_player_velocity_y = 0;
raid_player_smoothed_velocity_x = 0;
raid_player_smoothed_velocity_y = 0;
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
raid_player_dash_xp_pending = false;
raid_athleticism_move_distance = 0;
raid_strength_carry_distance = 0;
raid_strength_carry_xp_rate = 0;
raid_player_dash_trail = [];
raid_player_dash_trail_time = 12;
raid_player_dash_trail_accumulator = 0;
raid_player_max_stamina = 20;
raid_player_stamina = 20;
raid_player_dash_stamina_cost = 10;
raid_player_stamina_regen = 0.02;
raid_gun_recoil = 0;
raid_gun_recoil_return = 0.8;
raid_muzzle_flash_light = undefined;
raid_weapon_mag = 0;
raid_weapon_loaded_key = "";
active_weapon_slot = -1;
raid_weapon_loaded_slot = -1;
raid_weapon_mags = [0, 0];
raid_weapon_slot_keys = ["", ""];
raid_weapon_slot_display = 0;
raid_weapon_slot_display_target = 0;
raid_reload_active = false;
raid_reload_timer = 0;
raid_burst_remaining = 0;
raid_fire_mode_index = 0;
raid_current_fire_mode = WeaponFireMode.SEMI;
// Developer-only raid gun tuning state. Values live outside the item database.
raid_gun_tuning_active = false;
raid_gun_tuning_weapon_key = "";
raid_gun_tuning_value_index = 0;
raid_gun_tuning_values = {};
raid_enemy_death_effects = [];
raid_player_death_phase = 0;
raid_player_death_timer = 0;
raid_player_death_x = 0;
raid_player_death_y = 0;
raid_player_death_sprite = -1;
raid_player_death_frame = 0;
raid_player_death_facing = 1;
raid_player_death_scale = 1;
raid_player_death_chunks_created = false;
raid_player_death_camera_width = 640;
raid_player_death_camera_height = 360;
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
