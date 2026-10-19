function raid_enter_start_room()
{
    part_particles_clear(smoke_particle_system);
    smoke_particle_update_accumulator = 0;
    part_particles_clear(explosion_particle_system);
    explosion_particle_update_accumulator = 0;
    raid.current_room_type = RaidRoomType.START;

    raid.room_cleared = true;
    raid.reward_unlocked = false;

    raid.doors_active = false;
    raid.extract_active = false;

    raid_enemies = [];
    raid_enemy_death_effects = [];
    raid_bullets = [];
    raid_doors = [];
    raid_lootables = [];
    raid_ring_hazards = [];
    raid_temporary_lights = [];
    raid_muzzle_flash_light = undefined;
    raid_floor_generate();
    raid_generate_room_wall_lights();
    blood_surface_reset();

    // PLAYER START POSITION
    raid_player_x =
        (raid_room_x1 + raid_room_x2) * 0.5;

    raid_player_y = raid_room_y2 + 60;
    raid_player_entry_target_y = raid_room_y2 - 50;
    raid_set_state(RaidState.ENTERING);

    // FIRST TWO ROOM CHOICES
    raid_create_next_doors();
}
