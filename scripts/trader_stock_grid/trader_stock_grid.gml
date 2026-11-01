function trader_stock_grid_build(_trader_key, _grid_width)
{
    var _trader = trader_get(_trader_key);
    var _entries = [];
    if (is_undefined(_trader) || _grid_width <= 0) return { entries: _entries, rows: 0, width: _grid_width };

    var _max_rows = 1;
    for (var _i = 0; _i < array_length(_trader.stock); _i++)
    {
        var _definition = item_get(_trader.stock[_i].item_key);
        if (!is_undefined(_definition)) _max_rows += max(_definition.grid_width, _definition.grid_height);
    }

    var _occupied = array_create(_grid_width * _max_rows, false);
    var _used_rows = 0;

    for (var _stock_index = 0; _stock_index < array_length(_trader.stock); _stock_index++)
    {
        var _stock_entry = _trader.stock[_stock_index];
        var _definition = item_get(_stock_entry.item_key);
        if (is_undefined(_definition)) continue;

        var _placed = false;
        for (var _grid_y = 0; _grid_y < _max_rows && !_placed; _grid_y++)
        {
            for (var _grid_x = 0; _grid_x < _grid_width && !_placed; _grid_x++)
            {
                for (var _turn = 0; _turn < 2 && !_placed; _turn++)
                {
                    var _rotation = _turn == 0 ? 0 : 90;
                    if (_turn == 1 && _definition.grid_width == _definition.grid_height) continue;
                    var _item_width = _rotation == 90 ? _definition.grid_height : _definition.grid_width;
                    var _item_height = _rotation == 90 ? _definition.grid_width : _definition.grid_height;
                    if (_grid_x + _item_width > _grid_width || _grid_y + _item_height > _max_rows) continue;

                    var _fits = true;
                    for (var _y = 0; _y < _item_height && _fits; _y++)
                    for (var _x = 0; _x < _item_width; _x++)
                    {
                        if (_occupied[(_grid_y + _y) * _grid_width + _grid_x + _x])
                        {
                            _fits = false;
                            break;
                        }
                    }
                    if (!_fits) continue;

                    for (var _y = 0; _y < _item_height; _y++)
                    for (var _x = 0; _x < _item_width; _x++)
                        _occupied[(_grid_y + _y) * _grid_width + _grid_x + _x] = true;

                    array_push(_entries, {
                        item_key: _stock_entry.item_key,
                        item_instance: variable_struct_exists(_stock_entry, "item_instance") ? _stock_entry.item_instance : undefined,
                        quantity: 1,
                        x: _grid_x,
                        y: _grid_y,
                        rotation: _rotation,
                        width: _item_width,
                        height: _item_height,
                        stock_index: _stock_index,
                        price: trader_get_buy_price(_stock_entry.price)
                    });
                    _used_rows = max(_used_rows, _grid_y + _item_height);
                    _placed = true;
                }
            }
        }
    }

    return { entries: _entries, rows: _used_rows, width: _grid_width };
}

function trader_stock_grid_find_entry(_grid, _mouse_x, _mouse_y, _left, _top, _cell_size, _scroll_row, _visible_rows)
{
    if (is_undefined(_grid)) return undefined;
    for (var _i = array_length(_grid.entries) - 1; _i >= 0; _i--)
    {
        var _entry = _grid.entries[_i];
        if (_entry.y < _scroll_row || _entry.y + _entry.height > _scroll_row + _visible_rows) continue;
        var _entry_left = _left + _entry.x * _cell_size;
        var _entry_top = _top + (_entry.y - _scroll_row) * _cell_size;
        if (point_in_rectangle(_mouse_x, _mouse_y, _entry_left, _entry_top,
            _entry_left + _entry.width * _cell_size, _entry_top + _entry.height * _cell_size)) return _entry;
    }
    return undefined;
}

function trader_stock_grid_find_stock(_grid, _stock_index)
{
    if (is_undefined(_grid)) return undefined;
    for (var _i = 0; _i < array_length(_grid.entries); _i++)
        if (_grid.entries[_i].stock_index == _stock_index) return _grid.entries[_i];
    return undefined;
}

function trader_quantity_value(_text)
{
    if (string_length(_text) <= 0 || string_length(_text) > 6) return -1;
    var _value = 0;
    for (var _i = 1; _i <= string_length(_text); _i++)
    {
        var _character = string_char_at(_text, _i);
        if (string_pos(_character, "0123456789") <= 0) return -1;
        _value = _value * 10 + real(_character);
    }
    return _value > 0 ? _value : -1;
}
