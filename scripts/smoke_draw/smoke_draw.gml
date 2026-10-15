function smoke_draw()
{
    if (!global.graphics_settings.smoke_effects) return;
    part_system_drawit(smoke_particle_system);
}
