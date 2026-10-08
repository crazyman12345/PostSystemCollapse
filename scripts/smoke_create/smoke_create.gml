function smoke_create(_x1, _y1, _x2, _y2, _amount = 8)
{
    for (var i = 0; i < _amount; i++)
    {
        array_push(global.smoke_particles, {
            x: random_range(_x1, _x2),
            y: random_range(_y1, _y2),
            vx: random_range(-0.08, 0.08),
            vy: random_range(-0.08, 0.02),
            size: random_range(3, 5),
            life: 1,
            decay: random_range(0.006, 0.012)
        });
    }
}