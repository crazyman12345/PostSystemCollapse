function step_raid()
{
    // ==========================================
    // RESULT SCREEN
    // ==========================================

    if (raid.mode == RaidMode.RESULT)
    {
        step_raid_result();
        return;
    }

    // ==========================================
    // ACTIVE PHYSICAL RAID
    // ==========================================

    if (!raid.active)
        return;

    step_raid_player();
	step_raid_player_damage();
	
    step_raid_shooting();
	
    step_raid_bullets();
	step_raid_enemy_bullets();

  
    step_raid_enemies();
	step_raid_enemy_death_effects();
	step_raid_lootables();
	step_raid_ground_items();
	
	step_raid_doors();
	step_raid_extract();
	
	step_raid_camera();

    if (array_length(raid_enemies) <= 0)
    {
        raid.room_cleared = true;
    }

    // Open loadout while inside raid
    if (keyboard_check_pressed(ord("U")))
    {
        overlay_mode = OverlayMode.LOADOUT;
    }
}