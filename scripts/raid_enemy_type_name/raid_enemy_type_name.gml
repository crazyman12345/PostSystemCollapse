function raid_enemy_type_name(_type)
{
    switch (_type)
    {
        case RaidEnemyType.BURST_SHOOTER: return "BURST";
        case RaidEnemyType.KNIFE_STALKER: return "STALKER";
        case RaidEnemyType.SPINNER: return "SPINNER";
        case RaidEnemyType.KNIFE_DASHER: return "DASHER";
		case RaidEnemyType.WALL_RUSHER: return "RUSHER";
		case RaidEnemyType.BONES: return "BONES";
    }

    return "UNKNOWN";
}
