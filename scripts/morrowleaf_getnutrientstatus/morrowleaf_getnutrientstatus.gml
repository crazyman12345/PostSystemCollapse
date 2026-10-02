function morrowleaf_get_nutrient_status()
{
    if (grow.nutrients < 20)
        return "DEPLETED";

    if (grow.nutrients < 30)
        return "LOW";

    if (grow.nutrients <= 75)
        return "HEALTHY";

    if (grow.nutrients <= 90)
        return "HIGH";

    return "EXCESS";
}