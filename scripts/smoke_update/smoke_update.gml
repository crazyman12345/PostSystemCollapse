function smoke_update()
{
    if (!global.graphics_settings.smoke_effects) return;
    smoke_particle_update_accumulator += frame_scale;
    while (smoke_particle_update_accumulator >= 1)
    {
        part_system_update(smoke_particle_system);
        smoke_particle_update_accumulator -= 1;
    }
    smoke_particle_count = part_particles_count(smoke_particle_system);
}
