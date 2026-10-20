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
        case RaidEnemyType.GRENADE_THROWER: return "GRENADE THROWER";
        case RaidEnemyType.BURST_DODGER: return "BURST DODGER";
        case RaidEnemyType.SHOTGUN_BURSTER: return "SHOTGUN BURSTER";
        case RaidEnemyType.BOMBER: return "BOMBER";
    }

    return "UNKNOWN";
}
