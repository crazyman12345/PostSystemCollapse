// ==============================
// DISPLAY
// ==============================
display_set_gui_size(1920, 1080);
window_set_fullscreen(false);
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
        armor_chest : "",
		armor_head : "",
		bag : "",

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
audio_play_sound(main_theme, 0, true);

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
// DRUG LAB
// ==============================
grow_setups = 0;
grow_active = false;
grow = {
    growth : 0,
    hp : 100,
    quality : 50,

    moisture : 50,
    nutrients : 50,
    stress : 10,
	
	neglect_timer : 0,
    neglect_limit : 8,

    elapsed : 0,
    duration : 60,

    water_cooldown : 0,
    feed_cooldown : 0,
    tend_cooldown : 0
};
grow_menu_index = 0;
// ==============================
// MORROWLEAF RESULTS
// ==============================
harvest_yield = 0;
harvest_quality = 0;
harvest_xp = 0;
grow_fail_reason = "";
// ==============================
// EVENT LOG
// ==============================
event_log = [];
event_log_max = 2;
log_add("CONNECTED TO POST COLLAPSE NETWORK");
