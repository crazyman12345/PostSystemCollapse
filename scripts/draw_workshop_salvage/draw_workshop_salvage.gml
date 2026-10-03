function draw_workshop_salvage(_x1, _top, _x2, _bottom)
{
    var _y = _top + 140;
    var items = workshop_get_salvageable_items();
	draw_set_color(c_lime);
    draw_text(_x1 + 30, _y, "SALVAGE");
    _y += 50;

    if (array_length(items) <= 0)
    {
        draw_text(_x1 + 30, _y, "NO SALVAGEABLE ITEMS");
        return;
    }

    workshop_content_index = clamp(workshop_content_index, 0, array_length(items) - 1);

    for (var i = 0; i < array_length(items); i++)
    {
        var key = items[i];
        var item = item_get(key);
        var owned = inventory_get_quantity(key);

        var cursor = "  ";
        if (i == workshop_content_index) cursor = "> ";

        draw_text(_x1 + 30, _y, cursor + item.name + " x" + string(owned));
        _y += 35;
    }

    // SELECTED ITEM BREAKDOWN
    _y += 30;

    var selected_key = items[workshop_content_index];
    var selected_item = item_get(selected_key);

    draw_text(_x1 + 30, _y, "RESULT:");
    _y += 40;

    for (var j = 0; j < array_length(selected_item.salvage); j++)
    {
        var result = selected_item.salvage[j];
        var result_item = item_get(result.item_key);

        draw_text(_x1 + 50, _y, result_item.name + " x" + string(result.quantity));
        _y += 30;
    }

    _y += 25;
    draw_text(_x1 + 30, _y, "[ENTER] SALVAGE");
}