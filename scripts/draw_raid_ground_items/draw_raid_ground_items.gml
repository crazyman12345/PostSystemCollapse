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


        // ITEM IMAGE
        var _sprite = -1;

        if (
            variable_struct_exists(item, "icon_sprite")
            && item.icon_sprite != -1
        )
        {
            _sprite = item.icon_sprite;
        }
        else if (
            variable_struct_exists(item, "weapon_sprite")
            && item.weapon_sprite != -1
        )
        {
            _sprite = item.weapon_sprite;
        }
        else if (
            variable_struct_exists(item, "sprite_idle")
            && item.sprite_idle != -1
        )
        {
            _sprite = item.sprite_idle;
        }


        if (_sprite != -1)
        {
            var _bbox_left = sprite_get_bbox_left(_sprite);
            var _bbox_top = sprite_get_bbox_top(_sprite);
            var _bbox_w = sprite_get_bbox_right(_sprite) - _bbox_left + 1;
            var _bbox_h = sprite_get_bbox_bottom(_sprite) - _bbox_top + 1;
            var _scale = min(10 / _bbox_w, 8 / _bbox_h);

            draw_sprite_part_ext(
                _sprite,
                icon_spin_frame(_sprite),

                _bbox_left,
                _bbox_top,
                _bbox_w,
                _bbox_h,

                g.ground_x - (_bbox_w * _scale * 0.5),
                g.ground_y - (_bbox_h * _scale * 0.5),

                _scale,
                _scale,

                c_white,
                1
            );
        }
        else
        {
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
        }


        // ITEM NAME
        draw_set_color(c_white);
        draw_set_font(fnt_terminal_medium);
        draw_set_halign(fa_center);


        var _label =
            item.name;


        if (g.quantity > 1)
        {
            _label +=
                " x"
                + string(g.quantity);
        }


        var _label_y =
            g.ground_y - 13;

        if (string_width(_label) > 180)
        {
            _label_y -= 7;
        }


        draw_text_ext_transformed(
            g.ground_x,
            _label_y,

            _label,

            -1,
            180,

            0.22,
            0.22,
            0
        );


        draw_set_halign(fa_left);
    }
}
