function step_trader_buy()
{
    var _trader = trader_get(current_trader_key);
    if (is_undefined(_trader)) return;
    if (is_undefined(trader_stock_layout) || trader_stock_layout.width != 11)
        trader_stock_layout = trader_stock_grid_build(current_trader_key, 11);
    var _context_was_open = inventory_context_active || !is_undefined(inventory_inspect_item);
    if (inventory_context_menu_step()) return;
    if (_context_was_open) return;

    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var _stock_left = 35;
    var _stock_top = 260;
    var _stock_cell = 55;
    var _visible_rows = 14;
    var _stash_left = 1290;
    var _stash_top = 260;
    var _stash_cell = 55;
    var _max_scroll = max(0, trader_stock_layout.rows - _visible_rows);
    var _hovered = trader_stock_grid_find_entry(trader_stock_layout, _mouse_x, _mouse_y,
        _stock_left, _stock_top, _stock_cell, trader_stock_scroll_row, _visible_rows);
    trader_hovered_stock_index = is_undefined(_hovered) ? -1 : _hovered.stock_index;

    var _mouse_over_stock = _mouse_x >= _stock_left && _mouse_x < _stock_left + 11 * _stock_cell
        && _mouse_y >= _stock_top && _mouse_y < _stock_top + _visible_rows * _stock_cell;
    var _mouse_over_stash = _mouse_x >= _stash_left && _mouse_x < _stash_left + stash.grid_width * _stash_cell
        && _mouse_y >= _stash_top && _mouse_y < _stash_top + stash.grid_height * _stash_cell;

    if (!is_undefined(stash.held_item))
    {
        if (mouse_check_button_pressed(mb_right))
        {
            array_push(stash.items, stash.held_item);
            stash.held_item = undefined;
            stash.held_source = "";
            save_mark_dirty();
            return;
        }

        var _held_definition = item_get(stash.held_item.item_key);
        if (keyboard_check_pressed(ord("R")) && !is_undefined(_held_definition))
        {
            if (_held_definition.grid_width == _held_definition.grid_height)
                stash.held_item.rotation = 0;
            else
                stash.held_item.rotation = stash.held_item.rotation == 90 ? 0 : 90;
        }

        if (mouse_check_button_pressed(mb_left) && _mouse_over_stock)
        {
            var _sold_item = stash.held_item;
            array_push(stash.items, _sold_item);
            trader_sell_stored_item(current_trader_key, _sold_item, stash, _sold_item.quantity);
            stash.held_item = undefined;
            stash.held_source = "";
            return;
        }

        if (mouse_check_button_pressed(mb_left) && _mouse_over_stash)
        {
            var _stash_x = floor((_mouse_x - _stash_left) / _stash_cell);
            var _stash_y = floor((_mouse_y - _stash_top) / _stash_cell);
            if (inventory_can_place_item(stash.held_item, _stash_x, _stash_y, stash))
            {
                var _stack_target = inventory_find_item_at(stash, _stash_x, _stash_y);
                if (!is_undefined(_stack_target))
                {
                    inventory_merge_stacks(stash.held_item, _stack_target);
                    if (stash.held_item.quantity <= 0)
                    {
                        stash.held_item = undefined;
                        stash.held_source = "";
                    }
                }
                else
                {
                    stash.held_item.x = _stash_x;
                    stash.held_item.y = _stash_y;
                    array_push(stash.items, stash.held_item);
                    stash.held_item = undefined;
                    stash.held_source = "";
                }
                save_mark_dirty();
                return;
            }
        }

        if (keyboard_check_pressed(vk_escape))
        {
            array_push(stash.items, stash.held_item);
            stash.held_item = undefined;
            stash.held_source = "";
        }
        else return;
    }
    else if (mouse_check_button_pressed(mb_left) && _mouse_over_stash)
    {
        var _stash_x = floor((_mouse_x - _stash_left) / _stash_cell);
        var _stash_y = floor((_mouse_y - _stash_top) / _stash_cell);
        var _picked_item = inventory_find_item_at(stash, _stash_x, _stash_y);
        if (!is_undefined(_picked_item) && stash_remove_item(_picked_item, stash))
        {
            stash.held_item = _picked_item;
            stash.held_source = "stash";
            save_mark_dirty();
        }
        return;
    }

    if (_mouse_x >= _stock_left && _mouse_x < _stock_left + 605
    && _mouse_y >= _stock_top && _mouse_y < _stock_top + _visible_rows * _stock_cell)
    {
        if (mouse_wheel_up()) trader_stock_scroll_row = max(0, trader_stock_scroll_row - 1);
        if (mouse_wheel_down()) trader_stock_scroll_row = min(_max_scroll, trader_stock_scroll_row + 1);
    }

    var _selection_changed = false;
    if (mouse_check_button_pressed(mb_left) && !is_undefined(_hovered))
    {
        _selection_changed = trader_selected_stock_index != _hovered.stock_index;
        trader_selected_stock_index = _hovered.stock_index;
    }
    else if (array_length(_trader.stock) > 0)
    {
        var _direction = 0;
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_up)) _direction = -1;
        if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_down)) _direction = 1;
        if (_direction != 0)
        {
            var _old_selection = trader_selected_stock_index;
            trader_selected_stock_index = clamp(trader_selected_stock_index < 0 ? 0 : trader_selected_stock_index + _direction,
                0, array_length(_trader.stock) - 1);
            _selection_changed = _old_selection != trader_selected_stock_index;
        }
    }

    if (_selection_changed)
    {
        trader_purchase_quantity_text = "1";
        if (trader_quantity_focused) keyboard_string = trader_purchase_quantity_text;
    }

    var _selected_entry = trader_stock_grid_find_stock(trader_stock_layout, trader_selected_stock_index);
    if (!is_undefined(_selected_entry))
    {
        if (_selected_entry.y < trader_stock_scroll_row) trader_stock_scroll_row = _selected_entry.y;
        if (_selected_entry.y + _selected_entry.height > trader_stock_scroll_row + _visible_rows)
            trader_stock_scroll_row = _selected_entry.y + _selected_entry.height - _visible_rows;
        trader_stock_scroll_row = clamp(trader_stock_scroll_row, 0, _max_scroll);
    }

    var _details_offset = 0;
    if (!is_undefined(_selected_entry))
    {
        var _preview_cell = min(80, floor(280 / max(_selected_entry.width, _selected_entry.height)));
        var _preview_height = _selected_entry.height * _preview_cell;
        _details_offset = max(0, 349 + _preview_height + 20 - 570);
    }
    var _quantity_box = point_in_rectangle(_mouse_x, _mouse_y,
        871, 570 + _details_offset, 1016, 621 + _details_offset);
    if (mouse_check_button_pressed(mb_left))
    {
        if (_quantity_box && !is_undefined(_selected_entry) && is_undefined(_selected_entry.item_instance))
        {
            if (!trader_quantity_focused) trader_quantity_keyboard_restore = keyboard_string;
            trader_quantity_focused = true;
            keyboard_string = trader_purchase_quantity_text;
        }
        else if (trader_quantity_focused)
        {
            trader_purchase_quantity_text = trader_quantity_value(keyboard_string) > 0 ? keyboard_string : "";
            trader_quantity_focused = false;
            keyboard_string = trader_quantity_keyboard_restore;
        }
    }

    if (trader_quantity_focused)
    {
        var _filtered = "";
        for (var _i = 1; _i <= min(6, string_length(keyboard_string)); _i++)
        {
            var _character = string_char_at(keyboard_string, _i);
            if (string_pos(_character, "0123456789") > 0) _filtered += _character;
        }
        if (_filtered != keyboard_string) keyboard_string = _filtered;
        trader_purchase_quantity_text = _filtered;
    }

    var _deal_button = point_in_rectangle(_mouse_x, _mouse_y, 852, 114, 1002, 184);
    var _confirm = mouse_check_button_pressed(mb_left) && _deal_button;
    if (trader_quantity_focused && keyboard_check_pressed(vk_enter)) _confirm = true;
    if (_confirm && !is_undefined(_selected_entry))
    {
        var _quantity = !is_undefined(_selected_entry.item_instance) ? 1 : trader_quantity_value(trader_purchase_quantity_text);
        if (trader_buy_item(current_trader_key, trader_selected_stock_index, _quantity))
        {
            trader_purchase_quantity_text = "1";
            if (trader_quantity_focused) keyboard_string = "1";
        }
    }

    if (mouse_check_button_pressed(mb_right) && !is_undefined(_hovered))
    {
        var _context_stock_item = is_undefined(_hovered.item_instance) ? _hovered : _hovered.item_instance;
        if (inventory_context_menu_open(_context_stock_item, undefined, -1, false, false, false, current_trader_key)) return;
    }
    else if (mouse_check_button_pressed(mb_right)
    && point_in_rectangle(_mouse_x, _mouse_y, 1290, 260, 1840, 1030))
    {
        var _grid_x = floor((_mouse_x - 1290) / 55);
        var _grid_y = floor((_mouse_y - 260) / 55);
        var _context_item = inventory_find_item_at(stash, _grid_x, _grid_y);
        if (inventory_context_menu_open(_context_item, stash, -1, false, false, false, current_trader_key)) return;
    }

    if (keyboard_check_pressed(vk_escape))
    {
        if (!is_undefined(stash.held_item))
        {
            array_push(stash.items, stash.held_item);
            stash.held_item = undefined;
            stash.held_source = "";
        }
        if (trader_quantity_focused) keyboard_string = trader_quantity_keyboard_restore;
        trader_quantity_focused = false;
        inventory_context_menu_close();
        trader_mode = TraderMode.SELECT;
        menu_index = 0;
        trader_stock_layout = undefined;
        trader_stock_scroll_row = 0;
        trader_selected_stock_index = -1;
        trader_hovered_stock_index = -1;
        trader_purchase_quantity_text = "1";
        audio_play_sound(snd_interact, 0, false);
    }
}
