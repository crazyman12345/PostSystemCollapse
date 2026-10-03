function draw_item_info_popup(
    _item_key,
    _left = 1305,
    _top = 210,
    _width = 600,
    _height = 600
)
{
    var item = item_get(_item_key);

    if (!is_struct(item))
        return;

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);


    // ============================================================
    // FADE / ITEM CHANGE
    // ============================================================

    static _last_item_key = "";
    static _fade_alpha = 1;

    if (_last_item_key != _item_key)
    {
        _last_item_key = _item_key;
        _fade_alpha = 0.75;
    }

    _fade_alpha += 0.02;
    _fade_alpha = min(_fade_alpha, 1);

    draw_set_alpha(_fade_alpha);


    // ============================================================
    // BOX POSITIONS
    // ============================================================

    var _x1 = _left;
    var _y1 = _top;

    var _x2 = _x1 + _width;
    var _y2 = _y1 + _height;

    var _title_h = 34;

    var _image_right = _x1 + 220;
    var _name_bottom = _y1 + 120;
    var _stats_bottom = _y1 + 290;


    // ============================================================
    // WINDOW SHADOW
    // ============================================================

    draw_set_color(c_dkgray);

    draw_rectangle(
        _x1 + 6,
        _y1 + 6,
        _x2 + 6,
        _y2 + 6,
        false
    );


    // ============================================================
    // WINDOW BACKGROUND
    // ============================================================

    draw_set_color(c_black);

    draw_rectangle(
        _x1,
        _y1,
        _x2,
        _y2,
        false
    );


    // ============================================================
    // OUTER DOUBLE BORDER
    // ============================================================

    draw_set_color(c_lime);

    draw_rectangle(
        _x1,
        _y1,
        _x2,
        _y2,
        true
    );

    draw_rectangle(
        _x1 + 4,
        _y1 + 4,
        _x2 - 4,
        _y2 - 4,
        true
    );


    // ============================================================
    // TITLE BAR
    // ============================================================

    draw_set_color(c_lime);

    draw_rectangle(
        _x1 + 5,
        _y1 + 5,
        _x2 - 5,
        _y1 + _title_h,
        false
    );

    draw_set_color(c_black);
    draw_set_font(fnt_terminal_small);

    draw_text(
        _x1 + 15,
        _y1 + 10,
        "ITEM INFORMATION // INSPECT"
    );


    // ============================================================
    // FAKE WINDOW BUTTONS
    // ============================================================

    draw_rectangle(
        _x2 - 75,
        _y1 + 11,
        _x2 - 63,
        _y1 + 23,
        true
    );

    draw_rectangle(
        _x2 - 52,
        _y1 + 11,
        _x2 - 40,
        _y1 + 23,
        true
    );

    draw_rectangle(
        _x2 - 29,
        _y1 + 11,
        _x2 - 17,
        _y1 + 23,
        true
    );


    // ============================================================
    // MAIN DIVIDERS
    // ============================================================

    draw_set_color(c_lime);

    // Vertical divider between image and info
    draw_line(
        _image_right,
        _y1 + _title_h,
        _image_right,
        _stats_bottom
    );

    // Divider under item identity section
    draw_line(
        _image_right,
        _name_bottom,
        _x2,
        _name_bottom
    );

    // Divider above description
    draw_line(
        _x1,
        _stats_bottom,
        _x2,
        _stats_bottom
    );


    // ============================================================
    // ITEM IDENTITY
    // ============================================================

    draw_set_font(fnt_terminal_medium);
    draw_set_color(c_lime);

  draw_set_halign(fa_center);

		var _name_center_x =
		    (_image_right + _x2) * 0.5;

		draw_text(
		    _name_center_x,
		    _y1 + 52,
		    item.name
		);

		draw_set_halign(fa_left);


 draw_set_font(fnt_terminal_small);

    // ============================================================
    // ITEM IMAGE
    // ============================================================

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
        var _image_center_x =
            (_x1 + _image_right) * 0.5;

        var _image_center_y =
            ((_y1 + _title_h) + _stats_bottom) * 0.5;


        var _max_w = 120;
        var _max_h = 120;

        var _bbox_left = sprite_get_bbox_left(_sprite);
        var _bbox_top = sprite_get_bbox_top(_sprite);
        var _bbox_w = sprite_get_bbox_right(_sprite) - _bbox_left + 1;
        var _bbox_h = sprite_get_bbox_bottom(_sprite) - _bbox_top + 1;

        var _scale =
            min(
                _max_w / _bbox_w,
                _max_h / _bbox_h
            );


        draw_sprite_part_ext(
            _sprite,
            0,

            _bbox_left,
            _bbox_top,
            _bbox_w,
            _bbox_h,

            _image_center_x - (_bbox_w * _scale * 0.5),
            _image_center_y - (_bbox_h * _scale * 0.5),

            _scale,
            _scale,

            c_white,
            1
        );
    }
    else
    {
        draw_set_color(c_lime);
        draw_set_font(fnt_terminal_small);

        draw_text(
            _x1 + 55,
            _y1 + 150,
            "[ NO IMAGE ]"
        );
    }


    // ============================================================
    // SPECIFICATIONS HEADER
    // ============================================================

    draw_set_color(c_lime);
    draw_set_font(fnt_terminal_small);

    draw_text(
        _image_right + 12,
        _name_bottom + 8,
        "// SPECIFICATIONS"
    );


    // ============================================================
    // ITEM STATS
    // ============================================================

    draw_item_stats(
        item,
        _image_right + 20,
        _name_bottom + 38,
        _stats_bottom - 10
    );


    // ============================================================
    // DESCRIPTION HEADER
    // ============================================================

    draw_set_color(c_lime);
    draw_set_font(fnt_terminal_small);

    draw_text(
        _x1 + 15,
        _stats_bottom + 10,
        "// ITEM DESCRIPTION"
    );


    // ============================================================
    // DESCRIPTION TEXT
    // ============================================================

    if (variable_struct_exists(item, "description"))
    {
        draw_text_ext(
            _x1 + 25,
            _stats_bottom + 42,

            item.description,

            25,
            (_x2 - _x1) - 50
        );
    }


    // ============================================================
    // LOADING / RECORD MESSAGE
    // ============================================================

    if (_fade_alpha < 0.30)
    {
        draw_set_color(c_lime);
        draw_set_font(fnt_terminal_small);

        draw_text(
            _x1 + 20,
            _y2 - 30,
            "READING ITEM RECORD..."
        );
    }


    // ============================================================
    // SCANLINES
    // ============================================================

    draw_set_alpha(_fade_alpha * 0.08);
    draw_set_color(c_lime);

    for (
        var _scan_y = _y1 + _title_h + 5;
        _scan_y < _y2 - 5;
        _scan_y += 6
    )
    {
        draw_line(
            _x1 + 6,
            _scan_y,
            _x2 - 6,
            _scan_y
        );
    }


    // ============================================================
    // RESTORE DRAW STATE
    // ============================================================

    draw_set_alpha(1);
    draw_set_color(c_lime);
}
