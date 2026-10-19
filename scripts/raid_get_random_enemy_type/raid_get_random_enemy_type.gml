function raid_get_random_enemy_type()
{
    if (variable_struct_exists(raid, "selected_area")
        && variable_struct_exists(raid.selected_area, "enemy_spawns"))
    {
        var _enemy_spawns = raid.selected_area.enemy_spawns;
        var _total_weight = 0;

        for (var i = 0; i < array_length(_enemy_spawns); i++)
            _total_weight += max(0, _enemy_spawns[i].weight);

        if (_total_weight <= 0)
            return undefined;

        var _weighted_roll = random(_total_weight);

        for (var i = 0; i < array_length(_enemy_spawns); i++)
        {
            _weighted_roll -= max(0, _enemy_spawns[i].weight);

            if (_weighted_roll < 0)
                return _enemy_spawns[i].type;
        }
    }

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
