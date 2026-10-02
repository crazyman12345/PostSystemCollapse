function loot_roll_table(_loot_table_key)
{
    if (!variable_struct_exists(global.loot_tables, _loot_table_key))
    {
        show_debug_message(
            "ERROR: Unknown loot table: "
            + _loot_table_key
        );

        return [];
    }

    var table =
        variable_struct_get(
            global.loot_tables,
            _loot_table_key
        );

    var results = [];


    for (var i = 0; i < array_length(table); i++)
    {
        var entry = table[i];

        if (random(1) <= entry.chance)
        {
            var quantity =
                irandom_range(
                    entry.quantity_min,
                    entry.quantity_max
                );

            array_push(
                results,
                {
                    item_key : entry.item_key,
                    quantity : quantity
                }
            );
        }
    }


    return results;
}