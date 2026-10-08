function workshop_get_salvageable_items()
{
    var list = [];
    var keys = variable_struct_get_names(global.items);

    for (var i = 0; i < array_length(keys); i++)
    {
        var key = keys[i];

        if (stash_get_quantity(key) <= 0) continue;
        if (!item_can_salvage(key)) continue;

        array_push(list, key);
    }

    return list;
}
