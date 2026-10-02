function raid_get_threat_encounter_chance()
{
    switch (raid.threat_level)
    {
        case 0:
            return 0;

        case 1:
            return 15;

        case 2:
            return 30;

        case 3:
            return 50;
    }

    return 0;
}