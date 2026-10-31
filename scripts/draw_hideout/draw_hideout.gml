function draw_hideout()
{
    var _old_ui_text_color = global.ui_text_color;
    var _old_ui_interactive_color = global.ui_interactive_color;
    global.ui_text_color = global.hideout_text_color;
    global.ui_interactive_color = global.hideout_interactive_color;

    if (onboarding_draw_hideout())
    {
        global.ui_text_color = _old_ui_text_color;
        global.ui_interactive_color = _old_ui_interactive_color;
        return;
    }
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var sidebar_w = 320;
    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(global.ui_text_color);

    // SIDEBAR
    draw_set_color(global.hideout_background_color);
    draw_set_alpha(0.88);
    draw_rectangle(1, 1, sidebar_w, gui_h, false);
    draw_set_alpha(1);
    draw_set_color(global.ui_text_color);
    draw_hideout_sidebar_frame(sidebar_w, gui_h);

    for (var i = 0; i < array_length(hideout_menu_items); i++)
    {
        var entry = hideout_menu_items[i];
        var entry_unlocked = hideout_entry_is_unlocked(entry);
        var entry_value = "";
        if (entry_unlocked && entry.key == "messages" && dialogue_has_ready_quest()) entry_value = "?";
        if (entry_unlocked && entry.skill_key != "")
            entry_value = string(skill_get_level(entry.skill_key)) + "/100";
        draw_hideout_sidebar_item(entry, hideout_sidebar_item_top(i), i == hideout_menu_index, entry_unlocked, entry_value);
    }

    // CONTENT AREA
	var content_x1 = sidebar_w;
	var content_y1 = 1;
	var content_x2 = gui_w;
	var content_y2 = gui_h;

    draw_set_color(global.hideout_panel_color);
    draw_set_alpha(0.78);
    draw_rectangle(content_x1, content_y1, content_x2, content_y2, false);
    draw_set_alpha(1);

    var selected = hideout_menu_items[hideout_menu_index];

    // RIGHT SIDE CONTENT
    if (!hideout_entry_is_unlocked(selected))
    {
        draw_text(content_x1 + 25, content_y1 + 75, "[LOCKED]");
        if (selected.bench_key != "")
        {
            var bench = variable_struct_get(workshop_db, selected.bench_key);
            draw_text(content_x1 + 25, content_y1 + 125, "BUILD THE " + bench.name + " IN THE WORKSHOP TO UNLOCK.");
        }
    }
    else switch (selected.key)
    {
        case "traders":
            draw_hideout_traders();
        break;

        case "messages":
            draw_hideout_traders();
        break;

        case "stash":
            draw_hideout_stash();
        break;

        case "skills":
            draw_hideout_skills();
        break;
		
		case "workshop":
            draw_workshop();
        break;
		
		case "salvaging":
			draw_hideout_salvage();
		break;
		
        case "gunmaking":
        case "armorcrafting":
        case "drugmaking":
        case "medical_crafting":
            draw_hideout_crafting(selected.key, content_x1, content_y1, content_x2, content_y2);
        break;

        case "raids":
            draw_hideout_raid_select();
        break;

     
    }

    var _trader_subscreen_open = (hideout_page == HideoutPage.TRADERS || hideout_page == HideoutPage.MESSAGES)
        && trader_mode != TraderMode.SELECT;
    if (!_trader_subscreen_open)
        heading_box(content_x1, content_y1, content_x2 - content_x1, content_y2 - content_y1, selected.name, 60);

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    global.ui_text_color = _old_ui_text_color;
    global.ui_interactive_color = _old_ui_interactive_color;
}

function draw_hideout_page_frame(_left, _top, _width, _height)
{
    var _old_alpha = draw_get_alpha();
    var _old_color = draw_get_color();
    draw_set_alpha(1);
    draw_set_color(global.hideout_border_color);
    draw_border_frame2(_left, _top, _width, _height);
    draw_set_alpha(_old_alpha);
    draw_set_color(_old_color);
}

function draw_hideout_sidebar_frame(_sidebar_width, _gui_height)
{
    draw_set_color(global.hideout_border_color);
    draw_border_frame2(10, 10, _sidebar_width - 20, _gui_height - 20, true);
    draw_set_font(fnt_terminal_small);
    draw_text(30, 30, "HIDEOUT");
    draw_set_alpha(0.35);
    draw_line(18, 72, _sidebar_width - 18, 72);
    draw_set_alpha(1);
    draw_set_font(fnt_terminal_tiny);
}

function hideout_sidebar_item_top(_index)
{
    var _y = 86;
    for (var _i = 0; _i <= _index; _i++)
    {
        var _entry = hideout_menu_items[_i];
        if (_entry.header != "") _y += 38;
        if (_i == _index) return _y;
        _y += 47;
        if (_entry.key == "drugmaking" || _entry.key == "workshop") _y += 18;
    }
    return _y;
}

function draw_hideout_sidebar_item(_entry, _top, _selected, _unlocked, _value = "")
{
    var _left = 18;
    var _right = 302;
    var _bottom = _top + 42;
    var _middle_y = (_top + _bottom) * 0.5;
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var _hovered = _unlocked && _mouse_x >= _left && _mouse_x <= _right && _mouse_y >= _top && _mouse_y <= _bottom;
    var _active = _selected || _hovered;
    var _color = !_unlocked ? global.hideout_muted_color
        : (_active ? global.ui_interactive_color : global.hideout_secondary_color);

    if (_entry.header != "")
    {
        draw_set_color(global.ui_text_color);
        draw_set_alpha(0.6);
        draw_text_transformed(_left + 12, _top - 27, _entry.header, 0.7, 0.7, 0);
        draw_line(_left + 105, _top - 22, _right - 8, _top - 22);
        draw_set_alpha(1);
    }

    draw_set_color(_active ? global.hideout_raised_color : global.hideout_panel_color);
    draw_set_alpha(_active ? 0.9 : 0.6);
    draw_roundrect_ext(_left, _top, _right, _bottom, 4, 4, false);
    draw_set_alpha(1);
    draw_set_color(_active ? global.ui_interactive_color
        : (_unlocked ? global.hideout_border_subtle_color : global.hideout_muted_color));
    draw_roundrect_ext(_left, _top, _right, _bottom, 4, 4, true);

    if (_selected)
    {
        draw_set_color(global.ui_interactive_color);
        draw_set_valign(fa_middle);
        draw_text(_left + 8, _middle_y, ">");
        draw_set_valign(fa_top);
    }

    draw_hideout_sidebar_icon(_entry.key, _left + 40, _middle_y, _color, _unlocked);
    draw_set_color(_color);
    draw_set_valign(fa_middle);
    var _label = _unlocked ? _entry.name : "???";
    if (_value == "")
        draw_text(_left + 64, _middle_y, _label);
    else
        draw_text_transformed(_left + 64, _middle_y - 6, _label, 0.8, 0.8, 0);

    if (_value != "")
    {
        draw_set_halign(fa_right);
        draw_set_color(_value == "?" ? c_red : _color);
        draw_text(_right - 10, _middle_y, _value);
        draw_set_halign(fa_left);
    }
    draw_set_valign(fa_top);
}

function draw_hideout_sidebar_icon(_key, _x, _y, _color, _unlocked)
{
    draw_set_color(_color);
    if (!_unlocked)
    {
        draw_circle(_x, _y - 5, 6, true);
        draw_rectangle(_x - 8, _y - 4, _x + 8, _y + 9, false);
        draw_circle(_x, _y + 2, 2, false);
        return;
    }

    var _sprite = -1;
    switch (_key)
    {
        case "gunmaking": _sprite = icon_gunmaking; break;
        case "armorcrafting": _sprite = icon_armorcrafting; break;
        case "medical_crafting": _sprite = icon_medical_crafting; break;
        case "drugmaking": _sprite = icon_drugmaking; break;
    }
    if (_sprite != -1)
    {
        var _scale = 24 / max(sprite_get_width(_sprite), sprite_get_height(_sprite));
        draw_sprite_ext(_sprite, 0, _x, _y, _scale, _scale, 0, _color, 1);
        return;
    }

    switch (_key)
    {
        case "traders":
            draw_circle(_x - 5, _y - 5, 5, false);
            draw_circle(_x + 6, _y - 4, 4, false);
            draw_rectangle(_x - 11, _y + 2, _x + 1, _y + 9, false);
            draw_rectangle(_x + 2, _y + 2, _x + 11, _y + 9, false);
        break;

        case "messages":
            draw_roundrect_ext(_x - 11, _y - 8, _x + 11, _y + 7, 3, 3, true);
            draw_line(_x - 6, _y + 7, _x - 9, _y + 11);
            draw_circle(_x - 5, _y, 1, false);
            draw_circle(_x, _y, 1, false);
            draw_circle(_x + 5, _y, 1, false);
        break;

        case "stash":
            draw_rectangle(_x - 10, _y - 6, _x + 10, _y + 9, true);
            draw_line(_x - 12, _y - 7, _x + 12, _y - 7);
            draw_line(_x - 8, _y - 11, _x + 8, _y - 11);
            draw_line(_x, _y - 5, _x, _y + 2);
        break;

        case "skills":
            draw_rectangle(_x - 10, _y + 2, _x - 6, _y + 9, false);
            draw_rectangle(_x - 2, _y - 4, _x + 2, _y + 9, false);
            draw_rectangle(_x + 6, _y - 10, _x + 10, _y + 9, false);
        break;

        case "salvaging":
            draw_circle(_x, _y, 8, true);
            draw_circle(_x, _y, 3, true);
            for (var _i = 0; _i < 8; _i++)
            {
                var _direction = _i * 45;
                draw_line(_x + lengthdir_x(8, _direction), _y + lengthdir_y(8, _direction),
                    _x + lengthdir_x(11, _direction), _y + lengthdir_y(11, _direction));
            }
        break;

        case "workshop":
            draw_circle(_x - 8, _y + 8, 3, true);
            draw_line(_x - 6, _y + 6, _x + 3, _y - 3);
            draw_line(_x - 5, _y + 8, _x + 5, _y - 2);
            draw_primitive_begin(pr_linestrip);
            draw_vertex(_x + 3, _y - 3);
            draw_vertex(_x + 2, _y - 9);
            draw_vertex(_x + 5, _y - 12);
            draw_vertex(_x + 7, _y - 8);
            draw_vertex(_x + 11, _y - 10);
            draw_vertex(_x + 12, _y - 7);
            draw_vertex(_x + 8, _y - 2);
            draw_vertex(_x + 5, _y - 2);
            draw_primitive_end();
        break;

        case "raids":
            draw_circle(_x, _y - 2, 10, true);
            draw_rectangle(_x - 7, _y + 3, _x + 7, _y + 9, false);
            draw_circle(_x - 4, _y - 3, 2, false);
            draw_circle(_x + 4, _y - 3, 2, false);
            draw_line(_x, _y + 1, _x - 2, _y + 4);
            draw_line(_x, _y + 1, _x + 2, _y + 4);
        break;
    }
}
