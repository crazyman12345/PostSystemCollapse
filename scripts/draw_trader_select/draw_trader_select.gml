function draw_trader_select()
{
    var trader_keys = trader_get_unlocked_keys();
    menu_index = clamp(menu_index, 0, array_length(trader_keys) - 1);
    draw_set_font(fnt_terminal_small);
    draw_set_color(global.ui_text_color);

    // RIGHT SIDE AREA: X 320 -> 1920
    // CONTENT AREA: Y 80 -> 1080

    // ==============================
    // TRADER LIST
    // ==============================

    terminal_panel(360, 130, 640, 900, "AVAILABLE TRADERS");

    for (var i = 0; i < array_length(trader_keys); i++)
    {
        var trader = trader_get(trader_keys[i]);
        var button_top = 170 + (i * 70);
        terminal_button(
            370,
            button_top,
            990,
            button_top + 58,
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

    terminal_panel(1040, 130, 840, 900, "TRADER INFO");

    // ==============================
    // PORTRAIT
    // ==============================

    var portrait_left = 1090;
    var portrait_top = 230;
    var portrait_width = 280;
    var portrait_height = 330;

    if (selected_trader.portrait != -1)
    {
        draw_chamfered_sprite(selected_trader.portrait, 0, portrait_left + 3, portrait_top + 3, portrait_width - 6, portrait_height - 6, 9, merge_color(c_white, global.hideout_secondary_color, 0.5), 1);
    }
    else
    {
        draw_set_halign(fa_center);
        draw_text(portrait_left + (portrait_width / 2), portrait_top + 150, "[ NO IMAGE ]");
        draw_set_halign(fa_left);
    }
    draw_set_color(global.ui_text_color);
    terminal_box(portrait_left, portrait_top, portrait_width, portrait_height);

    // ==============================
    // TRADER DETAILS
    // ==============================

    var info_left = 1420;

    terminal_value(info_left, 250, "NAME", selected_trader.name, 180);
    terminal_value(info_left, 310, "ROLE", selected_trader.title, 180);

    // ==============================
    // DESCRIPTION
    // ==============================

    terminal_panel(1420, 400, 440, 350, "DESCRIPTION");

    draw_text_ext(1460, 460, selected_trader.description, 28, 360);
    draw_set_font(fnt_terminal);
}
