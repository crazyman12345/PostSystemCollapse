function draw_inventory_character_tabs(_left, _top)
{
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var _labels = ["EQP", "HEAL"];
    var _tab_width = 68;
    var _tab_height = 26;

    draw_set_font(fnt_terminal_tiny);
    draw_set_valign(fa_middle);
    for (var i = 0; i < 2; i++)
    {
        var _x = _left + (i * (_tab_width + 6));
        var _selected = inventory_character_tab == i;
        var _hovered = _mouse_x >= _x && _mouse_x < _x + _tab_width
            && _mouse_y >= _top && _mouse_y < _top + _tab_height;
        draw_set_color(_selected ? make_color_rgb(8, 45, 18) : c_black);
        draw_rectangle(_x, _top, _x + _tab_width, _top + _tab_height, false);
        draw_set_color(global.ui_interactive_color);
        draw_rectangle(_x, _top, _x + _tab_width, _top + _tab_height, true);
        draw_set_halign(fa_center);
        draw_text(_x + (_tab_width * 0.5), _top + (_tab_height * 0.5), _labels[i]);
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

function draw_inventory_health_interface(_equipment_left, _grid_top)
{
    draw_inventory_global_health_box(_equipment_left + 155, _grid_top + 370, 140, 68);
    var _boxes = [
        { limb: PlayerLimb.HEAD, left: _equipment_left + 165, top: _grid_top + 8, width: 120 },
        { limb: PlayerLimb.CHEST, left: _equipment_left + 155, top: _grid_top + 145, width: 140 },
        { limb: PlayerLimb.RIGHT_ARM, left: _equipment_left + 2, top: _grid_top + 230, width: 142 },
        { limb: PlayerLimb.LEFT_ARM, left: _equipment_left + 306, top: _grid_top + 230, width: 142 },
        { limb: PlayerLimb.RIGHT_LEG, left: _equipment_left + 18, top: _grid_top + 515, width: 142 },
        { limb: PlayerLimb.LEFT_LEG, left: _equipment_left + 290, top: _grid_top + 515, width: 142 }
    ];

    var _hovered_condition = "";
    for (var i = 0; i < array_length(_boxes); i++)
    {
        var _box = _boxes[i];
        var _condition = draw_inventory_limb_box(_box.left, _box.top, _box.width, 68, _box.limb);
        if (_condition != "") _hovered_condition = _condition;
    }

    if (_hovered_condition != "") draw_inventory_injury_tooltip(_hovered_condition);
}

function draw_inventory_global_health_box(_left, _top, _width, _height)
{
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var _hovered = _mouse_x >= _left && _mouse_x < _left + _width
        && _mouse_y >= _top && _mouse_y < _top + _height;
    var _percent = raid_player_hp / max(1, raid_player_max_hp);
    var _color = _percent < 0.5 ? c_red : (_percent < 1 ? c_yellow : global.ui_text_color);

    draw_set_color(c_black);
    draw_rectangle(_left, _top, _left + _width, _top + _height, false);
    draw_set_color(global.ui_interactive_color);
    draw_rectangle(_left, _top, _left + _width, _top + _height, true);
    draw_set_font(fnt_terminal_tiny);
    draw_set_color(global.ui_text_color);
    draw_text(_left + 5, _top + 4, "GLOBAL HP");
    draw_set_color(_color);
    draw_text(_left + 5, _top + 25, string(round(raid_player_hp)) + "/" + string(round(raid_player_max_hp)));

    var _bar_left = _left + 5;
    var _bar_top = _top + _height - 13;
    var _bar_width = _width - 10;
    draw_set_color(make_color_rgb(24, 24, 24));
    draw_rectangle(_bar_left, _bar_top, _bar_left + _bar_width, _bar_top + 7, false);
    draw_set_color(_color);
    draw_rectangle(_bar_left + 1, _bar_top + 1, _bar_left + 1 + ((_bar_width - 2) * _percent), _bar_top + 6, false);
}

function draw_inventory_limb_box(_left, _top, _width, _height, _limb_index)
{
    var _limb = health_limbs[_limb_index];
    var _color = global.ui_text_color;
    if (_limb.injury == LimbInjuryState.WOUNDED) _color = c_yellow;
    if (_limb.injury == LimbInjuryState.BLACKED_OUT) _color = make_color_rgb(150, 35, 35);
    if (_limb.fractured) _color = make_color_rgb(255, 145, 45);
    if (player_health_limb_has_bleed(_limb, LimbBleedState.LIGHT)) _color = c_yellow;
    if (player_health_limb_has_bleed(_limb, LimbBleedState.HEAVY)) _color = c_red;

    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var _hovered = _mouse_x >= _left && _mouse_x < _left + _width
        && _mouse_y >= _top && _mouse_y < _top + _height;
    draw_set_color(c_black);
    draw_rectangle(_left, _top, _left + _width, _top + _height, false);
    draw_set_color(global.ui_interactive_color);
    draw_rectangle(_left, _top, _left + _width, _top + _height, true);

    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(global.ui_text_color);
    draw_text(_left + 5, _top + 4, _limb.name);
    draw_set_color(_color);
    draw_text(_left + 5, _top + 25, string(round(_limb.hp)) + "/" + string(round(_limb.max_hp)));

    var _conditions = [
        { active: player_health_limb_has_bleed(_limb, LimbBleedState.LIGHT), subimage: 0, tooltip: "LIGHT BLEED\nSlow health loss." },
        { active: player_health_limb_has_bleed(_limb, LimbBleedState.HEAVY), subimage: 1, tooltip: "HEAVY BLEED\nRapid health loss." },
        { active: _limb.fractured, subimage: 2, tooltip: "FRACTURE\nLimb performance reduced." },
        { active: _limb.injury == LimbInjuryState.BLACKED_OUT, subimage: 3, tooltip: "BLACKED-OUT LIMB\nLimb is disabled." }
    ];
    var _icon_size = 12;
    var _icon_spacing = 3;
    var _icons_left = _left + 1;
    var _icons_top = _top + _height + 4;
    var _hovered_condition = "";

    for (var i = 0; i < array_length(_conditions); i++)
    {
        var _condition = _conditions[i];
        if (!_condition.active) continue;

        var _icon_left = _icons_left + (i * (_icon_size + _icon_spacing));
        draw_set_color(c_black);
        draw_rectangle(_icon_left - 1, _icons_top - 1, _icon_left + _icon_size, _icons_top + _icon_size, false);
        draw_set_color(c_green);
        draw_rectangle(_icon_left - 1, _icons_top - 1, _icon_left + _icon_size, _icons_top + _icon_size, true);
        var _icon_scale = _icon_size / sprite_get_width(Health_icons);
        draw_sprite_ext(Health_icons, _condition.subimage, _icon_left, _icons_top, _icon_scale, _icon_scale, 0, c_white, 1);

        if (_mouse_x >= _icon_left && _mouse_x < _icon_left + _icon_size
        && _mouse_y >= _icons_top && _mouse_y < _icons_top + _icon_size)
            _hovered_condition = _condition.tooltip;
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _bar_left = _left + 5;
    var _bar_top = _top + _height - 13;
    var _bar_width = _width - 10;
    draw_set_color(make_color_rgb(24, 24, 24));
    draw_rectangle(_bar_left, _bar_top, _bar_left + _bar_width, _bar_top + 7, false);
    draw_set_color(_color);
    draw_rectangle(_bar_left + 1, _bar_top + 1, _bar_left + 1 + ((_bar_width - 2) * (_limb.hp / max(1, _limb.max_hp))), _bar_top + 6, false);

    return _hovered_condition;
}

function draw_inventory_injury_tooltip(_text)
{
    var _padding = 7;
    var _width = 250;
    var _height = 43;
    var _left = device_mouse_x_to_gui(0) + 14;
    var _top = device_mouse_y_to_gui(0) + 14;
    _left = clamp(_left, 0, display_get_gui_width() - _width);
    _top = clamp(_top, 0, display_get_gui_height() - _height);

    draw_set_color(c_black);
    draw_rectangle(_left, _top, _left + _width, _top + _height, false);
    draw_set_color(c_green);
    draw_rectangle(_left, _top, _left + _width, _top + _height, true);
    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(global.ui_text_color);
    draw_text(_left + _padding, _top + _padding, _text);
}
