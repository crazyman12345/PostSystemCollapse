function draw_raid_enemy_bullets()
{
    draw_set_color(c_red);

    for (var i = 0; i < array_length(raid_enemy_bullets); i++)
    {
        var b = raid_enemy_bullets[i];

        draw_circle(
            b.bx,
            b.by,
            3,
            false
        );
    }

    draw_set_color(c_white);
}