function draw_raid_ammo_ui()
{
    var _weapon = raid_update_active_weapon();
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _panel_w = 451;
    var _panel_h = 120;
    var _panel_left = _gui_w - _panel_w - 20;
    var _panel_top = _gui_h - _panel_h - 20;
    var _panel_right = _panel_left + _panel_w;
    var _panel_bottom = _panel_top + _panel_h;

    draw_terminal_rectangle(_panel_left, _panel_top, _panel_right, _panel_bottom);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _icon_left = _panel_left + 10;
    var _icon_top = _panel_top + 10;
    var _icon_right = _icon_left + 96;
    var _icon_bottom = _panel_bottom - 10;
    draw_terminal_rectangle(_icon_left, _icon_top, _icon_right, _icon_bottom, c_dkgray, 0.72);

    if (!is_struct(_weapon))
    {
        draw_set_font(fnt_terminal);
        draw_set_color(c_lime);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text((_icon_left + _icon_right) * 0.5, (_icon_top + _icon_bottom) * 0.5, "?");

        draw_set_font(fnt_terminal);
        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text(_icon_right + 13, _panel_top + 16, "KNIFE");
        draw_set_color(c_white);
        return;
    }

    if (variable_struct_exists(_weapon, "weapon_sprite") && sprite_exists(_weapon.weapon_sprite))
    {
        var _sprite = _weapon.weapon_sprite;
        var _sprite_w = sprite_get_width(_sprite);
        var _sprite_h = sprite_get_height(_sprite);
        var _sprite_scale = min(80 / _sprite_w, 80 / _sprite_h);
        var _sprite_left = _icon_left + ((96 - (_sprite_w * _sprite_scale)) * 0.5);
        var _sprite_top = _icon_top + (((_icon_bottom - _icon_top) - (_sprite_h * _sprite_scale)) * 0.5);
        draw_sprite_ext(
            _sprite,
            0,
            _sprite_left + (sprite_get_xoffset(_sprite) * _sprite_scale),
            _sprite_top + (sprite_get_yoffset(_sprite) * _sprite_scale),
            _sprite_scale,
            _sprite_scale,
            0,
            c_white,
            1
        );
    }

    var _mode_text = "SEMI";
    switch (raid_current_fire_mode)
    {
        case WeaponFireMode.BURST: _mode_text = "BURST"; break;
        case WeaponFireMode.AUTO: _mode_text = "FULL AUTO"; break;
    }

    var _mode_left = _panel_right - 93;
    var _mode_top = _panel_top + 11;
    draw_terminal_rectangle(_mode_left, _mode_top, _panel_right - 11, _mode_top + 26, c_green, 0.65);
    draw_set_font(fnt_terminal_tiny);
    draw_set_color(c_lime);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text((_mode_left + _panel_right - 11) * 0.5, _mode_top + 13, _mode_text);

    var _details_left = _icon_right + 13;
    var _name_right = _mode_left - 10;
    var _weapon_name = string_upper(_weapon.name);
    draw_set_font(fnt_terminal_small);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var _name_scale = min(1, (_name_right - _details_left) / max(1, string_width(_weapon_name)));
    draw_text_transformed(_details_left, _panel_top + 14, _weapon_name, _name_scale, 1, 0);

    draw_set_font(fnt_terminal);
    draw_text(_details_left, _panel_top + 43, string(raid_weapon_mag) + " / " + string(_weapon.mag_size));

    var _reserve = raid_bag_get_quantity(_weapon.ammo_key);
    draw_set_font(fnt_terminal_small);
    draw_set_color(c_green);
    draw_text(_details_left, _panel_top + 83, "RESERVE " + string(_reserve));

    if (raid_reload_active)
    {
        draw_set_font(fnt_terminal_tiny);
        draw_set_color(c_lime);
        draw_text(_details_left, _panel_top + 104, "RELOADING...");
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
