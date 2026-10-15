function smoke_create(_x1, _y1, _x2, _y2, _amount = 8)
{
    if (!global.graphics_settings.smoke_effects) return;
    for (var i = 0; i < _amount; i++)
        part_particles_create(smoke_particle_system, random_range(_x1, _x2), random_range(_y1, _y2), smoke_particle_type, 1);
}

function projectile_smoke_update(_bullet, _previous_x, _previous_y)
{
    if (!global.graphics_settings.smoke_effects) return _bullet;
    if (!variable_struct_exists(_bullet, "smoke_enabled") || !_bullet.smoke_enabled) return _bullet;

    _bullet.smoke_timer -= frame_scale;
    var _emissions = 0;

    while (_bullet.smoke_timer <= 0 && _emissions < 3)
    {
        var _step_position = frame_scale > 0 ? clamp(1 + _bullet.smoke_timer / frame_scale, 0, 1) : 1;
        var _trail_offset = random_range(-0.9, 0.9);
        var _smoke_x = lerp(_previous_x, _bullet.bx, _step_position) - lengthdir_x(3, _bullet.bdirection) + lengthdir_x(_trail_offset, _bullet.bdirection + 90);
        var _smoke_y = lerp(_previous_y, _bullet.by, _step_position) - lengthdir_y(3, _bullet.bdirection) + lengthdir_y(_trail_offset, _bullet.bdirection + 90);

        if (part_particles_count(smoke_particle_system) < 256)
        {
            part_type_direction(projectile_smoke_particle_type, _bullet.bdirection + 150, _bullet.bdirection + 210, 0, 4);
            part_particles_create(smoke_particle_system, _smoke_x, _smoke_y, projectile_smoke_particle_type, 1);
        }

        _bullet.smoke_timer += random_range(max(1, _bullet.smoke_interval - 0.5), _bullet.smoke_interval + 0.5);
        _emissions++;
    }

    return _bullet;
}
