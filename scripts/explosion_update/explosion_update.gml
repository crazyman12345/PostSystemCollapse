function explosion_update()
{
    explosion_particle_update_accumulator += frame_scale;
    while (explosion_particle_update_accumulator >= 1)
    {
        part_system_update(explosion_particle_system);
        explosion_particle_update_accumulator -= 1;
    }
}
