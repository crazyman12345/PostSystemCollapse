function morrowleaf_update(_dt)
{
    if (!grow_active)
    {
        return;
    }


    // ==============================
    // TIME
    // ==============================

    grow.elapsed += _dt;

    grow.growth =
        (grow.elapsed / grow.duration) * 100;


    // ==============================
    // NATURAL DECAY
    // ==============================

    grow.moisture -= 1.5 * _dt;
    grow.nutrients -= 1.0 * _dt;


    // ==============================
    // ACTION COOLDOWNS
    // ==============================

    grow.water_cooldown =
        max(0, grow.water_cooldown - _dt);

    grow.feed_cooldown =
        max(0, grow.feed_cooldown - _dt);

    grow.tend_cooldown =
        max(0, grow.tend_cooldown - _dt);


    // ==============================
    // NEGLECT
    // ==============================

    var critical =
        grow.moisture < 20 ||
        grow.nutrients < 20;

    if (critical)
    {
        grow.neglect_timer += _dt;

        grow.health -= 3 * _dt;
    }
    else
    {
        // Recover the neglect warning gradually
        grow.neglect_timer =
            max(0, grow.neglect_timer - (2 * _dt));

        grow.health =
            min(100, grow.health + (0.5 * _dt));
    }


    // ==============================
    // QUALITY
    // ==============================

    var conditions_good =
        grow.moisture >= 30 &&
        grow.moisture <= 80 &&
        grow.nutrients >= 30 &&
        grow.nutrients <= 80;

    if (conditions_good)
    {
        grow.quality += 0.15 * _dt;
    }
    else
    {
        grow.quality -= 0.10 * _dt;
    }


    // ==============================
    // LIMIT VALUES
    // ==============================

    grow.moisture =
        clamp(grow.moisture, 0, 100);

    grow.nutrients =
        clamp(grow.nutrients, 0, 100);

    grow.health =
        clamp(grow.health, 0, 100);

    grow.quality =
        clamp(grow.quality, 0, 100);

    grow.growth =
        clamp(grow.growth, 0, 100);


    // ==============================
    // FAILURE
    // ==============================

    if (grow.neglect_timer >= grow.neglect_limit)
    {
        morrowleaf_fail();
        return;
    }


    // ==============================
    // HARVEST
    // ==============================

    if (grow.elapsed >= grow.duration)
    {
        morrowleaf_harvest();
    }
}