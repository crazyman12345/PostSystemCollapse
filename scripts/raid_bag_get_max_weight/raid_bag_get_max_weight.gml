function raid_bag_get_max_weight()
{
    var _max_weight = 8.0;
    var _nodes = skill_node_get_nodes("strength");

    for (var i = 1; i <= 10; i++)
    {
        var _node = skill_node_find(_nodes, "strong_legs_" + string(i));
        if (!is_undefined(_node) && skill_node_is_unlocked("strength", _node)) _max_weight += 2.0;
    }

    return _max_weight;
}
