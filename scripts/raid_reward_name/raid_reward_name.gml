function raid_reward_name(_type)
{
    switch (_type)
    {
        case RaidRewardType.FILING_CABINETS: return "FILING CABINETS";
        case RaidRewardType.SUPPLY_CRATES: return "SUPPLY CRATES";
        case RaidRewardType.TOOLBOX: return "TOOLBOX";
        case RaidRewardType.CASH_REGISTER: return "CASH REGISTER";
        case RaidRewardType.MEDICAL_CRATE: return "MEDICAL CRATE";
        case RaidRewardType.ELECTRONICS: return "ELECTRONICS";
        case RaidRewardType.FOOD_STORAGE: return "FOOD STORAGE";
        case RaidRewardType.WEAPON_CRATE: return "WEAPON CRATE";
        case RaidRewardType.ARMOR_CRATE: return "ARMOR CRATE";
        case RaidRewardType.BACKROOM_STASH: return "BACKROOM STASH";
    }

    return "UNKNOWN";
}