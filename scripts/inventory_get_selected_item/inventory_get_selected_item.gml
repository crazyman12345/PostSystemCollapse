function inventory_get_selected_item()
{
    var owned_items = inventory_get_visible_items();

    if (array_length(owned_items) == 0)
    {
        return "";
    }

    if (
        inventory_index < 0 ||
        inventory_index >= array_length(owned_items)
    )
    {
        return "";
    }

    return owned_items[inventory_index];
}