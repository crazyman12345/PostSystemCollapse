function morrowleaf_get_moisture_status()
{
    if (grow.moisture < 20)
        return "CRITICAL";

    if (grow.moisture < 35)
        return "DRY";

    if (grow.moisture <= 70)
        return "HEALTHY";

    if (grow.moisture <= 85)
        return "WET";

    return "SATURATED";
}