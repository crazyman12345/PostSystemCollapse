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
    if (inventory_hover_time < 0.3 || is_undefined(inventory_hover_item)) return;
    if (!is_undefined(stash.held_item) || !is_undefined(raid.inventory_item)) return;

    var popup_width = 600;
    var popup_height = 600;
    var popup_gap = 10;
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var popup_left = inventory_hover_candidate_right + popup_gap;
    var popup_top = inventory_hover_candidate_top;

    if (popup_left + popup_width > gui_width)
        popup_left = inventory_hover_candidate_left - popup_gap - popup_width;

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
        inventory_hover_item.item_key,
        popup_left,
        popup_top,
        popup_width,
        popup_height
    );
    surface_reset_target();

    draw_surface_ext(inventory_hover_surface, 0, 0, 1, 1, 0, c_white, 0.95);
}
