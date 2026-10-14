if (
    state == GameState.RAID
    && raid.state != RaidState.RESULT
)
{
    draw_raid();
    draw_raid_lighting();
}
