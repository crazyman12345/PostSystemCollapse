if (
    state == GameState.RAID
    && raid.state != RaidState.RESULT
)
{
    draw_raid();
    draw_raid_lighting();
    if (raid.state != RaidState.DEATH) explosion_draw();
    draw_raid_environment_debug();
    draw_raid_player_hit_region_debug();
    if (raid.state != RaidState.DEATH)
    {
        draw_raid_lootables(true);
        draw_raid_doors();
        draw_raid_lootable_prompt();
        draw_raid_ground_item_prompt();
        draw_raid_extract_prompt();
    }
}
