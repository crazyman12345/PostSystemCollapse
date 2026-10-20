function draw_trader_buy()
{
    // ==============================
    // BACKGROUND
    // ==============================

    draw_set_alpha(1);
    draw_set_color(c_black);
	draw_set_font(fnt_terminal_small);
    draw_rectangle(
        0,
        0,
        display_get_gui_width(),
        display_get_gui_height(),
        false
    );

    draw_set_color(c_lime);


    var trader =
        trader_get(current_trader_key);

    terminal_header(
        "TRADER // BUY"
    );


    // ==============================
    // TRADER INFO
    // ==============================

    draw_trader_info_panel(
        current_trader_key
    );

// ==============================
// STOCK
// ==============================

terminal_panel(
    600,
    180,
    1120,
    800,
    "FOR SALE"
);

var _stock_count =
    array_length(trader.stock);

if (_stock_count == 0)
{
    draw_text(
        620,
        270,
        "No items currently available."
    );
}
else
{
    var _visible_count = 10;
    var _scroll_offset = 0;

    if (trader_menu_index >= _visible_count)
    {
        _scroll_offset =
            trader_menu_index
            - _visible_count
            + 1;
    }

    var _max_scroll =
        max(
            0,
            _stock_count
            - _visible_count
        );

    _scroll_offset =
        clamp(
            _scroll_offset,
            0,
            _max_scroll
        );


    // ==============================
    // COLUMN DIVIDER
    // ==============================

    draw_set_color(c_lime);

    draw_line(
        980,
        220,
        980,
        780
    );

    // ==============================
    // DRAW VISIBLE STOCK
    // ==============================
	draw_set_font(fnt_terminal_small);
    for (
        var row = 0;
        row < _visible_count;
        row++
    )
    {
        var i =
            row + _scroll_offset;

        if (i >= _stock_count)
            break;

        var stock_entry =
            trader.stock[i];

        var item =
            item_get(
                stock_entry.item_key
            );

        var _y =
            270 + (row * 50);


        // ITEM NAME
        terminal_menu_item(
            620,
            _y,

            item.name,

            trader_menu_index == i
        );


        // PRICE COLUMN
        draw_set_color(c_lime);

        draw_text(
            995,
            _y,
            "$" + string(trader_get_buy_price(stock_entry.price))
        );
    }


    // ==============================
    // SCROLL INDICATORS
    // ==============================

    if (_scroll_offset > 0)
    {
        draw_text(
            1050,
            230,
            "^"
        );
    }

    if (
        _scroll_offset
        + _visible_count
        < _stock_count
    )
    {
        draw_text(
            1050,
            765,
            "v"
        );
    }
}

if (array_length(trader.stock) > 0)
{
    var _selected_stock =
        trader.stock[trader_menu_index];

    draw_item_info_popup(
        _selected_stock.item_key
    );
}
}
