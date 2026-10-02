function draw_raid_doors()
{
    if (!raid.doors_active)
        return;

    draw_set_halign(fa_center);
    draw_set_font(fnt_terminal_small);

    for (var i = 0; i < array_length(raid_doors); i++)
    {
        var d = raid_doors[i];

        draw_set_color(c_lime);

        draw_rectangle(
            d.door_x - d.door_w * 0.5,
            d.door_y - d.door_h * 0.5,
            d.door_x + d.door_w * 0.5,
            d.door_y + d.door_h * 0.5,
            true
        );

        draw_text_transformed(
            d.door_x,
            d.door_y - 28,
            raid_reward_name(d.reward_type),
            0.35,
            0.35,
            0
        );
    }

    draw_set_halign(fa_left);
}