function raid_get_random_reward()
{
    var _roll = irandom(99);

    if (_roll < 25)
        return RaidRewardType.FILING_CABINETS;

    if (_roll < 45)
        return RaidRewardType.SUPPLY_CRATES;

    if (_roll < 60)
        return RaidRewardType.TOOLBOX;

    if (_roll < 70)
        return RaidRewardType.CASH_REGISTER;

    if (_roll < 80)
        return RaidRewardType.MEDICAL_CRATE;

    if (_roll < 87)
        return RaidRewardType.ELECTRONICS;

    if (_roll < 92)
        return RaidRewardType.FOOD_STORAGE;

    if (_roll < 96)
        return RaidRewardType.WEAPON_CRATE;

    if (_roll < 99)
        return RaidRewardType.ARMOR_CRATE;

    return RaidRewardType.BACKROOM_STASH;
}