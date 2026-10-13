function trader_get_sell_price(_item_key)
{
    var item = item_get(_item_key);

    if (is_undefined(item))
    {
        return 0;
    }

    // Trader pays 60% of base item value for now
    var sell_multiplier = 0.60;
	var nodes = skill_node_get_nodes("scavenging");
	var charisma = skill_node_find(nodes, "charisma");
	var charisma_2 = skill_node_find(nodes, "charisma_2");
	var charisma_multiplier = 1;
	if (!is_undefined(charisma) && skill_node_is_unlocked("scavenging", charisma)) charisma_multiplier += 0.05;
	if (!is_undefined(charisma_2) && skill_node_is_unlocked("scavenging", charisma_2)) charisma_multiplier += 0.05;
	sell_multiplier *= charisma_multiplier;

    var sell_price = floor(
        item.base_value * sell_multiplier
    );

    return max(1, sell_price);
}
