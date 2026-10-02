function raid_get_random_enemy_type()
{
    var _roll = irandom(99);

    if (_roll < 30)
        return RaidEnemyType.KNIFE_STALKER;

    if (_roll < 55)
        return RaidEnemyType.BURST_SHOOTER;

    if (_roll < 75)
        return RaidEnemyType.SPINNER;

    if (_roll < 90)
        return RaidEnemyType.KNIFE_DASHER;

    return RaidEnemyType.WALL_RUSHER;
}