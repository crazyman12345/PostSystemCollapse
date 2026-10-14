// ==============================
// DISPLAY
// ==============================
display_set_gui_size(1920, 1080);
window_set_fullscreen(false);
windowed_width = window_get_width();
windowed_height = window_get_height();
windowed_x = window_get_x();
windowed_y = window_get_y();
windowed_showborder = window_get_showborder();
windowed_borderless_fullscreen = window_get_borderless_fullscreen();
fullscreen_restore_steps = -1;
fullscreen_active = false;
display_reset(0, false);
game_set_speed(120, gamespeed_fps);
// Set to spr_equipment_silhouette after importing the sprite.
equipment_silhouette_sprite = spr_silhouette;
// ==============================
// GAME STATE
// ==============================
randomize();
enums();
// ==============================
// INIT
// ==============================
state = GameState.MAIN_MENU;
menu_index = 0;
frame_scale = 1;
music_volume = 50;
music_instance = audio_play_sound(theme_song, 0, true);
audio_sound_gain(music_instance, music_volume / 100, 0);
init_item_database();
init_loot_tables();
init_enemy_database();
init_trader_database();
init_flag_database();
init_skill_database();
init_recipe_database();
init_workbench_database();
init_area_database();
init_raid_vars();
smoke_particle_system = part_system_create();
part_system_automatic_update(smoke_particle_system, false);
part_system_automatic_draw(smoke_particle_system, false);
smoke_particle_update_accumulator = 0;

smoke_particle_type = part_type_create();
part_type_shape(smoke_particle_type, pt_shape_smoke);
part_type_size(smoke_particle_type, 0.25, 0.38, 0.002, 0.01);
part_type_color3(smoke_particle_type, make_color_rgb(78, 78, 76), make_color_rgb(100, 100, 96), make_color_rgb(88, 88, 85));
part_type_alpha3(smoke_particle_type, 0.48, 0.32, 0);
part_type_speed(smoke_particle_type, 0.02, 0.08, 0, 0.01);
part_type_direction(smoke_particle_type, 70, 110, 0, 4);
part_type_life(smoke_particle_type, 145, 225);
part_type_blend(smoke_particle_type, false);

projectile_smoke_particle_type = part_type_create();
part_type_shape(projectile_smoke_particle_type, pt_shape_smoke);
part_type_size(projectile_smoke_particle_type, 0.10, 0.16, 0.006, 0.012);
part_type_color3(projectile_smoke_particle_type, make_color_rgb(58, 56, 52), make_color_rgb(86, 80, 72), make_color_rgb(48, 46, 43));
part_type_alpha3(projectile_smoke_particle_type, 0.24, 0.12, 0);
part_type_speed(projectile_smoke_particle_type, 0.03, 0.10, 0, 0.01);
part_type_life(projectile_smoke_particle_type, 14, 24);
part_type_blend(projectile_smoke_particle_type, false);
//debug
debug_console_open = false;
debug_input = "";
debug_show_mouse = 0;
debug_log = [];
debug_log_max = 6;
overlay_mode = OverlayMode.NONE;
global.admin_trader_enabled = false;
// ==============================
// CREW
// ==============================
crew = [
    {
        name : "ROOK",

        hp : 100,
        max_hp : 100,
		status : CrewStatus.READY,
        accuracy : 0.70,
        injury_end_time: 0,
        weapon : "",
		weapon_2 : "",
        armor_chest : "",
		armor_head : "",
		bag : "",
		secure_container : "small_container",

        alive : true,

	    ascii : [
	    "    O    ",
	    "   /|\\   ",
	    "   / \\   "
		],
		
		skills: {
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
		    medical:
		    {
		        level: 1,
		        xp: 0
		    },
			scavenging:
			{
				level: 1,
				xp: 0
			}	
		}
    }
];
// ==============================
// TRADERS
// ==============================
current_trader_key = "";
trader_menu_index = 0;
trader_sell_index = 0;
trader_mode = TraderMode.SELECT;
// ==============================
// RAID
// ==============================
//audio_play_sound(main_theme, 0, true);

loadout_confirm_start = false;
loadout_confirm_index = 0;
gpu_set_texfilter(false);
// ==============================
// INVENTORY
// ==============================

init_inventory();
inventory_index = 0;
inventory_scroll = 0;
inventory_visible_rows=10;
inventory_hover_item = undefined;
inventory_hover_time = 0;
inventory_hover_item_left = 0;
inventory_hover_item_top = 0;
inventory_hover_surface = -1;
inventory_hover_candidate = undefined;
inventory_hover_candidate_left = 0;
inventory_hover_candidate_top = 0;
inventory_hover_candidate_right = 0;
inventory_hover_candidate_bottom = 0;
stash_index = 0;
salvage_active = false;
salvage_item_key = "";
salvage_end_time = 0;
salvage_duration = 5000;
salvage_message = "";

raid_bag_open = false;
raid_bag_index = 0;
raid_bag_scroll = 0;

loadout_focus = LoadoutFocus.EQUIPMENT;

equipment_slot_index = 0;
equipment_item_index = 0;

loadout_inventory_index = 0;
equipment_selecting_item = false;



// ==============================
// SKILLS
// ==============================
skills_index = 0;
hideout_skills_index = 0;
hideout_skill_node_index = 0;
skill_icon_marksmanship = icon_marksmanship;
skill_icon_athleticism = icon_athleticism;
skill_icon_vitality = icon_vitality;
skill_icon_strength = icon_strength;
skill_icon_scavenging = icon_scavenging;
skill_icon_medical_crafting = icon_medical_crafting;
skill_icon_gunmaking = icon_gunmaking;
skill_icon_armorcrafting = icon_armorcrafting;
skill_icon_drugmaking = icon_drugmaking;

// Avoid first-hit stalls from uploading damage-effect texture pages during combat.
sprite_prefetch(icon_vitality);
sprite_prefetch(spr_blood_splat_small);
sprite_prefetch(spr_blood_pool);
sprite_prefetch(spr_blood_streak);

hideout_skill_tabs = [
    { key: "marksmanship", name: "MARKSMANSHIP", icon: skill_icon_marksmanship, description: "Placeholder description for the Marksmanship skill." },
    { key: "vitality", name: "VITALITY", icon: skill_icon_vitality, description: "Placeholder description for the Vitality skill." },
    { key: "athleticism", name: "ATHLETICISM", icon: skill_icon_athleticism, description: "Placeholder description for the Athleticism skill." },
    { key: "strength", name: "STRENGTH", icon: skill_icon_strength, description: "Placeholder description for the Strength skill." },
    { key: "scavenging", name: "SCAVENGING", icon: skill_icon_scavenging, description: "Placeholder description for the Scavenging skill." },
    { key: "medical_crafting", name: "MEDICAL CRAFTING", icon: skill_icon_medical_crafting, description: "Placeholder description for the Medical Crafting skill." },
    { key: "gunmaking", name: "GUN CRAFTING", icon: skill_icon_gunmaking, description: "Placeholder description for the Gun Crafting skill." },
    { key: "armorcrafting", name: "ARMOR CRAFTING", icon: skill_icon_armorcrafting, description: "Placeholder description for the Armor Crafting skill." },
    { key: "drugmaking", name: "DRUG CRAFTING", icon: skill_icon_drugmaking, description: "Placeholder description for the Drug Crafting skill." }
];
skill_tree_camera_x = 0;
skill_tree_camera_y = 0;
skill_tree_zoom = 1;
skill_tree_views = [];
for (var skill_view_index = 0; skill_view_index < array_length(hideout_skill_tabs); skill_view_index++)
    array_push(skill_tree_views, { camera_x: 0, camera_y: 0, zoom: 1, initialized: false });
skill_tree_drag_active = false;
skill_tree_dragging = false;
skill_tree_drag_start_x = 0;
skill_tree_drag_start_y = 0;
skill_tree_drag_last_x = 0;
skill_tree_drag_last_y = 0;
skill_tree_pressed_node = -1;
skill_notifications_init();
crew_skills_index = 0;
crew_skills_crew_index = 0;
crafting_recipe_index = 0;
crafting_recipe_scroll = 0;
crafting_visible_rows = 20;
crafting_message = "";
// ==============================
// WORKSHOP
// ==============================
workshop_station_index = 0;
workshop_content_index = 0;
workshop_focus = WorkshopFocus.STATIONS;
workshop_tab = WorkshopTab.UPGRADES;
// ==============================
// EVENT LOG
// ==============================
event_log = [];
event_log_max = 2;
log_add("CONNECTED TO POST COLLAPSE NETWORK");
