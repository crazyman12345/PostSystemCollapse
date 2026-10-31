function terminal_panel(
    _left,
    _top,
    _width,
    _height,
    _title,
    _active = false
)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    var title_text = "[ " + _title + " ]";

    if (_active)
    {
        title_text =
            ">>> " + title_text + " <<<";
    }

    terminal_panel_scanlines_queue(_left, _top, _width, _height, title_text);
    terminal_panel_draw_frame(_left, _top, _width, _height);

    draw_text(
        _left + _width/2,
        _top + 7,
        title_text
    );
    draw_set_halign(fa_left);
}

function terminal_panel_draw_frame(_left, _top, _width, _height)
{
    draw_border_frame2(_left, _top, _width, _height, true);
}

function terminal_panel_scanlines_begin()
{
    terminal_panel_scanline_panels = [];
    terminal_panel_drawn_this_frame = false;
}

function terminal_panel_scanlines_queue(_left, _top, _width, _height, _title_text)
{
    array_push(terminal_panel_scanline_panels, {
        left: _left,
        top: _top,
        width: _width,
        height: _height,
        frame_color: draw_get_color(),
        frame_alpha: draw_get_alpha(),
        title_text: _title_text,
        title_font: draw_get_font()
    });
    terminal_panel_drawn_this_frame = true;
}

function terminal_panel_scanlines_draw()
{
    var _old_alpha = draw_get_alpha();
    var _old_color = draw_get_color();
    var _old_font = draw_get_font();
    var _old_halign = draw_get_halign();
    var _old_valign = draw_get_valign();

    terminal_panel_scratch_overlay_draw();

    for (var _panel_i = 0; _panel_i < array_length(terminal_panel_scanline_panels); _panel_i++)
    {
        var _panel = terminal_panel_scanline_panels[_panel_i];
        draw_set_alpha(_panel.frame_alpha);
        draw_set_color(_panel.frame_color);
        terminal_panel_draw_frame(_panel.left, _panel.top, _panel.width, _panel.height);
        draw_set_font(_panel.title_font);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_text(_panel.left + _panel.width/2, _panel.top + 7, _panel.title_text);
    }

    terminal_panel_scanline_panels = [];
    draw_set_alpha(_old_alpha);
    draw_set_color(_old_color);
    draw_set_font(_old_font);
    draw_set_halign(_old_halign);
    draw_set_valign(_old_valign);
}

function terminal_panel_scratch_overlay_draw()
{
    if (array_length(terminal_panel_scanline_panels) <= 0) return;

    var _old_alpha = draw_get_alpha();
    var _old_color = draw_get_color();

    draw_set_alpha(1);
    draw_set_color(c_white);
    gpu_set_blendmode(bm_add);

    for (var _panel_i = 0; _panel_i < array_length(terminal_panel_scanline_panels); _panel_i++)
    {
        var _panel = terminal_panel_scanline_panels[_panel_i];
        draw_sprite_stretched(scratch_overlay, 0, _panel.left, _panel.top, _panel.width, _panel.height);
    }

    gpu_set_blendmode(bm_normal);
    draw_set_alpha(_old_alpha);
    draw_set_color(_old_color);
}

function draw_player_status_panel(_x, _y, _width, _compact = false)
{
    var _old_alpha = draw_get_alpha();
    var _old_color = draw_get_color();
    var _old_font = draw_get_font();
    var _old_halign = draw_get_halign();
    var _old_valign = draw_get_valign();
    var _health = raid_player_hp;
    var _max_health = raid_player_max_hp;
    var _hunger = player_energy;
    var _max_hunger = health_config.survival_max;
    var _thirst = player_hydration;
    var _max_thirst = health_config.survival_max;
    var _weight = raid_bag_get_weight();
    var _max_weight = raid_get_max_weight();
    var _header_height = _compact ? 26 : 30;
    var _row_height = _compact ? 29 : 34;
    var _bar_height = _compact ? 6 : 8;
    var _panel_height = _header_height + (_row_height * 5) + 8;
    var _content_x = _x + 10;
    var _content_width = _width - 20;

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_terminal_tiny);

    draw_set_color(state == GameState.HIDEOUT ? global.hideout_background_color : c_black);
    draw_rectangle(_x, _y, _x + _width, _y + _panel_height, false);
    draw_set_color(state == GameState.HIDEOUT ? global.hideout_border_subtle_color : c_dkgray);
    draw_rectangle(_x, _y, _x + _width, _y + _panel_height, true);
    draw_line(_x, _y + _header_height, _x + _width, _y + _header_height);

    draw_set_color(global.ui_text_color);
    draw_set_halign(fa_center);
    draw_text(_x + (_width * 0.5), _y + 6, "[ STATUS ]");
    draw_set_halign(fa_left);

    var _row_y = _y + _header_height + 5;
    draw_player_status_bar(_content_x, _row_y, _content_width, _bar_height, "HEALTH", _health, _max_health);
    _row_y += _row_height;
    draw_player_status_bar(_content_x, _row_y, _content_width, _bar_height, "STAMINA", raid_player_stamina, raid_player_max_stamina);
    _row_y += _row_height;
    draw_player_status_bar(_content_x, _row_y, _content_width, _bar_height, "HUNGER", _hunger, _max_hunger);
    _row_y += _row_height;
    draw_player_status_bar(_content_x, _row_y, _content_width, _bar_height, "THIRST", _thirst, _max_thirst);
    _row_y += _row_height;
    draw_player_status_bar(_content_x, _row_y, _content_width, _bar_height, "WEIGHT", _weight, _max_weight, true);

    draw_set_alpha(_old_alpha);
    draw_set_color(_old_color);
    draw_set_font(_old_font);
    draw_set_halign(_old_halign);
    draw_set_valign(_old_valign);
}

function draw_player_status_bar(_x, _y, _width, _height, _label, _current, _maximum, _weight = false)
{
    var _fill = clamp(_current / max(1, _maximum), 0, 1);
    var _overweight = _weight && _current >= _maximum;
    var _value_text;

    if (_weight)
    {
        _value_text = string_format(_current, 1, 1) + " / " + string_format(_maximum, 1, 1) + " KG";
        if (_overweight) _value_text += "  OVERWEIGHT";
    }
    else
    {
        _value_text = string(round(_current)) + " / " + string(round(_maximum));
    }

    draw_set_color(global.ui_text_color);
    draw_text(_x, _y, _label);
    draw_set_halign(fa_right);
    draw_set_color(_overweight ? c_red : global.ui_text_color);
    draw_text(_x + _width, _y, _value_text);
    draw_set_halign(fa_left);

    var _bar_y = _y + 16;
    draw_set_color(state == GameState.HIDEOUT ? global.hideout_background_color : make_color_rgb(24, 24, 24));
    draw_rectangle(_x, _bar_y, _x + _width, _bar_y + _height, false);

    if (_fill > 0)
    {
        draw_set_color(_overweight ? c_red : (state == GameState.HIDEOUT ? global.hideout_secondary_color : c_green));
        draw_rectangle(_x + 1, _bar_y + 1, _x + 1 + ((_width - 2) * _fill), _bar_y + _height - 1, false);
    }

    draw_set_color(state == GameState.HIDEOUT ? global.hideout_border_subtle_color : c_dkgray);
    draw_rectangle(_x, _bar_y, _x + _width, _bar_y + _height, true);
}
