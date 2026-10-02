function workshop_salvage_interact()
{
    var items = workshop_get_salvageable_items();
    if (array_length(items) <= 0) return;

    workshop_content_index = clamp(workshop_content_index, 0, array_length(items) - 1);

    var key = items[workshop_content_index];
    var item = item_get(key);

    if (inventory_get_quantity(key) <= 0) return;
    if (!item_can_salvage(key)) return;

    inventory_remove(key, 1);

    for (var i = 0; i < array_length(item.salvage); i++)
    {
        var result = item.salvage[i];
        inventory_add(result.item_key, result.quantity);
    }

    log_add("Salvaged " + item.name + ".");

    // Fix cursor if the last copy of the item disappeared
    var new_items = workshop_get_salvageable_items();
    if (array_length(new_items) <= 0) workshop_content_index = 0;
    else workshop_content_index = clamp(workshop_content_index, 0, array_length(new_items) - 1);
}