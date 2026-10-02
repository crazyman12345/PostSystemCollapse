function draw_raid_enemy_death_effects()
{
    for (
        var i = 0;
        i < array_length(raid_enemy_death_effects);
        i++
    )
    {
        var e =
            raid_enemy_death_effects[i];

        draw_sprite_ext(
            e.effect_sprite,
            e.effect_frame,
            e.effect_x,
            e.effect_y,
            e.effect_facing * e.effect_scale,
            e.effect_scale,
            e.effect_angle,
            c_white,
            e.effect_alpha
        );
    }
}