function workshop_salvage_interact()
{
    var items = workshop_get_salvageable_items();
    if (array_length(items) <= 0) return;

    workshop_content_index = clamp(workshop_content_index, 0, array_length(items) - 1);

    var key = items[workshop_content_index];
    var item = item_get(key);

    if (!workshop_salvage_item(key)) return;

    log_add("Salvaged " + item.name + ".");

    // Fix cursor if the last copy of the item disappeared
    var new_items = workshop_get_salvageable_items();
    if (array_length(new_items) <= 0) workshop_content_index = 0;
    else workshop_content_index = clamp(workshop_content_index, 0, array_length(new_items) - 1);
}

function workshop_salvage_item(_item_key)
{
    var item = item_get(_item_key);
    if (is_undefined(item) || !item_can_salvage(_item_key) || !stash_has(_item_key, 1)) return false;

	var salvage_outputs = [];
	var scavenging_nodes = skill_node_get_nodes("scavenging");
	var salvage_tech = skill_node_find(scavenging_nodes, "salvage_tech");
	var salvage_tech_unlocked = !is_undefined(salvage_tech) && skill_node_is_unlocked("scavenging", salvage_tech);
	var salvage_tech_2 = skill_node_find(scavenging_nodes, "salvage_tech_2");
	var salvage_tech_2_unlocked = !is_undefined(salvage_tech_2) && skill_node_is_unlocked("scavenging", salvage_tech_2);

	for (var i = 0; i < array_length(item.salvage); i++)
	{
		var result = item.salvage[i];
		var quantity = result.quantity;
		if (salvage_tech_unlocked || salvage_tech_2_unlocked)
		{
			var salvage_bonus = (salvage_tech_unlocked ? 0.10 : 0) + (salvage_tech_2_unlocked ? 0.10 : 0);
			var bonus_quantity = quantity * salvage_bonus;
			quantity += floor(bonus_quantity);
			if (random(1) < bonus_quantity - floor(bonus_quantity)) quantity++;
		}
		array_push(salvage_outputs, { item_key: result.item_key, quantity: quantity });
	}

    if (!workshop_salvage_outputs_fit(_item_key, salvage_outputs)) return false;

    stash_remove(_item_key, 1);
    var added_results = [];

    for (var i = 0; i < array_length(salvage_outputs); i++)
    {
        var result = salvage_outputs[i];

        if (!stash_add(result.item_key, result.quantity))
        {
            for (var j = array_length(added_results) - 1; j >= 0; j--)
            {
                var added_result = added_results[j];
                stash_remove(added_result.item_key, added_result.quantity);
            }

            stash_add(_item_key, 1);
            return false;
        }

        array_push(added_results, result);
    }

    player_skill_add_xp("scavenging", skill_xp_awards.scavenging_scrap);
    return true;
}

function workshop_salvage_outputs_fit(_item_key, _outputs)
{
    var storage = { grid_width: stash.grid_width, grid_height: stash.grid_height, items: [] };

    for (var i = 0; i < array_length(stash.items); i++)
    {
        var stored_item = stash.items[i];
        array_push(storage.items, {
            item_key: stored_item.item_key,
            quantity: stored_item.quantity,
            x: stored_item.x,
            y: stored_item.y,
            rotation: stored_item.rotation
        });
    }

    for (var i = array_length(storage.items) - 1; i >= 0; i--)
    {
        var stored_item = storage.items[i];
        if (stored_item.item_key != _item_key) continue;

        stored_item.quantity--;
        if (stored_item.quantity <= 0) array_delete(storage.items, i, 1);
        break;
    }

    for (var i = 0; i < array_length(_outputs); i++)
    {
        var result = _outputs[i];
        if (!stash_add(result.item_key, result.quantity, storage)) return false;
    }

    return true;
}
