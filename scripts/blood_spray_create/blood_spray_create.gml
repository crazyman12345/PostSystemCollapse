function blood_spray_create(_x, _y, _direction, _intensity = 1)
{
    if (!global.graphics_settings.blood_effects) return;

    var _particle_count = round(irandom_range(10, 16) * max(0.25, _intensity));
    var _max_particles = 200;
    var _remove_count = array_length(raid_blood_spray_particles) + _particle_count - _max_particles;

    if (_remove_count > 0)
        array_delete(raid_blood_spray_particles, 0, min(_remove_count, array_length(raid_blood_spray_particles)));

    var _spawn_x = _x;
    var _spawn_y = _y;

    for (var i = 0; i < _particle_count; i++)
    {
        var _particle_direction = _direction + random_range(-20, 20);
        var _particle_speed = random_range(2, 4.5);
        var _particle_scale = random_range(1.2, 2);
        var _particle_alpha = random_range(0.55, 0.85);

        array_push(raid_blood_spray_particles, {
            x: _spawn_x + random_range(-1, 1),
            y: _spawn_y + random_range(-1, 1),
            velocity_x: lengthdir_x(_particle_speed, _particle_direction),
            velocity_y: lengthdir_y(_particle_speed, _particle_direction),
            angle: random(360),
            spin: random_range(-10, 10),
            scale: _particle_scale,
            start_scale: _particle_scale,
            alpha: _particle_alpha,
            start_alpha: _particle_alpha,
            age: 0,
            lifetime: random_range(14, 24)
        });
    }
}
