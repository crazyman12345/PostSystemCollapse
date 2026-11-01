function draw_item_info_popup(
    _item_source,
    _left = 1305,
    _top = 210,
    _width = 600,
    _height = 600
)
{
    var _item_key = is_string(_item_source) ? _item_source : _item_source.item_key;
    var _stored_item = is_string(_item_source) ? undefined : _item_source;
    var item = item_get(_item_key);

    if (!is_struct(item)) return;
    if (item.category == ItemCategory.WEAPON)
        item = weapon_get_effective_stats(is_undefined(_stored_item) ? _item_key : _stored_item);

    static _last_item_key = "";
    static _fade_alpha = 1;

    if (_last_item_key != _item_key)
    {
        _last_item_key = _item_key;
        _fade_alpha = 0.75;
    }

    _fade_alpha = min(1, _fade_alpha + 0.02 * frame_scale);

    var _x1 = _left;
    var _y1 = _top;
    var _x2 = _x1 + _width;
    var _y2 = _y1 + _height;
    var _title_h = 34;
    var _content_left = _x1 + 22;
    var _content_right = _x2 - 22;
    var _footer_top = _y2 - 72;
    var _corner = 14;

    draw_set_alpha(_fade_alpha);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // Window and terminal-style frame.
    draw_set_color(c_dkgray);
    draw_item_info_chamfer_fill(_x1 + 6, _y1 + 6, _x2 + 6, _y2 + 6, _corner);
    draw_set_color(c_black);
    draw_item_info_chamfer_fill(_x1, _y1, _x2, _y2, _corner);
    draw_set_color(global.ui_text_color);
    draw_border_frame2_path(_x1, _y1, _x2, _y2, _corner);
    draw_border_frame2_path(_x1 + 4, _y1 + 4, _x2 - 4, _y2 - 4, _corner - 4);

    var _title_left = _x1 + 5;
    var _title_top = _y1 + 5;
    var _title_right = _x2 - 5;
    var _title_bottom = _y1 + _title_h;
    var _title_corner = _corner - 5;
    draw_rectangle(_title_left + _title_corner, _title_top, _title_right - _title_corner, _title_bottom, false);
    draw_rectangle(_title_left, _title_top + _title_corner, _title_right, _title_bottom, false);
    draw_triangle(_title_left + _title_corner, _title_top, _title_left, _title_top + _title_corner,
        _title_left + _title_corner, _title_top + _title_corner, false);
    draw_triangle(_title_right - _title_corner, _title_top, _title_right, _title_top + _title_corner,
        _title_right - _title_corner, _title_top + _title_corner, false);

    draw_set_color(c_black);
    draw_rectangle(_x2 - 75, _y1 + 11, _x2 - 63, _y1 + 23, true);
    draw_rectangle(_x2 - 52, _y1 + 11, _x2 - 40, _y1 + 23, true);
    draw_rectangle(_x2 - 29, _y1 + 11, _x2 - 17, _y1 + 23, true);

    // Item name and identity stay at the top left.
    var _rarity_color = item.category == ItemCategory.WEAPON
        ? weapon_rarity_color(item)
        : global.ui_text_color;

    draw_set_color(_rarity_color);
    draw_set_font(fnt_terminal_medium);
    draw_text(_content_left, _y1 + 52, string_upper(item.name));

    if (item.category == ItemCategory.WEAPON)
    {
        draw_set_font(fnt_terminal_medium);
        draw_set_color(global.ui_text_color);
        draw_text(_content_left, _y1 + 84, "TIER " + string(item.tier) + "  //  ");
        var _tier_width = string_width("TIER " + string(item.tier) + "  //  ");
        draw_set_color(_rarity_color);
        draw_text(_content_left + _tier_width, _y1 + 84, string_upper(weapon_rarity_get(item.rarity).name));
        draw_set_color(global.ui_text_color);
        draw_text(_content_left, _y1 + 108,
            "COMBAT RATING  " + string(weapon_calculate_gear_score(item)));
    }

    // Item icon in the top-right corner.
    var _sprite = -1;
    if (variable_struct_exists(item, "icon_sprite") && item.icon_sprite != -1)
        _sprite = item.icon_sprite;
    else if (variable_struct_exists(item, "weapon_sprite") && item.weapon_sprite != -1)
        _sprite = item.weapon_sprite;
    else if (variable_struct_exists(item, "sprite_idle") && item.sprite_idle != -1)
        _sprite = item.sprite_idle;

    if (_sprite != -1)
    {
        var _bbox_left = sprite_get_bbox_left(_sprite);
        var _bbox_top = sprite_get_bbox_top(_sprite);
        var _bbox_w = sprite_get_bbox_right(_sprite) - _bbox_left + 1;
        var _bbox_h = sprite_get_bbox_bottom(_sprite) - _bbox_top + 1;
        var _scale = min(140 / _bbox_w, 110 / _bbox_h);
        var _image_center_x = _x2 - 96;
        var _image_center_y = _y1 + 103;

        draw_sprite_part_ext(
            _sprite, icon_spin_frame(_sprite),
            _bbox_left, _bbox_top, _bbox_w, _bbox_h,
            _image_center_x - _bbox_w * _scale * 0.5,
            _image_center_y - _bbox_h * _scale * 0.5,
            _scale, _scale, c_white, 1
        );
    }

    if (item.category == ItemCategory.WEAPON)
    {
        var _pellet_count = variable_struct_exists(item, "pellet_count") ? item.pellet_count : 1;
        var _average_hit_damage = (item.damage_min + item.damage_max) * 0.5 * _pellet_count;
        var _shot_interval_frames = max(1, round(60 / item.fire_rate));
        var _attacks_per_second = 60 / _shot_interval_frames;
        var _shot_interval_seconds = _shot_interval_frames / 60;
        var _reload_seconds = item.reload_time / 60;
        var _magazine_cycle_seconds = (item.mag_size - 1) * _shot_interval_seconds
            + max(_reload_seconds, _shot_interval_seconds);
        var _dps = _average_hit_damage * item.mag_size / _magazine_cycle_seconds;
        var _damage_label = _pellet_count > 1 ? " DAMAGE PER PELLET" : " DAMAGE PER HIT";

        // DPS and its calculation breakdown.
        draw_set_color(global.ui_text_color);
        draw_set_font(fnt_terminal_medium);
        draw_line(_content_left, _y1 + 160, _content_right, _y1 + 160);
        draw_text(_content_left, _y1 + 178, string_format(_dps, 0, 1) + " DAMAGE PER SECOND");

        draw_set_font(fnt_terminal_medium);
        draw_text(_content_left + 12, _y1 + 206,
            string(item.damage_min) + " - " + string(item.damage_max) + _damage_label);
        if (_pellet_count > 1)
            draw_text(_content_left + 12, _y1 + 230, string(_pellet_count) + " PELLETS PER ATTACK");
        draw_text(_content_left + 12, _y1 + (_pellet_count > 1 ? 254 : 230),
            string_format(_attacks_per_second, 0, 2) + " ATTACKS PER SECOND");
        draw_text(_content_left + 12, _y1 + (_pellet_count > 1 ? 278 : 254),
            "MAGAZINE SIZE  " + string(item.mag_size));
        draw_text(_content_left + 12, _y1 + (_pellet_count > 1 ? 302 : 278),
            "RELOAD TIME  " + string_format(_reload_seconds, 0, 2) + " SECONDS");

        if (array_length(item.modifiers) > 0)
        {
            var _modifier_top = _y1 + (_pellet_count > 1 ? 340 : 316);
            draw_set_color(global.ui_text_color);
            draw_line(_content_left, _modifier_top - 10, _content_right, _modifier_top - 10);
            draw_text(_content_left, _modifier_top, "// BONUS MODIFIERS");

            var _modifier_y = _modifier_top + 30;
            for (var i = 0; i < array_length(item.modifiers); i++)
            {
                var _modifier = variable_struct_get(global.weapon_modifier_registry, item.modifiers[i]);
                draw_set_color(_rarity_color);
                draw_text(_content_left + 12, _modifier_y, "> " + string_upper(_modifier.name));
                draw_set_color(global.ui_text_color);
                draw_text(_content_left + 32, _modifier_y + 18, _modifier.description);
                _modifier_y += 50;
            }
        }
    }
    else
    {
        draw_set_color(global.ui_text_color);
        draw_set_font(fnt_terminal_medium);
        if (variable_struct_exists(item, "description"))
            draw_text_ext(_content_left, _y1 + 110, item.description, 24, _width - 210);
        draw_line(_content_left, _y1 + 196, _content_right, _y1 + 196);
        draw_text(_content_left, _y1 + 210, "// SPECIFICATIONS");
        draw_item_stats(item, _content_left + 12, _y1 + 242, _footer_top - 10);
    }

    // Sell value and weight always form the final row.
    draw_set_color(global.ui_text_color);
    draw_line(_content_left, _footer_top, _content_right, _footer_top);
    draw_set_font(fnt_terminal_medium);
    draw_set_halign(fa_left);
    draw_text(_content_left, _footer_top + 18, "SELL VALUE  $" + string(trader_get_sell_price(_item_key)));
    draw_set_halign(fa_right);
    draw_text(_content_right, _footer_top + 18,
        "WEIGHT  " + string_format(item.weight, 0, 2) + " KG");
    draw_set_halign(fa_left);

    // Subtle scanlines over the body of the panel.
    draw_set_alpha(_fade_alpha * 0.08);
    draw_set_color(global.ui_text_color);
    for (var _scan_y = _y1 + _title_h + 5; _scan_y < _y2 - 5; _scan_y += 6)
        draw_line(_x1 + 6, _scan_y, _x2 - 6, _scan_y);

    draw_set_alpha(1);
    draw_set_color(global.ui_text_color);
}

function draw_item_info_chamfer_fill(_left, _top, _right, _bottom, _corner)
{
    var _cut = min(_corner, min(_right - _left, _bottom - _top) * 0.5);
    draw_rectangle(_left + _cut, _top, _right - _cut, _bottom, false);
    draw_rectangle(_left, _top + _cut, _right, _bottom - _cut, false);
    draw_triangle(_left + _cut, _top, _left, _top + _cut, _left + _cut, _top + _cut, false);
    draw_triangle(_right - _cut, _top, _right, _top + _cut, _right - _cut, _top + _cut, false);
    draw_triangle(_right, _bottom - _cut, _right - _cut, _bottom, _right - _cut, _bottom - _cut, false);
    draw_triangle(_left, _bottom - _cut, _left + _cut, _bottom, _left + _cut, _bottom - _cut, false);
}
