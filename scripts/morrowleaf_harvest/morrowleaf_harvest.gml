function morrowleaf_harvest()
{
    grow_active = false;

    harvest_quality = round(grow.quality);

    harvest_yield = 2;

    if (harvest_quality >= 40)
    {
        harvest_yield += 1;
    }

    if (harvest_quality >= 60)
    {
        harvest_yield += 2;
    }

    if (harvest_quality >= 80)
    {
        harvest_yield += 2;
    }

    harvest_xp = 15;

    if (harvest_quality >= 60)
    {
        harvest_xp += 5;
    }

    if (harvest_quality >= 80)
    {
        harvest_xp += 5;
    }

    drug_state = DrugState.MORROWLEAF_HARVEST;
    menu_index = 0;
	log_add(
    "Harvest complete: "
    + string(harvest_yield)
    + " Raw Morrowleaf."
);
}