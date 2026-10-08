function smoke_draw()
{
    for (var i = 0; i < array_length(global.smoke_particles); i++)
    {
        var p = global.smoke_particles[i];

        draw_set_color(make_color_rgb(85, 85, 80));
        draw_set_alpha(p.life);

        draw_circle(p.x, p.y, p.size, false);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
}