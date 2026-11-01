function draw_trader_sell()
{
    // ==============================
    // BACKGROUND
    // ==============================

    draw_set_alpha(1);
    draw_set_color(global.hideout_panel_color);

    draw_rectangle(
        0,
        0,
        display_get_gui_width(),
        display_get_gui_height(),
        false
    );

    draw_set_color(global.ui_text_color);
    draw_set_font(fnt_terminal_small);


    var sellable_items =
        trader_get_sellable_items(
            current_trader_key
        );


    terminal_header(
        "TRADER // SELL"
    );


    // ==============================
    // TRADER INFO
    // ==============================

    draw_trader_info_panel(
        current_trader_key
    );


    // ==============================
    // PLAYER ITEMS
    // ==============================

    terminal_panel(
        600,
        180,
        1120,
        800,
        "SELL ITEMS"
    );


    var _sell_count =
        array_length(sellable_items);


    if (_sell_count == 0)
    {
        draw_text(
            620,
            270,
            "You have nothing this trader wants."
        );
    }
    else
    {
        var _visible_count = 10;
        var _scroll_offset = 0;


        // ==============================
        // SCROLL POSITION
        // ==============================

        if (trader_sell_index >= _visible_count)
        {
            _scroll_offset =
                trader_sell_index
                - _visible_count
                + 1;
        }


        var _max_scroll =
            max(
                0,
                _sell_count
                - _visible_count
            );


        _scroll_offset =
            clamp(
                _scroll_offset,
                0,
                _max_scroll
            );


        // ==============================
        // COLUMN POSITIONS
        // ==============================

        var _item_x = 620;
        var _qty_divider_x = 900;
        var _qty_x = 920;
        var _price_divider_x = 990;
        var _price_x = 1010;


        // ==============================
        // COLUMN HEADERS
        // ==============================

        draw_set_color(global.ui_text_color);
		draw_set_font(fnt_terminal_small);
        draw_text(
            _item_x,
            225,
            "Item"
        );

        draw_text(
            _qty_x,
            225,
            "Qty"
        );

        draw_text(
            _price_x,
            225,
            "Price"
        );


        // ==============================
        // COLUMN DIVIDERS
        // ==============================

        draw_line(
            _qty_divider_x,
            220,
            _qty_divider_x,
            780
        );

        draw_line(
            _price_divider_x,
            220,
            _price_divider_x,
            780
        );


        // ==============================
        // DRAW VISIBLE ITEMS
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


            if (i >= _sell_count)
                break;


            var item_key =
                sellable_items[i];


            var item =
                item_get(
                    item_key
                );


            var quantity =
                stash_get_quantity(
                    item_key
                );


            var sell_price =
                trader_get_sell_price(
                    item_key
                );


            var _y =
                270
                + (row * 50);


            // ==============================
            // ITEM NAME
            // ==============================

            terminal_menu_item(
                _item_x,
                _y,

                item.name,

                trader_sell_index == i
            );


            // ==============================
            // QUANTITY
            // ==============================

            draw_set_color(global.ui_text_color);

            draw_text(
                _qty_x,
                _y,
                string(quantity)
            );


            // ==============================
            // PRICE
            // ==============================

            draw_text(
                _price_x,
                _y,
                "$"
                + format_compact_number(sell_price)
            );
        }


        // ==============================
        // SCROLL INDICATORS
        // ==============================

        if (_scroll_offset > 0)
        {
            draw_text(
                1070,
                225,
                "^"
            );
        }


        if (
            _scroll_offset
            + _visible_count
            < _sell_count
        )
        {
            draw_text(
                1070,
                765,
                "v"
            );
        }
    }
	
	if (array_length(sellable_items) > 0)
	{
	    var _selected_item_key =
	        sellable_items[trader_sell_index];
	    var _selected_item = _selected_item_key;
	    var _stored_matches = stash_find_items(_selected_item_key);
	    if (array_length(_stored_matches) > 0) _selected_item = _stored_matches[0];

	    draw_item_info_popup(
	        _selected_item
	    );
	}
}
