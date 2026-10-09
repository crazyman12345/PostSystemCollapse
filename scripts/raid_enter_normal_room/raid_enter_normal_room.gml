function raid_enter_normal_room(_reward_type)
{
    // Containers belong to the room that is being left. Clear their stored
    // item instances before creating the next room.
    raid_lootables = [];
    raid.active_loot_container = undefined;
    raid.inventory_item = undefined;
    raid.inventory_container = undefined;

    raid.current_room_type = RaidRoomType.NORMAL;
    raid.current_reward_type = _reward_type;
	global.smoke_particles = [];
    raid.room_cleared = false;
    raid.reward_unlocked = false;
    raid.doors_active = false;

    raid_enemies = [];
    raid_bullets = [];
    raid_doors = [];
	raid_enemy_bullets = [];
    raid_ring_hazards = [];
    raid_player_x = (raid_room_x1 + raid_room_x2) * 0.5;
    raid_player_y = raid_room_y2 + 60;
    raid_player_entry_target_y = raid_room_y2 - 50;
    raid.room_entering = true;
    raid_player_moving = true;
    raid_player_was_moving = false;
    raid_player_anim_frame = 0;
	step_raid_camera();

    raid_spawn_enemies();
}
