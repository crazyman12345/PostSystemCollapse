function step_raid_combat()
{
    var _allow_combat_input = step_raid_combat_input();
    if (raid.state != RaidState.COMBAT) return;

    // Player
    step_raid_player(_allow_combat_input);
    step_raid_player_damage();
    if (raid_combat_update_should_stop()) return;

    // Combat
    step_raid_shooting(_allow_combat_input);
    step_raid_bullets();
    step_raid_enemy_bullets();
    if (raid_combat_update_should_stop()) return;

    step_raid_ring_hazards();
    if (raid_combat_update_should_stop()) return;

    step_raid_enemies();
    if (raid_combat_update_should_stop()) return;

    step_raid_enemy_death_effects();

    // World updates
    if (_allow_combat_input)
    {
        step_raid_lootables();
        step_raid_ground_items();
    }

    if (_allow_combat_input) step_raid_doors();
    if (raid_combat_update_should_stop()) return;
    if (_allow_combat_input) step_raid_extract();
    if (raid_combat_update_should_stop()) return;
    step_raid_camera();

    // Cleanup
    if (array_length(raid_enemies) <= 0) raid.room_cleared = true;
}
