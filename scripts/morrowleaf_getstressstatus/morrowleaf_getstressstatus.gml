function morrowleaf_get_stress_status()
{
    if (grow.stress < 20)
        return "LOW";

    if (grow.stress < 50)
        return "MODERATE";

    if (grow.stress < 75)
        return "HIGH";

    return "CRITICAL";
}