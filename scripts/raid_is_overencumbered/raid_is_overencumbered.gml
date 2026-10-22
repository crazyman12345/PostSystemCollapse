function raid_is_overencumbered()
{
    return raid_bag_get_weight() >= raid_get_max_weight();
}

function raid_get_encumbrance_penalties()
{
    var _weight_ratio = raid_bag_get_weight() / max(0.01, raid_get_max_weight());

    if (_weight_ratio >= 1.25) return { movement: 0.65, survival_drain: 2.00 };
    if (_weight_ratio >= 1.10) return { movement: 0.77, survival_drain: 1.61 };
    if (_weight_ratio >= 1.00) return { movement: 0.85, survival_drain: 1.35 };
    return { movement: 1, survival_drain: 1 };
}
