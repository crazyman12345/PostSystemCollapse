function draw_workshop_upgrades(_bench, _key, _x1, _top, _x2, _bottom)
{
    var previous_font = draw_get_font();
    var card_top = _top + 70;
    var card_gap = 16;
    var preview_left = _x1 + 20;
    var materials_right = _x2 - 20;
    var materials_left = materials_right - 462;
    var preview_right = materials_left - card_gap;

    draw_set_color(global.hideout_border_color);
    terminal_box(preview_left, card_top, preview_right - preview_left, _bottom - card_top);
    terminal_box(materials_left, card_top, materials_right - materials_left, _bottom - card_top);

    draw_set_font(fnt_terminal_tiny);
    draw_workshop_bench_preview(_bench, _key, preview_left, card_top, preview_right, _bottom);
    draw_workshop_materials_card(_bench, _key, materials_left, card_top, materials_right);
    draw_set_font(previous_font);
}

function draw_workshop_bench_preview(_bench, _key, _left, _top, _right, _bottom)
{
    var level = variable_struct_get(workshop_progress, _key);
    var padding = 14;

    var portrait_top = _top + 14;
    var portrait_height = clamp((_bottom - _top) * 0.4, 200, 290);
    var portrait_bottom = portrait_top + portrait_height;
    var portrait_left = _left + padding;
    var portrait_right = _right - padding;
    var sprite_scale = 1;
    var has_sprite = _bench.sprite != -1 && sprite_exists(_bench.sprite);
    var visible_left = 0;
    var visible_top = 0;
    var visible_width = 0;
    var visible_height = 0;

    if (has_sprite)
    {
        visible_left = sprite_get_bbox_left(_bench.sprite);
        visible_top = sprite_get_bbox_top(_bench.sprite);
        visible_width = sprite_get_bbox_right(_bench.sprite) - visible_left + 1;
        visible_height = sprite_get_bbox_bottom(_bench.sprite) - visible_top + 1;
        var available_width = _right - _left - padding * 4;
        var available_height = portrait_height - padding;
        sprite_scale = min(available_width / visible_width, available_height / visible_height);
        var portrait_width = min(_right - _left - padding * 2, visible_width * sprite_scale + padding * 2);
        portrait_left = (_left + _right - portrait_width) * 0.5;
        portrait_right = portrait_left + portrait_width;
    }

    draw_set_color(global.hideout_border_color);
    terminal_box(portrait_left, portrait_top, portrait_right - portrait_left, portrait_height);

    if (has_sprite)
    {
        var sprite_x = (_left + _right) * 0.5;
        var sprite_y = (portrait_top + portrait_bottom) * 0.5;
        var sprite_offset_x = (visible_left + visible_width * 0.5 - sprite_get_xoffset(_bench.sprite)) * sprite_scale;
        var sprite_offset_y = (visible_top + visible_height * 0.5 - sprite_get_yoffset(_bench.sprite)) * sprite_scale;

        draw_sprite_ext(_bench.sprite, icon_spin_frame(_bench.sprite), sprite_x - sprite_offset_x, sprite_y - sprite_offset_y, sprite_scale, sprite_scale, 0, c_white, 1);
    }

    var upgrades_y = portrait_bottom + 22;
    draw_set_color(global.ui_interactive_color);
    draw_line(_left + padding, upgrades_y - 8, _right - padding, upgrades_y - 8);
    draw_text(_left + padding, upgrades_y, "UPGRADES");

    var rows_top = upgrades_y + 35;
    var row_gap = 7;
    var row_height = min(54, (_bottom - padding - rows_top - row_gap * (_bench.max_level - 1)) / _bench.max_level);
    var next_level = min(level + 1, _bench.max_level);

    for (var i = 0; i < _bench.max_level; i++)
    {
        var displayed_level = i + 1;
        var row_top = rows_top + i * (row_height + row_gap);
        var completed = displayed_level <= level;
        var selected = displayed_level == next_level;
        var row_color = completed ? global.ui_interactive_color : (selected ? global.ui_text_color : c_gray);

        draw_set_color(row_color);
        terminal_box(_left + padding, row_top, _right - _left - padding * 2, row_height);
        draw_set_valign(fa_middle);
        draw_text(_left + padding + 12, row_top + row_height * 0.5, "LV. " + string(displayed_level));
        draw_set_valign(fa_top);
        draw_text_ext(_left + padding + 78, row_top + 8, _bench.level_unlocks[i], 16, _right - _left - padding * 2 - 88);
    }
}

function draw_workshop_materials_card(_bench, _key, _left, _top, _right)
{
    var level = variable_struct_get(workshop_progress, _key);
    var maxed = level >= _bench.max_level;
    var padding = 14;
    var title = maxed ? "MAX LEVEL" : "BUILD LEVEL " + string(level + 1);

    draw_set_color(global.ui_interactive_color);
    draw_text(_left + padding, _top + 12, title);
    draw_line(_left + padding, _top + 42, _right - padding, _top + 42);

    draw_set_color(global.ui_text_color);
    draw_text(_left + padding, _top + 58, maxed ? "ALL UPGRADES COMPLETE" : "REQUIRED MATERIALS");

    if (maxed)
    {
        workshop_upgrade_button(_key, _left, _top - 70, _right, true, true);
        return;
    }

    var reqs = _bench.upgrade_requirements[level];
    var row_top = _top + 100;
    var row_height = 64;
    var row_gap = 8;

    for (var i = 0; i < array_length(reqs); i++)
    {
        var req = reqs[i];
        var item = item_get(req.item_key);
        var owned = stash_get_quantity(req.item_key);
        var has_enough = owned >= req.quantity;
        var box_left = _left + padding;
        var box_right = _right - padding;

        draw_set_color(has_enough ? global.ui_text_color : c_gray);
        terminal_box(box_left, row_top, box_right - box_left, row_height);

        var icon = variable_struct_exists(item, "icon_sprite") ? item.icon_sprite : -1;
        if (icon != -1 && sprite_exists(icon))
        {
            var visible_left = sprite_get_bbox_left(icon);
            var visible_top = sprite_get_bbox_top(icon);
            var visible_width = sprite_get_bbox_right(icon) - visible_left + 1;
            var visible_height = sprite_get_bbox_bottom(icon) - visible_top + 1;
            var icon_scale = min(44 / visible_width, 44 / visible_height);
            var icon_x = box_left + 31;
            var icon_y = row_top + row_height * 0.5;
            var icon_offset_x = (visible_left + visible_width * 0.5 - sprite_get_xoffset(icon)) * icon_scale;
            var icon_offset_y = (visible_top + visible_height * 0.5 - sprite_get_yoffset(icon)) * icon_scale;

            draw_sprite_ext(icon, icon_spin_frame(icon), icon_x - icon_offset_x, icon_y - icon_offset_y, icon_scale, icon_scale, 0, c_white, 1);
        }

        draw_set_color(has_enough ? global.ui_interactive_color : global.ui_text_color);
        draw_text(box_left + 62, row_top + 10, item.name);
        draw_set_color(has_enough ? global.ui_interactive_color : c_red);
        draw_set_halign(fa_right);
        draw_text(box_right - 38, row_top + 36, string(owned) + " / " + string(req.quantity));
        draw_set_halign(fa_left);
        draw_workshop_requirement_status(box_right - 18, row_top + 42, has_enough);

        row_top += row_height + row_gap;
    }

    workshop_upgrade_button(_key, _left, _top - 70, _right, true, true);
}

function draw_workshop_requirement_status(_x, _y, _has_enough)
{
    draw_set_color(_has_enough ? global.ui_interactive_color : c_red);
    draw_rectangle(_x - 7, _y - 7, _x + 7, _y + 7, true);

    if (_has_enough)
    {
        draw_line(_x - 4, _y, _x - 1, _y + 4);
        draw_line(_x - 1, _y + 4, _x + 5, _y - 4);
    }
    else
    {
        draw_line(_x - 4, _y - 4, _x + 4, _y + 4);
        draw_line(_x + 4, _y - 4, _x - 4, _y + 4);
    }
}
