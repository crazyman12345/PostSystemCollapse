function step_raid_enemy_death_effects()
{
    for (
        var i = array_length(raid_enemy_death_effects) - 1;
        i >= 0;
        i--
    )
    {
        var e =
            raid_enemy_death_effects[i];

        // SPIN
        e.effect_angle += 8;

        // SHRINK
        e.effect_scale *= 0.94;

        // FADE
        e.effect_alpha -= 0.04;

        // OPTIONAL: DROP DOWN SLIGHTLY
        e.effect_y += 0.4;

        e.effect_timer--;

        if (
            e.effect_timer <= 0
            || e.effect_alpha <= 0
        )
        {
            array_delete(
                raid_enemy_death_effects,
                i,
                1
            );

            continue;
        }

        raid_enemy_death_effects[i] = e;
    }
}