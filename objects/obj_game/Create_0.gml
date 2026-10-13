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
global.smoke_particles = [];
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
