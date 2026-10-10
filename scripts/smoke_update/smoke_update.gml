function smoke_update()
{
    for (var i = array_length(global.smoke_particles) - 1; i >= 0; i--)
    {
        var p = global.smoke_particles[i];

        p.x += p.vx * frame_scale;
        p.y += p.vy * frame_scale;
        p.size += 0.08 * frame_scale;
        p.life -= p.decay * frame_scale;

        if (p.life <= 0)
            array_delete(global.smoke_particles, i, 1);
    }
}
