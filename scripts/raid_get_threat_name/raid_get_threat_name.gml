function raid_get_threat_name()
{
    switch (raid.threat_level)
    {
        case 0:
            return "LOW";

        case 1:
            return "ELEVATED";

        case 2:
            return "HIGH";

        case 3:
            return "CRITICAL";
    }


    return "UNKNOWN";
}