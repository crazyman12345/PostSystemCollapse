function raid_is_overencumbered()
{
    return raid_bag_get_weight() > raid_bag_get_max_weight();
}