function blood_spray_draw()
{
    if (!global.graphics_settings.blood_effects) return;

    for (var i = 0; i < array_length(raid_blood_spray_particles); i++)
    {
        var _particle = raid_blood_spray_particles[i];
        draw_sprite_ext(
            spr_blood_speck,
            0,
            _particle.x,
            _particle.y,
            _particle.scale,
            _particle.scale,
            _particle.angle,
            c_white,
            _particle.alpha
        );
    }
}
