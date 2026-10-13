function raid_combat_update_should_stop()
{
    if (raid.state == RaidState.DEATH && overlay_mode == OverlayMode.LOADOUT) overlay_close();
    return raid.state != RaidState.COMBAT;
}
