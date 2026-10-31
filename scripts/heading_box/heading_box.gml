function heading_box(_left, _top, _width, _height, _title, _heading_height = 72)
{
    var _old_alpha = draw_get_alpha();
    var _old_color = draw_get_color();
    var _old_halign = draw_get_halign();
    var _old_valign = draw_get_valign();
    var _right = _left + _width;
    var _bottom = _top + _height;
    var _heading_bottom = min(_bottom, _top + _heading_height);
    var _corner = min(12, min(_width, _heading_height) * 0.25);

    draw_set_alpha(1);
    draw_set_color(global.hideout_raised_color);
    draw_rectangle(_left, _top + _corner, _right, _heading_bottom, false);
    draw_rectangle(_left + _corner, _top, _right - _corner, _top + _corner, false);
    draw_triangle(_left, _top + _corner, _left + _corner, _top, _left + _corner, _top + _corner, false);
    draw_triangle(_right, _top + _corner, _right - _corner, _top, _right - _corner, _top + _corner, false);

    draw_set_color(global.hideout_border_color);
    draw_border_frame2(_left, _top, _width, _height, true);
    draw_set_alpha(1);
    draw_line(_left, _heading_bottom, _right, _heading_bottom);

    draw_set_color(global.ui_text_color);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(_left + 28, _top + ((_heading_height - string_height(_title)) * 0.5), _title);

    draw_set_alpha(_old_alpha);
    draw_set_color(_old_color);
    draw_set_halign(_old_halign);
    draw_set_valign(_old_valign);
}
