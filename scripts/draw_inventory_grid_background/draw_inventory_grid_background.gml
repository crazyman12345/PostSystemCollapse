function draw_inventory_grid_background(_left, _top, _columns, _rows, _cell_size, _cell_stride = -1)
{
    if (_cell_stride <= 0) _cell_stride = _cell_size;

    for (var grid_y = 0; grid_y < _rows; grid_y++)
    {
        for (var grid_x = 0; grid_x < _columns; grid_x++)
        {
            draw_sprite_stretched(
                spr_inventory_grid_cell,
                0,
                _left + (grid_x * _cell_stride),
                _top + (grid_y * _cell_stride),
                _cell_size,
                _cell_size
            );
        }
    }

    draw_set_color(make_color_rgb(45, 47, 44));

    if (_cell_stride == _cell_size)
    {
        var grid_right = _left + (_columns * _cell_size);
        var grid_bottom = _top + (_rows * _cell_size);

        for (var line_x = 0; line_x <= _columns; line_x++)
            draw_line(_left + (line_x * _cell_size), _top, _left + (line_x * _cell_size), grid_bottom);

        for (var line_y = 0; line_y <= _rows; line_y++)
            draw_line(_left, _top + (line_y * _cell_size), grid_right, _top + (line_y * _cell_size));
    }
    else
    {
        for (var grid_y = 0; grid_y < _rows; grid_y++)
        {
            for (var grid_x = 0; grid_x < _columns; grid_x++)
            {
                var cell_left = _left + (grid_x * _cell_stride);
                var cell_top = _top + (grid_y * _cell_stride);
                draw_rectangle(cell_left, cell_top, cell_left + _cell_size, cell_top + _cell_size, true);
            }
        }
    }
}
