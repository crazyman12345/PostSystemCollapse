function raid_bag_get_remaining_weight()
{
    return max(
        0,
        raid_bag_get_max_weight()
        - raid_bag_get_weight()
    );
}