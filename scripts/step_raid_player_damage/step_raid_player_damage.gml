function step_raid_player_damage()
{
    if (raid_player_invincible)
    {
        raid_player_invincible_timer--;

        if (raid_player_invincible_timer <= 0)
        {
            raid_player_invincible = false;
            raid_player_invincible_timer = 0;
        }
    }
}