function terminal_button(_left, _top, _right, _bottom, _label, _selected = false)
{
    var _old_color = draw_get_color();
    var _old_halign = draw_get_halign();
    var _old_valign = draw_get_valign();
    var _corner_radius = 4;
    var _middle_y = (_top + _bottom) * 0.5;

    var _fill_color = state == GameState.HIDEOUT
        ? (_selected ? global.hideout_raised_color : global.hideout_background_color)
        : (_selected ? make_color_rgb(5, 35, 20) : c_black);
    draw_set_color(_fill_color);
    draw_roundrect_ext(_left, _top, _right, _bottom, _corner_radius, _corner_radius, false);
    draw_set_color(_selected ? global.ui_interactive_color : global.ui_text_color);
    draw_roundrect_ext(_left, _top, _right, _bottom, _corner_radius, _corner_radius, true);

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    if (_selected) draw_text(_left + 13, _middle_y, ">");
    draw_text(_left + 38, _middle_y, _label);

    draw_set_color(_old_color);
    draw_set_halign(_old_halign);
    draw_set_valign(_old_valign);
}
