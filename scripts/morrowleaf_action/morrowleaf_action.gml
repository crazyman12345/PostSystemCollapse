function morrowleaf_action(_action)
{
    switch (_action)
    {
        case "WATER":
        {
            if (grow.water_cooldown > 0)
            {
                return false;
            }

            grow.moisture += 30;
            grow.water_cooldown = 15;
			log_add("Morrowleaf grow watered.");
            break;
        }

        case "FEED":
        {
            if (grow.feed_cooldown > 0)
            {
                return false;
            }

            grow.nutrients += 25;
            grow.feed_cooldown = 20;
			log_add("Nutrients added to Morrowleaf grow.");
            break;
        }

        case "TEND":
        {
            if (grow.tend_cooldown > 0)
            {
                return false;
            }

            grow.stress -= 20;
            grow.quality += 2;
            grow.tend_cooldown = 12;
			log_add("Morrowleaf grow tended.");
            break;
        }
    }

    grow.moisture = clamp(grow.moisture, 0, 100);
    grow.nutrients = clamp(grow.nutrients, 0, 100);
    grow.stress = clamp(grow.stress, 0, 100);
    grow.quality = clamp(grow.quality, 0, 100);

    return true;
}