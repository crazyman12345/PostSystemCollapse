function smoke_update()
{
    smoke_particle_update_accumulator += frame_scale;
    while (smoke_particle_update_accumulator >= 1)
    {
        part_system_update(smoke_particle_system);
        smoke_particle_update_accumulator -= 1;
    }
}
