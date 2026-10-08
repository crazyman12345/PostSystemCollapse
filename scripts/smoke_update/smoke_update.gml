function smoke_update()
{
    for (var i = array_length(global.smoke_particles) - 1; i >= 0; i--)
    {
        var p = global.smoke_particles[i];

        p.x += p.vx;
        p.y += p.vy;
        p.size += 0.08;
        p.life -= p.decay;

        if (p.life <= 0)
            array_delete(global.smoke_particles, i, 1);
    }
}