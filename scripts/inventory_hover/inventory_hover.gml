function inventory_hover_begin()
{
    inventory_hover_candidate = undefined;
    inventory_hover_candidate_left = 0;
    inventory_hover_candidate_top = 0;
    inventory_hover_candidate_right = 0;
    inventory_hover_candidate_bottom = 0;
}

function inventory_hover_consider(_item, _left, _top, _right, _bottom)
{
    if (is_undefined(_item) || !is_struct(_item) || !variable_struct_exists(_item, "item_key")) return;

    var gui_mouse_x = device_mouse_x_to_gui(0);
    var gui_mouse_y = device_mouse_y_to_gui(0);

    if (gui_mouse_x >= _left && gui_mouse_x < _right && gui_mouse_y >= _top && gui_mouse_y < _bottom)
    {
        inventory_hover_candidate = _item;
        inventory_hover_candidate_left = _left;
        inventory_hover_candidate_top = _top;
        inventory_hover_candidate_right = _right;
        inventory_hover_candidate_bottom = _bottom;
    }
}

function inventory_hover_consider_key(_item_key, _left, _top, _right, _bottom)
{
    if (_item_key == "") return;
    inventory_hover_consider({ item_key: _item_key }, _left, _top, _right, _bottom);
}

function inventory_hover_finish()
{
    var is_holding = !is_undefined(stash.held_item)
        || !is_undefined(raid.inventory_item);

    if (is_holding || is_undefined(inventory_hover_candidate))
    {
        inventory_hover_item = undefined;
        inventory_hover_time = 0;
        return;
    }

    var candidate_key = inventory_hover_candidate.item_key;
    var current_key = is_undefined(inventory_hover_item) ? "" : inventory_hover_item.item_key;
    var same_item = !is_undefined(inventory_hover_item)
        && current_key == candidate_key
        && inventory_hover_item_left == inventory_hover_candidate_left
        && inventory_hover_item_top == inventory_hover_candidate_top;

    if (!same_item)
    {
        inventory_hover_item = inventory_hover_candidate;
        inventory_hover_item_left = inventory_hover_candidate_left;
        inventory_hover_item_top = inventory_hover_candidate_top;
        inventory_hover_time = 0;
    }
    else
    {
        inventory_hover_time += delta_time / 1000000;
    }
}

function inventory_hover_draw()
{
    if (is_undefined(inventory_inspect_item))
    {
        if (inventory_context_active || is_undefined(inventory_hover_item)
        || !is_undefined(stash.held_item) || !is_undefined(raid.inventory_item)) return;

        var _definition = item_get(inventory_hover_item.item_key);
        if (is_undefined(_definition)) return;
        var _tooltip_alpha = clamp((inventory_hover_time - 0.2) / 0.15, 0, 1);
        if (_tooltip_alpha <= 0) return;
        draw_set_font(fnt_terminal_tiny);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        var _padding = 6;
        var _name_text = _definition.name;
        var _detail_text = "";
        if (_definition.category == ItemCategory.WEAPON)
        {
            weapon_instance_initialize(inventory_hover_item, false);
            _detail_text = "Tier " + string(_definition.tier) + " - "
                + weapon_rarity_get(inventory_hover_item.rarity).name;
        }
        var _line_height = string_height(_name_text);
        var _width = max(string_width(_name_text), string_width(_detail_text)) + _padding * 2;
        var _height = _line_height + _padding * 2;
        if (_detail_text != "") _height += _line_height;
        var _left = clamp(device_mouse_x_to_gui(0) + 14, 0, display_get_gui_width() - _width);
        var _top = clamp(device_mouse_y_to_gui(0) + 14, 0, display_get_gui_height() - _height);
        draw_set_alpha(0.92 * _tooltip_alpha);
        draw_set_color(c_black);
        draw_rectangle(_left, _top, _left + _width, _top + _height, false);
        draw_set_alpha(_tooltip_alpha);
        draw_set_color(c_green);
        draw_rectangle(_left, _top, _left + _width, _top + _height, true);
        draw_set_color(_definition.category == ItemCategory.WEAPON ? weapon_rarity_color(inventory_hover_item) : global.ui_text_color);
        draw_text(_left + _padding, _top + _padding, _name_text);
        if (_detail_text != "")
        {
            draw_text(_left + _padding, _top + _padding + _line_height, _detail_text);
        }
        draw_set_alpha(1);
        draw_set_font(fnt_terminal);
        return;
    }

    var popup_width = 520;
    var popup_height = 430;
    var _inspect_definition = item_get(inventory_inspect_item.item_key);
    if (!is_undefined(_inspect_definition) && _inspect_definition.category == ItemCategory.WEAPON)
    {
        weapon_instance_initialize(inventory_inspect_item, false);
        var _modifier_count = array_length(inventory_inspect_item.modifiers);
        var _pellet_height = variable_struct_exists(_inspect_definition, "pellet_count") ? 24 : 0;
        popup_height = _modifier_count == 0
            ? 389 + _pellet_height
            : 416 + _pellet_height + _modifier_count * 50;
    }
    var popup_gap = 10;
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var popup_left = inventory_inspect_x + 104 + popup_gap;
    var popup_top = inventory_inspect_y;

    if (popup_left + popup_width > gui_width)
        popup_left = inventory_inspect_x - popup_gap - popup_width;

    if (popup_top + popup_height > gui_height)
        popup_top = gui_height - popup_height;

    popup_left = clamp(popup_left, 0, max(0, gui_width - popup_width));
    popup_top = clamp(popup_top, 0, max(0, gui_height - popup_height));

    var gui_surface_width = ceil(gui_width);
    var gui_surface_height = ceil(gui_height);
    if (inventory_hover_surface == -1 || !surface_exists(inventory_hover_surface)
    || surface_get_width(inventory_hover_surface) != gui_surface_width
    || surface_get_height(inventory_hover_surface) != gui_surface_height)
    {
        if (inventory_hover_surface != -1 && surface_exists(inventory_hover_surface))
            surface_free(inventory_hover_surface);
        inventory_hover_surface = surface_create(gui_surface_width, gui_surface_height);
    }

    surface_set_target(inventory_hover_surface);
    draw_clear_alpha(c_black, 0);
    draw_item_info_popup(
        inventory_inspect_item,
        popup_left,
        popup_top,
        popup_width,
        popup_height
    );
    surface_reset_target();

    draw_surface_ext(inventory_hover_surface, 0, 0, 1, 1, 0, c_white, 0.95);
}
