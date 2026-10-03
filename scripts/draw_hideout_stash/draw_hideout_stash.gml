function draw_hideout_stash()
{
    // ==========================================
    // MAIN LAYOUT
    // ==========================================

    var panel_left = 320;
    var panel_top = 80;
    var panel_width = 1600;
    var panel_height = 1000;
    var padding = 40;

    // ==========================================
    // ITEM LIST
    // ==========================================

    var list_left = panel_left + padding;
    var list_width = 960;
    var name_x = list_left + 36;
    var quantity_x = list_left + 610;
    var weight_x = list_left + 720;
    var value_x = list_left + 840;
    var quantity_divider_x = list_left + 590;
    var weight_divider_x = list_left + 700;
    var value_divider_x = list_left + 820;
    var header_y = panel_top + 70;
    var item_start_y = panel_top + 110;
    var item_spacing = 34;
    var visible_rows = inventory_visible_rows;
    var divider_top = header_y - 10;
    var divider_bottom = item_start_y + (visible_rows * item_spacing) - 10;

    // ==========================================
    // ITEM INFO
    // ==========================================

    var info_left = list_left + list_width;
    var info_top = panel_top + 70;
    var info_width = 560;
    var info_height = 720;

    // ==========================================
    // BACKGROUND
    // ==========================================

    draw_set_color(c_black);
    draw_rectangle(panel_left, panel_top, panel_left + panel_width, panel_top + panel_height, false);

    draw_set_color(c_lime);
    draw_set_font(fnt_terminal_small);

    // ==========================================
    // MAIN PANEL
    // ==========================================

    terminal_panel(panel_left, panel_top, panel_width, panel_height, "INVENTORY");

    // ==========================================
    // GET INVENTORY
    // ==========================================

    var owned_items = inventory_get_visible_items();
    var item_count = array_length(owned_items);

    draw_text(name_x, header_y, "NAME");
    draw_text(quantity_x, header_y, "QTY");
    draw_text(weight_x, header_y, "WEIGHT");
    draw_text(value_x, header_y, "VALUE");

    draw_line(quantity_divider_x, divider_top, quantity_divider_x, divider_bottom);
    draw_line(weight_divider_x, divider_top, weight_divider_x, divider_bottom);
    draw_line(value_divider_x, divider_top, value_divider_x, divider_bottom);

    // ==========================================
    // DRAW ITEMS
    // ==========================================

    if (item_count == 0)
    {
        draw_text(name_x, item_start_y, "Inventory is empty.");
    }
    else
    {
        var last_visible_item = min(inventory_scroll + visible_rows, item_count);

        for (var i = inventory_scroll; i < last_visible_item; i++)
        {
            var item_key = owned_items[i];
            var item = item_get(item_key);
            var quantity = inventory_get_quantity(item_key);
            var row = i - inventory_scroll;
            var row_y = item_start_y + (row * item_spacing);
            var item_weight = "-";
            var item_value = "-";

            if (variable_struct_exists(item, "weight"))
                item_weight = string_format(item.weight, 1, 2);

            if (variable_struct_exists(item, "base_value"))
                item_value = "$" + string(item.base_value * quantity);

            terminal_menu_item(list_left, row_y, "", inventory_index == i);
            draw_text(name_x, row_y, item.name);
            draw_text(quantity_x, row_y, string(quantity));
            draw_text(weight_x, row_y, item_weight);
            draw_text(value_x, row_y, item_value);
        }
    }

    // ==========================================
    // SELECTED ITEM INFO
    // ==========================================

    if (item_count > 0)
    {
        var selected_key = inventory_get_selected_item();

        draw_item_info_popup(
            selected_key,
            info_left,
            info_top,
            info_width,
            info_height
        );
    }

    // ==========================================
    // SCROLL INDICATORS
    // ==========================================

    if (inventory_scroll > 0) draw_text(list_left + list_width - 20, item_start_y, "^");

    if (inventory_scroll + visible_rows < item_count)
        draw_text(list_left + list_width - 20, item_start_y + (visible_rows * item_spacing), "v");

    // ==========================================
    // ITEM POSITION
    // ==========================================

    if (item_count > 0)
        draw_text(list_left, panel_top + 850, "ITEM " + string(inventory_index + 1) + " / " + string(item_count));

    // ==========================================
    // CONTROLS
    // ==========================================

    draw_text(list_left, panel_top + 920, "W/S: SELECT");
    draw_text(list_left, panel_top + 960, "I / ESC: CLOSE");

    draw_set_font(fnt_terminal);
}
