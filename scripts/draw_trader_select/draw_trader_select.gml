function draw_trader_select()
{
    var trader_keys = trader_get_unlocked_keys();
    menu_index = clamp(menu_index, 0, array_length(trader_keys) - 1);

    // RIGHT SIDE AREA: X 320 -> 1920
    // CONTENT AREA: Y 80 -> 1080

    // ==============================
    // TRADER LIST
    // ==============================

    terminal_panel(320, 80, 700, 1000, "AVAILABLE TRADERS");

    for (var i = 0; i < array_length(trader_keys); i++)
    {
        var trader = trader_get(trader_keys[i]);

        terminal_menu_item(
            370,
            170 + (i * 70),
            trader.name + " // " + trader.title,
            menu_index == i
        );
    }

    // ==============================
    // SELECTED TRADER
    // ==============================

    var selected_key = trader_keys[menu_index];
    var selected_trader = trader_get(selected_key);

    // ==============================
    // INFO PANEL
    // ==============================

    draw_set_font(fnt_terminal_small);
    terminal_panel(1020, 80, 900, 1000, "TRADER INFO");

    // ==============================
    // PORTRAIT
    // ==============================

    var portrait_left = 1070;
    var portrait_top = 180;
    var portrait_width = 280;
    var portrait_height = 330;

    terminal_box(portrait_left, portrait_top, portrait_width, portrait_height);

    if (selected_trader.portrait != -1)
    {
        draw_sprite_stretched_ext(selected_trader.portrait, 0, portrait_left + 3, portrait_top + 3, portrait_width - 6, portrait_height - 6, c_green, 1);
    }
    else
    {
        draw_set_halign(fa_center);
        draw_text(portrait_left + (portrait_width / 2), portrait_top + 150, "[ NO IMAGE ]");
        draw_set_halign(fa_left);
    }

    // ==============================
    // TRADER DETAILS
    // ==============================

    var info_left = 1400;

    terminal_value(info_left, 200, "NAME", selected_trader.name, 180);
    terminal_value(info_left, 260, "ROLE", selected_trader.title, 180);

    // ==============================
    // DESCRIPTION
    // ==============================

    terminal_panel(1400, 350, 470, 350, "DESCRIPTION");

    draw_text_ext(1440, 410, selected_trader.description, 28, 390);

    draw_set_font(fnt_terminal);
}
