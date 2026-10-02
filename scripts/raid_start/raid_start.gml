function raid_start(_area)
{
	
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
    raid.selected_area = _area;

    state = GameState.RAID;
    overlay_mode = OverlayMode.NONE;

    raid.room_number = 1;
    raid.room_cleared = false;

    raid_player_x = 960;
    raid_player_y = 540;
raid_enemy_bullets = [];
raid_room_x1 = 760;
raid_room_y1 = 340;

raid_room_x2 = 1160;
raid_room_y2 = 740;
	raid_player_setup_health();
    raid_enter_start_room();
}