function draw_raid_lootables(_labels_only = false)
{
    draw_set_font(fnt_terminal_medium);


    for (
        var i = 0;
        i < array_length(raid_lootables);
        i++
    )
    {
        var l =
            raid_lootables[i];

        var _sprite = variable_struct_exists(l, "sprite_index") ? l.sprite_index : -1;

        var _x1 = l.lootable_x - l.width * 0.5;
        var _y1 = l.lootable_y - l.height * 0.5;
        var _x2 = l.lootable_x + l.width * 0.5;
        var _y2 = l.lootable_y + l.height * 0.5;

        if (_sprite >= 0)
        {
            var _sprite_x = variable_struct_exists(l, "sprite_x") ? l.sprite_x : l.lootable_x;
            var _sprite_y = variable_struct_exists(l, "sprite_y") ? l.sprite_y : l.lootable_y;
            var _xscale = variable_struct_exists(l, "image_xscale") ? l.image_xscale : 1;
            var _yscale = variable_struct_exists(l, "image_yscale") ? l.image_yscale : 1;
            var _sprite_left = _sprite_x + (sprite_get_bbox_left(_sprite) - sprite_get_xoffset(_sprite)) * _xscale;
            var _sprite_right = _sprite_x + (sprite_get_bbox_right(_sprite) + 1 - sprite_get_xoffset(_sprite)) * _xscale;
            var _sprite_top = _sprite_y + (sprite_get_bbox_top(_sprite) - sprite_get_yoffset(_sprite)) * _yscale;
            var _sprite_bottom = _sprite_y + (sprite_get_bbox_bottom(_sprite) + 1 - sprite_get_yoffset(_sprite)) * _yscale;

            _x1 = min(_sprite_left, _sprite_right);
            _y1 = min(_sprite_top, _sprite_bottom);
            _x2 = max(_sprite_left, _sprite_right);
            _y2 = max(_sprite_top, _sprite_bottom);
        }


        // BODY
        if (!_labels_only && _sprite >= 0)
        {
            draw_sprite_ext(
                _sprite,
                variable_struct_exists(l, "image_index") ? l.image_index : 0,
                variable_struct_exists(l, "sprite_x") ? l.sprite_x : l.lootable_x,
                variable_struct_exists(l, "sprite_y") ? l.sprite_y : l.lootable_y,
                variable_struct_exists(l, "image_xscale") ? l.image_xscale : 1,
                variable_struct_exists(l, "image_yscale") ? l.image_yscale : 1,
                variable_struct_exists(l, "image_angle") ? l.image_angle : 0,
                c_white,
                1
            );
        }
        else if (!_labels_only)
        {
            draw_set_color(c_dkgray);
            draw_rectangle(_x1, _y1, _x2, _y2, false);
        }


        if (!_labels_only) continue;

		draw_set_color(global.ui_interactive_color);
        // LABEL
        draw_set_halign(fa_center);

        draw_text_transformed(
            l.lootable_x,
            _y1 - 8,

            raid_reward_name(
                l.reward_type
            ),

            0.25,
            0.25,
            0
        );

        draw_set_halign(fa_left);
    }
}
