function raid_extract()
{
    raid.result_title =
        "EXTRACTION SUCCESSFUL";

    raid.result_message =
        "All items secured.";

    // Persistent backpack, equipment instances, and secure contents are
    // already in their final grids. Only clear temporary raid references.
    raid_secure_bag();

    blood_surface_destroy();
    raid_reset_active_weapon();

    raid.extract_active = false;
    raid.doors_active = false;
	
    raid_enemies = [];
    raid_enemy_bullets = [];
    raid_ring_hazards = [];
    raid_enemy_death_effects = [];
    raid_bullets = [];
    raid_doors = [];
    raid_temporary_lights = [];
    raid_muzzle_flash_light = undefined;

    raid_set_state(RaidState.RESULT);
}
