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

    var item_x = panel_left + padding;
    var item_start_y = panel_top + 80;
    var item_spacing = 34;
    var visible_rows = inventory_visible_rows;

    // ==========================================
    // ITEM INFO
    // ==========================================

    var info_top = panel_top + 600;

    var image_left = panel_left + padding;
    var image_top = info_top;
    var image_width = 220;
    var image_height = 220;

    var description_left = image_left + image_width + 30;
    var description_top = info_top;
    var description_width = panel_width - padding - image_width - 30 - padding;
    var description_height = 220;

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

    // ==========================================
    // DRAW ITEMS
    // ==========================================

    if (item_count == 0)
    {
        draw_text(item_x, item_start_y, "Inventory is empty.");
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
            var display_text = item.name + "    x" + string(quantity);

            terminal_menu_item(item_x, item_start_y + (row * item_spacing), display_text, inventory_index == i);
        }
    }

    // ==========================================
    // SELECTED ITEM INFO
    // ==========================================

    if (item_count > 0)
    {
        var selected_key = inventory_get_selected_item();
        var selected_item = item_get(selected_key);

        terminal_panel(image_left, image_top, image_width, image_height, "ITEM");
        terminal_panel(description_left, description_top, description_width, description_height, "DESCRIPTION");

        draw_text(description_left + 25, description_top + 45, selected_item.name);

        draw_text_ext(
            description_left + 25,
            description_top + 85,
            selected_item.description,
            24,
            description_width - 50
        );

        draw_text(description_left + 25, description_top + 170, "VALUE: $" + string(selected_item.base_value));
        draw_text(description_left + 300, description_top + 170, "TYPE: " + item_category_get_name(selected_item.category));
    }

    // ==========================================
    // SCROLL INDICATORS
    // ==========================================

    if (inventory_scroll > 0) draw_text(panel_left + panel_width - 60, item_start_y, "^");

    if (inventory_scroll + visible_rows < item_count)
        draw_text(panel_left + panel_width - 60, info_top - 40, "v");

    // ==========================================
    // ITEM POSITION
    // ==========================================

    if (item_count > 0)
        draw_text(panel_left + padding, panel_top + 850, "ITEM " + string(inventory_index + 1) + " / " + string(item_count));

    // ==========================================
    // CONTROLS
    // ==========================================

    draw_text(panel_left + padding, panel_top + 920, "W/S: SELECT");
    draw_text(panel_left + padding, panel_top + 960, "I / ESC: CLOSE");

    draw_set_font(fnt_terminal);
}