function draw_raid_result()
{
    var _gui_width = display_get_gui_width();
    var _gui_height = display_get_gui_height();
    var _layout = raid_result_get_layout();
    var _quote = raid_result_get_treatment_quote();
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);

    draw_set_alpha(0.96);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_width, _gui_height, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_font(fnt_terminal);
    draw_set_color(c_lime);
    draw_text(_gui_width * 0.5, 35, "RAID ENDED");
    draw_set_font(fnt_terminal_tiny);
    draw_set_color(c_green);
    draw_text(_gui_width * 0.5, 75, raid.result_title);

    draw_set_halign(fa_left);
    draw_set_font(fnt_terminal_small);
    draw_set_color(c_lime);
    draw_text(_layout.content_left, 125, "CURRENT HEALTH CONDITION");

    if (equipment_silhouette_sprite != -1 && sprite_exists(equipment_silhouette_sprite))
    {
        var _silhouette_width = sprite_get_width(equipment_silhouette_sprite);
        var _silhouette_height = sprite_get_height(equipment_silhouette_sprite);
        var _silhouette_scale = min(430 / _silhouette_width, 760 / _silhouette_height);
        var _silhouette_left = _layout.content_left + 225 - ((_silhouette_width * _silhouette_scale) * 0.5);

        draw_set_alpha(0.55);
        draw_sprite_part_ext(
            equipment_silhouette_sprite,
            0,
            0,
            0,
            _silhouette_width,
            _silhouette_height,
            _silhouette_left,
            _layout.health_top + 15,
            _silhouette_scale,
            _silhouette_scale,
            c_gray,
            1
        );
        draw_set_alpha(1);
    }

    draw_inventory_health_interface(_layout.content_left, _layout.health_top);
    draw_player_status_panel(_layout.content_left + 45, _layout.health_top + 615, 360, true);

    var _panel_left = _layout.panel_left;
    var _panel_right = _layout.panel_right;
    var _panel_top = 125;
    var _panel_bottom = _layout.button_top - 35;
    draw_set_color(make_color_rgb(4, 22, 9));
    draw_rectangle(_panel_left, _panel_top, _panel_right, _panel_bottom, false);
    draw_set_color(c_green);
    draw_rectangle(_panel_left, _panel_top, _panel_right, _panel_bottom, true);

    draw_set_font(fnt_terminal);
    draw_set_color(c_lime);
    draw_text(_panel_left + 28, _panel_top + 25, "SAWBONES MEDICAL TREATMENT");
    draw_set_font(fnt_terminal_tiny);
    draw_set_color(c_green);
    draw_text(_panel_left + 28, _panel_top + 69, "POST-RAID INJURY ASSESSMENT AND TREATMENT QUOTE");

    var _rows = [];
    if (_quote.missing_health > 0)
        array_push(_rows, { name: "HEALTH RESTORATION", detail: string(round(_quote.missing_health)) + " HP", cost: _quote.health_cost });
    if (_quote.heavy_bleeds > 0)
        array_push(_rows, { name: "HEAVY BLEEDS", detail: string(_quote.heavy_bleeds) + " TO TREAT", cost: _quote.heavy_cost });
    if (_quote.light_bleeds > 0)
        array_push(_rows, { name: "LIGHT BLEEDS", detail: string(_quote.light_bleeds) + " TO TREAT", cost: _quote.light_cost });
    if (_quote.fractures > 0)
        array_push(_rows, { name: "FRACTURES", detail: string(_quote.fractures) + " TO TREAT", cost: _quote.fracture_cost });
    if (_quote.blacked_limbs > 0)
        array_push(_rows, { name: "BLACKED-OUT LIMBS", detail: string(_quote.blacked_limbs) + " TO TREAT", cost: _quote.blacked_cost });
    var _row_top = _panel_top + 115;
    var _row_height = 72;

    for (var i = 0; i < array_length(_rows); i++)
    {
        var _row = _rows[i];
        var _top = _row_top + (i * _row_height);
        draw_set_color(i mod 2 == 0 ? make_color_rgb(8, 32, 14) : make_color_rgb(5, 25, 10));
        draw_rectangle(_panel_left + 18, _top, _panel_right - 18, _top + _row_height - 8, false);
        draw_set_color(_row.cost > 0 ? c_lime : c_green);
        draw_set_font(fnt_terminal_small);
        draw_text(_panel_left + 35, _top + 10, _row.name);
        draw_set_font(fnt_terminal_tiny);
        draw_set_color(c_green);
        draw_text(_panel_left + 35, _top + 37, _row.detail);
        draw_set_halign(fa_right);
        draw_set_font(fnt_terminal_small);
        draw_set_color(_row.cost > 0 ? c_lime : c_green);
        draw_text(_panel_right - 35, _top + 20, "$" + string(_row.cost));
        draw_set_halign(fa_left);
    }

    if (array_length(_rows) == 0)
    {
        draw_set_font(fnt_terminal_small);
        draw_set_color(c_green);
        draw_text(_panel_left + 35, _row_top + 20, "NO TREATMENT REQUIRED");
    }

    draw_set_font(fnt_terminal_small);
    draw_set_color(c_green);
    draw_text(_panel_left + 28, _panel_bottom - 62, "CASH IN STASH: $" + string(get_cash()));
    draw_set_halign(fa_right);
    draw_set_color(c_lime);
    draw_text(_panel_right - 28, _panel_bottom - 62, "TOTAL: $" + string(_quote.total));
    draw_set_halign(fa_left);

    var _can_heal = _quote.total > 0 && get_cash() >= _quote.total;
    draw_raid_result_button(
        _layout.heal_left,
        _layout.button_top,
        _layout.heal_right,
        _layout.button_bottom,
        "HEAL ALL  $" + string(_quote.total),
        _can_heal,
        point_in_rectangle(_mouse_x, _mouse_y, _layout.heal_left, _layout.button_top, _layout.heal_right, _layout.button_bottom)
    );
    draw_raid_result_button(
        _layout.continue_left,
        _layout.button_top,
        _layout.continue_right,
        _layout.button_bottom,
        "CONTINUE",
        true,
        point_in_rectangle(_mouse_x, _mouse_y, _layout.continue_left, _layout.button_top, _layout.continue_right, _layout.button_bottom)
    );

    if (_quote.total > get_cash())
    {
        draw_set_halign(fa_right);
        draw_set_font(fnt_terminal_tiny);
        draw_set_color(c_red);
        draw_text(_layout.heal_right, _layout.button_top - 25, "INSUFFICIENT FUNDS");
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_terminal);
    draw_set_color(c_lime);
}

function draw_raid_result_button(_left, _top, _right, _bottom, _label, _enabled, _hovered)
{
    draw_set_color(_hovered && _enabled ? make_color_rgb(8, 45, 18) : c_black);
    draw_rectangle(_left, _top, _right, _bottom, false);
    draw_set_color(!_enabled ? make_color_rgb(35, 60, 40) : (_hovered ? c_lime : c_green));
    draw_rectangle(_left, _top, _right, _bottom, true);
    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text((_left + _right) * 0.5, (_top + _bottom) * 0.5, _label);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
