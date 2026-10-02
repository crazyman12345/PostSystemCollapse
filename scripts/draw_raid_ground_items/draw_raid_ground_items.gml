function draw_raid_ground_items()
{
    draw_set_font(fnt_terminal_medium);


    for (
        var i = 0;
        i < array_length(raid_ground_items);
        i++
    )
    {
        var g =
            raid_ground_items[i];


        var item =
            item_get(
                g.item_key
            );


        // ITEM RECTANGLE
        draw_set_color(c_lime);

        draw_rectangle(
            g.ground_x - 5,
            g.ground_y - 4,
            g.ground_x + 5,
            g.ground_y + 4,
            false
        );


        draw_set_color(c_black);

        draw_rectangle(
            g.ground_x - 3,
            g.ground_y - 2,
            g.ground_x + 3,
            g.ground_y + 2,
            false
        );


        // ITEM NAME
        draw_set_color(c_lime);
        draw_set_halign(fa_center);


        var _label =
            item.name;


        if (g.quantity > 1)
        {
            _label +=
                " x"
                + string(g.quantity);
        }


        draw_text_transformed(
            g.ground_x,
            g.ground_y - 13,

            _label,

            0.20,
            0.20,
            0
        );


        draw_set_halign(fa_left);
    }
}