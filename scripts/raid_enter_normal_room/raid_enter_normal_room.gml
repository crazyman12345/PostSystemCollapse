function raid_enter_normal_room(_reward_type)
{
    // Containers belong to the room that is being left. Clear their stored
    // item instances before creating the next room.
    raid_lootables = [];
    raid.active_loot_container = undefined;
    raid.inventory_item = undefined;
    raid.inventory_container = undefined;

    raid.current_room_type = RaidRoomType.NORMAL;
	quest_event(QuestObjectiveType.VISIT_LOCATION, "ROOM", 1);
    raid.current_reward_type = _reward_type;
	part_particles_clear(smoke_particle_system);
	smoke_particle_update_accumulator = 0;
	part_particles_clear(explosion_particle_system);
	explosion_particle_update_accumulator = 0;
    raid.room_cleared = false;
    raid.reward_unlocked = false;
    raid.doors_active = false;

    raid_enemies = [];
    raid_enemy_death_effects = [];
    raid_bullets = [];
    raid_doors = [];
	raid_enemy_bullets = [];
    raid_ring_hazards = [];
    raid_temporary_lights = [];
    raid_muzzle_flash_light = undefined;
    raid_floor_generate();
    raid_generate_room_wall_lights();
    blood_surface_reset();
    raid_player_x = (raid_room_x1 + raid_room_x2) * 0.5;
    raid_player_y = raid_room_y2 + 60;
    raid_player_entry_target_y = raid_room_y2 - 50;
    raid_set_state(RaidState.ENTERING);
	step_raid_camera();

    raid_spawn_enemies();
    raid_create_next_doors(false);
}
