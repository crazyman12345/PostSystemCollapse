function blood_spray_update()
{
    if (!global.graphics_settings.blood_effects) return;

    for (var i = array_length(raid_blood_spray_particles) - 1; i >= 0; i--)
    {
        var _particle = raid_blood_spray_particles[i];
        _particle.age += frame_scale;

        if (_particle.age >= _particle.lifetime)
        {
            array_delete(raid_blood_spray_particles, i, 1);
            continue;
        }

        _particle.x += _particle.velocity_x * frame_scale;
        _particle.y += _particle.velocity_y * frame_scale;
        _particle.velocity_x *= power(0.88, frame_scale);
        _particle.velocity_y *= power(0.88, frame_scale);
        _particle.angle += _particle.spin * frame_scale;
        _particle.spin *= power(0.9, frame_scale);

        var _progress = clamp(_particle.age / _particle.lifetime, 0, 1);
        _particle.scale = lerp(_particle.start_scale, _particle.start_scale * 0.25, _progress);
        _particle.alpha = _particle.start_alpha * (1 - _progress);
        raid_blood_spray_particles[i] = _particle;
    }
}
