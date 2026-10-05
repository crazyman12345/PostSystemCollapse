function draw_equipment_slot(
    _x,
    _y,
    _width,
    _height,
    _label,
    _item_key,
    _selected,
    _subtle = false
)
{
    var previous_alpha = draw_get_alpha();

    draw_set_color(c_black);
	draw_set_font(fnt_terminal_tiny);
    draw_set_alpha(min(previous_alpha, 0.6));
    draw_rectangle(_x, _y, _x + _width, _y + _height, false);
    draw_set_alpha(previous_alpha);

    if (_subtle)
    {
        draw_set_color(_selected ? c_lime : c_dkgray);
    }
    else
    {
        draw_set_color(c_lime);
    }

    draw_rectangle(_x, _y, _x + _width, _y + _height, true);

    if (_subtle)
    {
        draw_set_color(_selected ? c_lime : c_gray);
    }

    draw_text_transformed(
        _x + 6,
        _y + 3,
        _label,
        1,
        1,
        0
    );
    draw_line(_x + 4, _y + 19, _x + _width - 4, _y + 19);

    var item_name = "NONE";
    var item_sprite = -1;

    if (_item_key != "")
    {
        var item = item_get(_item_key);

        if (!is_undefined(item))
        {
            item_name = item.name;

            if (variable_struct_exists(item, "icon_sprite")) item_sprite = item.icon_sprite;
            if ((item_sprite == -1 || !sprite_exists(item_sprite)) && variable_struct_exists(item, "weapon_sprite")) item_sprite = item.weapon_sprite;
            if ((item_sprite == -1 || !sprite_exists(item_sprite)) && variable_struct_exists(item, "sprite_idle")) item_sprite = item.sprite_idle;
        }
    }

    var has_item_sprite = item_sprite != -1 && sprite_exists(item_sprite);
    var render_sprite = item_sprite;
    if (!has_item_sprite && _item_key != "" && sprite_exists(spr_error)) render_sprite = spr_error;

    if (render_sprite != -1 && sprite_exists(render_sprite))
    {
        var padding = 8;
        var available_width = max(1, _width - (padding * 2));
        var available_height = max(1, _height - 27 - padding);
        var sprite_visible_left = sprite_get_bbox_left(render_sprite);
        var sprite_visible_top = sprite_get_bbox_top(render_sprite);
        var sprite_visible_width = sprite_get_bbox_right(render_sprite) - sprite_visible_left + 1;
        var sprite_visible_height = sprite_get_bbox_bottom(render_sprite) - sprite_visible_top + 1;
        var sprite_scale = min(available_width / sprite_visible_width, available_height / sprite_visible_height);
        var sprite_center_x = _x + (_width * 0.5);
        var sprite_center_y = _y + 20 + ((available_height + padding) * 0.5);
        var sprite_offset_x = (sprite_visible_left + (sprite_visible_width * 0.5) - sprite_get_xoffset(render_sprite)) * sprite_scale;
        var sprite_offset_y = (sprite_visible_top + (sprite_visible_height * 0.5) - sprite_get_yoffset(render_sprite)) * sprite_scale;

        draw_set_color(_selected ? c_lime : c_gray);
        draw_rectangle(
            sprite_center_x - ((sprite_visible_width * sprite_scale) * 0.5) - 4,
            sprite_center_y - ((sprite_visible_height * sprite_scale) * 0.5) - 4,
            sprite_center_x + ((sprite_visible_width * sprite_scale) * 0.5) + 4,
            sprite_center_y + ((sprite_visible_height * sprite_scale) * 0.5) + 4,
            false
        );

        draw_sprite_ext(
            render_sprite,
            0,
            sprite_center_x - sprite_offset_x,
            sprite_center_y - sprite_offset_y,
            sprite_scale,
            sprite_scale,
            0,
            c_white,
            1
        );
    }

    if (!has_item_sprite && _selected)
    {
        if (_subtle) draw_set_color(c_lime);
        draw_text(
            _subtle ? _x + 10 : _x + 40,
            _subtle ? _y + 29 : _y + 35,
            "> " + item_name
        );
    }
    else if (!has_item_sprite)
    {
        if (_subtle) draw_set_color(_item_key == "" ? c_dkgray : c_gray);
        draw_text(
            _subtle ? _x + 10 : _x + 40,
            _subtle ? _y + 29 : _y + 35,
            "  " + item_name
        );
    }

    if (_subtle) draw_set_color(c_lime);
}
