function raid_is_overencumbered()
{
    return raid_bag_get_weight() >= raid_get_max_weight();
}

function raid_get_encumbrance_penalties()
{
    var _weight_ratio = raid_bag_get_weight() / max(0.01, raid_get_max_weight());
    var _movement = 1;
    var _survival_drain = 1;

    if (_weight_ratio >= 1.25) { _movement = 0.65; _survival_drain = 2.00; }
    else if (_weight_ratio >= 1.10) { _movement = 0.77; _survival_drain = 1.61; }
    else if (_weight_ratio >= 1.00) { _movement = 0.85; _survival_drain = 1.35; }

    var _bag = armor_get_equipped_bag_stats();
    if (!is_undefined(_bag))
    {
        _movement = lerp(_movement, 1, _bag.encumbrance_penalty_reduction);
        _survival_drain *= _bag.survival_drain_multiplier;
    }
    return { movement: _movement, survival_drain: _survival_drain };
}
