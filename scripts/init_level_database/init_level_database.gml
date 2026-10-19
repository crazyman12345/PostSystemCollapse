function init_level_database()
{
    level_db = [
        {
            name: "ABANDONED STORE",
            danger_level: 1,
            sprite: -1,
            enemy_spawns: [
                {type: RaidEnemyType.KNIFE_STALKER, weight: 30},
                {type: RaidEnemyType.BURST_SHOOTER, weight: 25},
                {type: RaidEnemyType.SPINNER, weight: 20},
                {type: RaidEnemyType.KNIFE_DASHER, weight: 15},
                {type: RaidEnemyType.WALL_RUSHER, weight: 10}
            ]
        },
        {
            name: "SEWER TUNNELS",
            danger_level: 2,
            sprite: -1,
            enemy_spawns: [
                {type: RaidEnemyType.GRENADE_THROWER, weight: 100}
            ]
        },
        {
            name: "coming soon",
            danger_level: 1,
            sprite: -1
        },
        {
            name: "coming soon",
            danger_level: 1,
            sprite: -1
        },
        {
            name: "coming soon",
            danger_level: 1,
            sprite: -1
        },
        {
            name: "coming soon",
            danger_level: 1,
            sprite: -1
        }
     
    ];

    // Wall texture repetition can be tuned independently for each environment.
    for (var _level_index = 0; _level_index < array_length(level_db); _level_index++)
        level_db[_level_index].arena_wall_segments = raid_level_wall_segments();
}


function raid_level_wall_segments()
{
    return {
        north: 5,
        south: 5,
        east: 5,
        west: 5
    };
}
