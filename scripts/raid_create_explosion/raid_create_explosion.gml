function raid_create_explosion(_x, _y, _radius)
{
    _radius = max(1, _radius);
    var _scale = _radius / 64;
    var _fire_count = round(clamp(_radius * 0.25, 10, 48));
    var _spark_count = round(clamp(_radius * 0.18, 8, 36));
    var _smoke_count = round(clamp(_radius * 0.1, 5, 20));

    part_type_size(explosion_fire_particle_type, 0.18 * _scale, 0.32 * _scale, 0.035 * _scale, 0.05 * _scale);
    part_type_speed(explosion_fire_particle_type, 0.5 * _scale, 2.2 * _scale, -0.03 * _scale, 0.12 * _scale);
    part_type_size(explosion_spark_particle_type, 0.1 * _scale, 0.18 * _scale, -0.002 * _scale, 0.03 * _scale);
    part_type_speed(explosion_spark_particle_type, 1.8 * _scale, 4.8 * _scale, -0.05 * _scale, 0.2 * _scale);
    part_type_size(explosion_smoke_particle_type, 0.16 * _scale, 0.28 * _scale, 0.018 * _scale, 0.04 * _scale);
    part_type_speed(explosion_smoke_particle_type, 0.2 * _scale, 0.8 * _scale, 0, 0.06 * _scale);

    part_particles_create(explosion_particle_system, _x, _y, explosion_fire_particle_type, _fire_count);
    part_particles_create(explosion_particle_system, _x, _y, explosion_spark_particle_type, _spark_count);
    part_particles_create(explosion_particle_system, _x, _y, explosion_smoke_particle_type, _smoke_count);
    audio_play_sound(smoke_sound, 0, false);

    var _light = raid_spawn_temporary_light(
        _x, _y, _radius, c_white, raid_explosion_light_intensity,
        raid_explosion_light_lifetime, raid_explosion_light_shadow_height, true,
        raid_explosion_light_shadow_height
    );
    _light.decay_power = raid_explosion_light_decay_power;

    return _light;
}
