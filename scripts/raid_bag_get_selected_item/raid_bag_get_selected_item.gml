function raid_bag_get_selected_item()
{
    var visible_items =
        raid_bag_get_visible_items();

    if (array_length(visible_items) == 0)
    {
        return "";
    }

    if (
        raid_bag_index < 0 ||
        raid_bag_index >= array_length(visible_items)
    )
    {
        return "";
    }

    return visible_items[raid_bag_index];
}