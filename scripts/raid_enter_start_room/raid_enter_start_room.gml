function raid_enter_start_room()
{
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
    raid_floor_generate();
    blood_surface_reset();

    // PLAYER START POSITION
    raid_player_x =
        (raid_room_x1 + raid_room_x2) * 0.5;

    raid_player_y = raid_room_y2 + 60;
    raid_player_entry_target_y = raid_room_y2 - 50;
    raid.room_entering = true;
    raid_player_moving = true;
    raid_player_was_moving = false;
    raid_player_anim_frame = 0;

    // FIRST TWO ROOM CHOICES
    raid_create_next_doors();
}
