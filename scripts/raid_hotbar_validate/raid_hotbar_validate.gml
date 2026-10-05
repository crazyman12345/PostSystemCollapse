function raid_hotbar_validate()
{
    for (var i = 0; i < 6; i++)
    {
        var item = raid.hotbar[i];
        if (is_undefined(item)) continue;

        var definition = item_get(item.item_key);
        if (!raid_hotbar_is_usable(definition)
        || item.quantity <= 0
        || is_undefined(raid_hotbar_find_item(item)))
        {
            raid.hotbar[i] = undefined;
        }
    }
}
