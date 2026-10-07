function raid_start(_area)
{
	if (!is_undefined(stash.held_item))
	{
		log_add("Place the held item before starting a raid.");
		return;
	}
	// Carry the existing grids and their item instances directly into the raid.
	var backpack = item_get(crew[raid.crew_index].bag);
	stash.backpack.grid_width = is_undefined(backpack) ? 0 : backpack.grid_width;
	stash.backpack.grid_height = is_undefined(backpack) ? 0 : backpack.grid_height;
	// Raid inventory uses the persistent equipped grids directly. Clear only
	// stale raid references from the previous result; never rebuild the grids.
	raid.active_loot_container = undefined;
	raid.inventory_item = undefined;
	raid.inventory_container = undefined;
	raid.inventory_rotation = 0;
	raid.last_loot = [];
	raid.loot_index = 0;
	
	view_enabled = true;
	view_visible[0] = true;
	raid.mode = RaidMode.START;
	raid_camera = view_camera[0];

	camera_set_view_size(
	    raid_camera,
	    640,
	    360
	);
    raid.active = true;
    raid.paused = false;
    raid.pause_menu_index = 1;
    raid.selected_area = _area;

    state = GameState.RAID;
    overlay_mode = OverlayMode.NONE;

    raid.room_number = 1;
    raid.room_cleared = false;

    raid_player_x = 960;
    raid_player_y = 540;
raid_enemy_bullets = [];
raid_ring_hazards = [];
raid_room_x1 = 760;
raid_room_y1 = 340;

raid_room_x2 = 1160;
raid_room_y2 = 740;
	raid_player_setup_health();
    raid_reset_active_weapon();
    active_weapon_slot = EquipmentSlot.WEAPON;

    if (is_undefined(raid_get_weapon_in_slot(active_weapon_slot)))
    {
        active_weapon_slot = EquipmentSlot.WEAPON_2;
    }

    raid_update_active_weapon();
    raid_weapon_slot_display = max(0, active_weapon_slot);
    raid_weapon_slot_display_target = raid_weapon_slot_display;
    raid_enter_start_room();
}
