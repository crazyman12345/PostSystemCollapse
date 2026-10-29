function draw_raid_health_ui()
{
    var _panel_left = 20;
    var _panel_top = 20;
    var _panel_right = 450;
    var _panel_bottom = 98;
    var _bar_left = 72;
    var _bar_width = 340;
    var _health_top = 32;
    var _health_height = 24;
    var _stamina_top = 66;
    var _stamina_height = 18;
    var _health_percent = clamp(raid_player_hp / max(1, raid_player_max_hp), 0, 1);
    var _stamina_percent = clamp(raid_player_stamina / max(1, raid_player_max_stamina), 0, 1);
    draw_terminal_rectangle(_panel_left, _panel_top, _panel_right, _panel_bottom);

    draw_raid_health_heart_icon(47, _health_top + (_health_height * 0.5), 22);
    draw_raid_stamina_bolt_icon(47, _stamina_top + (_stamina_height * 0.5), 23);

    draw_set_color(make_color_rgb(28, 28, 28));
    draw_rectangle(_bar_left, _health_top, _bar_left + _bar_width, _health_top + _health_height, false);
    draw_set_color(c_red);
    draw_rectangle(_bar_left + 2, _health_top + 2, _bar_left + 2 + ((_bar_width - 4) * _health_percent), _health_top + _health_height - 2, false);
    draw_set_color(c_gray);
    draw_rectangle(_bar_left, _health_top, _bar_left + _bar_width, _health_top + _health_height, true);

    draw_set_color(make_color_rgb(28, 28, 28));
    draw_rectangle(_bar_left, _stamina_top, _bar_left + _bar_width, _stamina_top + _stamina_height, false);
    draw_set_color(c_yellow);
    draw_rectangle(_bar_left + 2, _stamina_top + 2, _bar_left + 2 + ((_bar_width - 4) * _stamina_percent), _stamina_top + _stamina_height - 2, false);
    draw_set_color(c_gray);
    draw_rectangle(_bar_left, _stamina_top, _bar_left + _bar_width, _stamina_top + _stamina_height, true);

    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_right);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_bar_left + _bar_width - 7, _health_top + (_health_height * 0.5), string(round(raid_player_hp)) + " / " + string(round(raid_player_max_hp)));
    draw_text(_bar_left + _bar_width - 7, _stamina_top + (_stamina_height * 0.5), string(round(raid_player_stamina)) + " / " + string(round(raid_player_max_stamina)));

    draw_set_color(c_white);
    var _silhouette_scale = 0.0975;
    draw_sprite_ext(spr_raid_health_silhouette, 0, 77, 112, _silhouette_scale, _silhouette_scale, 0, c_white, 0.75);

    draw_raid_limb_condition_bar(88.7, 117.2, PlayerLimb.HEAD, 1.3);
    draw_raid_limb_condition_bar(88.7, 147.1, PlayerLimb.CHEST, 1.3);
    draw_raid_limb_condition_bar(56.2, 151, PlayerLimb.RIGHT_ARM, 1.3);
    draw_raid_limb_condition_bar(121.2, 151, PlayerLimb.LEFT_ARM, 1.3);
    draw_raid_limb_condition_bar(74.4, 197.8, PlayerLimb.RIGHT_LEG, 1.3);
    draw_raid_limb_condition_bar(103, 197.8, PlayerLimb.LEFT_LEG, 1.3);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

function draw_raid_limb_condition_bar(_left, _top, _limb_index, _scale = 1)
{
    var _limb = health_limbs[_limb_index];
    var _color = c_lime;
    if (_limb.injury == LimbInjuryState.WOUNDED) _color = c_yellow;
    if (_limb.injury == LimbInjuryState.BLACKED_OUT) _color = make_color_rgb(150, 35, 35);
    if (_limb.fractured) _color = make_color_rgb(255, 145, 45);
    if (player_health_limb_has_bleed(_limb, LimbBleedState.LIGHT)) _color = c_yellow;
    if (player_health_limb_has_bleed(_limb, LimbBleedState.HEAVY)) _color = c_red;

    var _bar_width = 22 * _scale;
    var _bar_height = 4 * _scale;
    var _percent = clamp(_limb.hp / max(1, _limb.max_hp), 0, 1);
    draw_set_color(make_color_rgb(24, 24, 24));
    draw_rectangle(_left, _top, _left + _bar_width, _top + _bar_height, false);
    draw_set_color(_color);
    draw_rectangle(_left + 1, _top + 1, _left + 1 + ((_bar_width - 2) * _percent), _top + _bar_height - 1, false);

    var _conditions = [
        player_health_limb_has_bleed(_limb, LimbBleedState.LIGHT),
        player_health_limb_has_bleed(_limb, LimbBleedState.HEAVY),
        _limb.fractured,
        _limb.injury == LimbInjuryState.BLACKED_OUT
    ];
    var _icon_size = 7 * _scale;
    var _icon_left = _left + _bar_width + (2 * _scale);
    var _icon_scale = _icon_size / sprite_get_width(Health_icons);
    draw_set_color(c_white);

    for (var i = 0; i < array_length(_conditions); i++)
    {
        if (!_conditions[i]) continue;
        draw_sprite_ext(Health_icons, i, _icon_left, _top - _scale, _icon_scale, _icon_scale, 0, c_white, 1);
        _icon_left += _icon_size + _scale;
    }
}

function draw_raid_health_heart_icon(_x, _y, _size)
{
    draw_set_color(c_red);
    draw_circle(_x - (_size * 0.19), _y - (_size * 0.15), _size * 0.27, false);
    draw_circle(_x + (_size * 0.19), _y - (_size * 0.15), _size * 0.27, false);
    draw_triangle(
        _x - (_size * 0.43), _y - (_size * 0.05),
        _x + (_size * 0.43), _y - (_size * 0.05),
        _x, _y + (_size * 0.48),
        false
    );
}

function draw_raid_stamina_bolt_icon(_x, _y, _size)
{
    draw_set_color(c_yellow);
    draw_triangle(
        _x + (_size * 0.08), _y - (_size * 0.5),
        _x - (_size * 0.33), _y + (_size * 0.04),
        _x + (_size * 0.08), _y,
        false
    );
    draw_triangle(
        _x - (_size * 0.08), _y,
        _x + (_size * 0.33), _y - (_size * 0.04),
        _x - (_size * 0.08), _y + (_size * 0.5),
        false
    );
}
