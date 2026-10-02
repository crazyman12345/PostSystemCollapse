function raid_update_threat()
{
    if (raid.noise < 10)
    {
        raid.threat_level = 0;
    }
    else if (raid.noise < 25)
    {
        raid.threat_level = 1;
    }
    else if (raid.noise < 50)
    {
        raid.threat_level = 2;
    }
    else
    {
        raid.threat_level = 3;
    }
}