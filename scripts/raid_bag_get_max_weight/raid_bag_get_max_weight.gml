function raid_bag_get_max_weight()
{
    var member =
        crew[raid.crew_index];

    // No backpack equipped
    if (member.bag == "")
    {
        return 2.0;
    }

    var bag_item =
        item_get(member.bag);

    if (is_undefined(bag_item))
    {
        return 2.0;
    }

    return bag_item.bag_capacity;
}