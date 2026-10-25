function draw_trader_buy()
{
    var _trader = trader_get(current_trader_key);
    if (is_undefined(_trader)) return;
    if (is_undefined(trader_stock_layout) || trader_stock_layout.width != 11)
        trader_stock_layout = trader_stock_grid_build(current_trader_key, 11);

    var _stock_left = 35;
    var _stock_top = 260;
    var _stock_cell = 55;
    var _stock_visible_rows = 14;
    var _deal_left = 684;
    var _deal_width = 531;
    var _stash_left = 1290;
    var _stash_top = 260;
    var _stash_cell = 55;
    var _selected_entry = trader_stock_grid_find_stock(trader_stock_layout, trader_selected_stock_index);
    var _quantity = trader_quantity_value(trader_purchase_quantity_text);
    var _valid = !is_undefined(_selected_entry)
        && trader_can_buy_item(current_trader_key, trader_selected_stock_index, _quantity);

    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

    // Trader profile
    draw_set_color(c_lime);
    terminal_box(15, 37, 658, 195);
    var _portrait_left = 20;
    var _portrait_top = 42;
    var _portrait_height = 185;
    var _portrait_width = 135;
    if (_trader.portrait != -1)
    {
        _portrait_width = round(_portrait_height * sprite_get_width(_trader.portrait) / sprite_get_height(_trader.portrait));
        draw_sprite_stretched_ext(_trader.portrait, 0, _portrait_left, _portrait_top, _portrait_width, _portrait_height, c_green, 1);
    }
    draw_set_color(c_lime);
    terminal_box(_portrait_left, _portrait_top, _portrait_width, _portrait_height);
    var _trader_text_left = _portrait_left + _portrait_width + 26;
    draw_set_font(fnt_terminal_small);
    draw_set_color(c_lime);
    draw_text(_trader_text_left, 76, string_upper(_trader.name));
    draw_text(_trader_text_left, 116, string_upper(_trader.title));
    draw_set_color(c_green);
    draw_text(_trader_text_left, 157, "REPUTATION");
    draw_set_color(c_lime);
    draw_text(_trader_text_left + 207, 157, "0");

    // Player profile
    terminal_box(1228, 37, 672, 166);
    draw_set_font(fnt_terminal_small);
    draw_set_color(c_lime);
    draw_text(1258, 71, string_upper(crew[0].name));
    draw_set_font(fnt_terminal);
    draw_set_halign(fa_right);
    draw_text(1800, 148, "$" + string(get_cash()));
    draw_set_halign(fa_left);
    draw_set_font(fnt_terminal_tiny);
    draw_set_color(c_green);
    draw_text(1275, 119, "CURRENT TRADER LEVEL");
    draw_text(1273, 162, "NEXT TRADER LEVEL");
    draw_set_color(c_lime);
    draw_text(1532, 119, "0");
    draw_text(1532, 162, "0");

    // Deal button
    draw_set_color(_valid ? c_lime : c_dkgray);
    draw_rectangle(852, 114, 1002, 184, false);
    draw_set_color(c_lime);
    draw_rectangle(852, 114, 1002, 184, true);
    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_valid ? c_black : c_lime);
    draw_text(927, 149, "[[DEAL]]");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // Trader stock
    inventory_hover_begin();
    for (var _grid_y = 0; _grid_y < _stock_visible_rows; _grid_y++)
    for (var _grid_x = 0; _grid_x < 11; _grid_x++)
    {
        var _cell_left = _stock_left + _grid_x * _stock_cell;
        var _cell_top = _stock_top + _grid_y * _stock_cell;
        draw_set_color(c_dkgray);
        draw_rectangle(_cell_left, _cell_top, _cell_left + _stock_cell, _cell_top + _stock_cell, false);
        draw_set_color(c_green);
        draw_rectangle(_cell_left, _cell_top, _cell_left + _stock_cell, _cell_top + _stock_cell, true);
    }

    for (var _i = 0; _i < array_length(trader_stock_layout.entries); _i++)
    {
        var _entry = trader_stock_layout.entries[_i];
        if (_entry.y < trader_stock_scroll_row || _entry.y + _entry.height > trader_stock_scroll_row + _stock_visible_rows) continue;
        var _left = _stock_left + _entry.x * _stock_cell;
        var _top = _stock_top + (_entry.y - trader_stock_scroll_row) * _stock_cell;
        var _selected = _entry.stock_index == trader_selected_stock_index;
        var _hovered = _entry.stock_index == trader_hovered_stock_index;
        var _definition = item_get(_entry.item_key);
        draw_inventory_grid_item(_entry, _definition, _left, _top, _entry.width, _entry.height, _stock_cell, _selected);
        inventory_hover_consider(_entry, _left, _top, _left + _entry.width * _stock_cell, _top + _entry.height * _stock_cell);
        if (_hovered && !_selected)
        {
            draw_set_color(c_white);
            draw_rectangle(_left + 2, _top + 2, _left + _entry.width * _stock_cell - 2, _top + _entry.height * _stock_cell - 2, true);
        }
        draw_set_font(fnt_terminal_tiny);
        draw_set_halign(fa_left);
        draw_set_valign(fa_bottom);
        draw_set_color(c_black);
        draw_text(_left + 8, _top + _entry.height * _stock_cell - 7, "$" + string(_entry.price));
    }
    draw_set_color(c_lime);
    terminal_box(18, 244, 652, 806);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_terminal_small);
    draw_set_color(c_lime);
    if (trader_stock_scroll_row > 0) draw_text(640, 252, "^");
    if (trader_stock_scroll_row + _stock_visible_rows < trader_stock_layout.rows) draw_text(640, 1020, "v");

    // Deal details
    terminal_box(_deal_left, 244, _deal_width, 806);
    if (!is_undefined(_selected_entry))
    {
        var _definition = item_get(_selected_entry.item_key);
        var _preview_cell = min(80, floor(280 / max(_selected_entry.width, _selected_entry.height)));
        var _preview_width = _selected_entry.width * _preview_cell;
        var _preview_height = _selected_entry.height * _preview_cell;
        var _preview_left = _deal_left + (_deal_width - _preview_width) * 0.5;
        var _details_offset = max(0, 349 + _preview_height + 20 - 570);
        draw_inventory_grid_item(_selected_entry, _definition, _preview_left, 349, _selected_entry.width, _selected_entry.height, _preview_cell, true);

        draw_set_font(fnt_terminal_small);
        draw_set_color(c_lime);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_text(_deal_left + _deal_width * 0.5, 300, string_upper(_definition.name));
        draw_set_halign(fa_left);

        draw_set_font(fnt_terminal_small);
        draw_set_color(c_green);
        draw_text(718, 572 + _details_offset, "QUANTITY");
        draw_set_color(trader_quantity_focused ? c_lime : c_green);
        draw_rectangle(871, 570 + _details_offset, 1016, 621 + _details_offset, true);
        draw_set_color(c_lime);
        draw_text(889, 583 + _details_offset, trader_purchase_quantity_text);
        draw_text(1025, 583 + _details_offset, "X");

        var _total = _quantity > 0 && _quantity <= floor(2147483647 / _selected_entry.price)
            ? _selected_entry.price * _quantity : 0;
        draw_set_color(c_green);
        draw_text(722, 695 + _details_offset, "TOTAL");
        draw_set_color(c_lime);
        draw_text(881, 695 + _details_offset, _total > 0 ? "$" + string(_total) : "--");
    }

    // Main stash
    for (var _grid_y = 0; _grid_y < stash.grid_height; _grid_y++)
    for (var _grid_x = 0; _grid_x < stash.grid_width; _grid_x++)
    {
        var _cell_left = _stash_left + _grid_x * _stash_cell;
        var _cell_top = _stash_top + _grid_y * _stash_cell;
        draw_set_color(c_dkgray);
        draw_rectangle(_cell_left, _cell_top, _cell_left + _stash_cell, _cell_top + _stash_cell, false);
        draw_set_color(c_green);
        draw_rectangle(_cell_left, _cell_top, _cell_left + _stash_cell, _cell_top + _stash_cell, true);
    }

    for (var _i = 0; _i < array_length(stash.items); _i++)
    {
        var _stored_item = stash.items[_i];
        var _definition = item_get(_stored_item.item_key);
        var _width = _stored_item.rotation == 90 ? _definition.grid_height : _definition.grid_width;
        var _height = _stored_item.rotation == 90 ? _definition.grid_width : _definition.grid_height;
        var _left = _stash_left + _stored_item.x * _stash_cell;
        var _top = _stash_top + _stored_item.y * _stash_cell;
        var _can_sell = trader_will_buy_item(current_trader_key, _stored_item.item_key);
        draw_inventory_grid_item(_stored_item, _definition, _left, _top, _width, _height, _stash_cell, false, c_black, false, true);
        if (!_can_sell)
        {
            draw_set_alpha(0.7);
            draw_set_color(c_dkgray);
            draw_rectangle(_left + 4, _top + 4, _left + _width * _stash_cell - 4, _top + _height * _stash_cell - 4, false);
            draw_set_alpha(1);
        }
        else
        {
            draw_set_font(fnt_terminal_tiny);
            draw_set_halign(fa_left);
            draw_set_valign(fa_bottom);
            draw_set_color(c_black);
            draw_text(_left + 8, _top + _height * _stash_cell - 7, "$" + string(trader_get_sell_price(_stored_item.item_key)));
        }
        inventory_hover_consider(_stored_item, _left, _top, _left + _width * _stash_cell, _top + _height * _stash_cell);
    }

    if (!is_undefined(stash.held_item))
    {
        var _held_definition = item_get(stash.held_item.item_key);
        var _held_width = stash.held_item.rotation == 90 ? _held_definition.grid_height : _held_definition.grid_width;
        var _held_height = stash.held_item.rotation == 90 ? _held_definition.grid_width : _held_definition.grid_height;
        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);

        if (_mouse_x >= _stash_left && _mouse_x < _stash_left + stash.grid_width * _stash_cell
        && _mouse_y >= _stash_top && _mouse_y < _stash_top + stash.grid_height * _stash_cell)
        {
            var _preview_x = floor((_mouse_x - _stash_left) / _stash_cell);
            var _preview_y = floor((_mouse_y - _stash_top) / _stash_cell);
            var _preview_valid = inventory_can_place_item(stash.held_item, _preview_x, _preview_y, stash);
            draw_set_alpha(0.45);
            draw_set_color(_preview_valid ? c_lime : c_red);
            draw_rectangle(_stash_left + _preview_x * _stash_cell + 4, _stash_top + _preview_y * _stash_cell + 4,
                _stash_left + (_preview_x + _held_width) * _stash_cell - 4,
                _stash_top + (_preview_y + _held_height) * _stash_cell - 4, false);
            draw_set_alpha(1);
        }

        draw_set_alpha(0.5);
        draw_inventory_grid_item(stash.held_item, _held_definition, _mouse_x, _mouse_y,
            _held_width, _held_height, _stash_cell, false, c_black, false, true);
        draw_set_alpha(1);
    }
    draw_set_color(c_lime);
    terminal_box(1228, 244, 672, 806);
    inventory_hover_finish();
    inventory_hover_draw();
    inventory_context_menu_draw();

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_terminal);
}
