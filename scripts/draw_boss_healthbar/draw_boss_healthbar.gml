function draw_boss_healthbar(_boss)
{
    var _gui_w = display_get_gui_width();
    var _bar_w = min(520, _gui_w - 40);
    var _bar_h = 18;
    var _x = (_gui_w - _bar_w) * 0.5;
    var _panel_y = 16;
    var _bar_y = _panel_y + 30;
    var _total_hp_percent = clamp(
        _boss.enemy_hp / max(1, _boss.enemy_max_hp),
        0,
        1
    );
    var _hp_percent = _total_hp_percent <= 0.5
        ? _total_hp_percent * 2
        : (_total_hp_percent - 0.5) * 2;
    var _segments = 24;
    var _segment_gap = 3;
    var _segment_w = (_bar_w - ((_segments - 1) * _segment_gap)) / _segments;
    var _terminal_green = c_red;
    var _terminal_cyan = make_color_rgb(80, 220, 255);
    var _terminal_dark = make_color_rgb(8, 30, 24);
    var _terminal_empty = make_color_rgb(20, 48, 42);

    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

	// CRT-style panel and border.
	draw_terminal_rectangle(_x - 12, _panel_y - 8, _x + _bar_w + 12, _bar_y + _bar_h + 22, _terminal_cyan);
	draw_set_font(fnt_terminal);
    draw_set_color(c_white);
    draw_text(_gui_w * 0.5, _panel_y + 7, raid_enemy_type_name(_boss.enemy_type));

    for (var i = 0; i < _segments; i++)
    {
        var _segment_x = _x + i * (_segment_w + _segment_gap);
        var _segment_filled = (i + 1) / _segments <= _hp_percent;

        draw_set_color(_segment_filled ? _terminal_green : _terminal_empty);
        draw_rectangle(
            _segment_x,
            _bar_y,
            _segment_x + _segment_w,
            _bar_y + _bar_h,
            false
        );
    }

    draw_set_color(_terminal_cyan);
    draw_rectangle(_x - 2, _bar_y - 2, _x + _bar_w + 2, _bar_y + _bar_h + 2, true);


    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
