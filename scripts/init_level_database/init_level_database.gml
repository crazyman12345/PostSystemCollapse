function init_level_database()
{
    level_db = [
        {
            name: "ABANDONED STORE",
            danger_level: 1,
            sprite: -1,
        },
        {
            name: "TEST 1",
            danger_level: 1,
            sprite: -1
        },
        {
            name: "TEST 2",
            danger_level: 1,
            sprite: -1
        },
        {
            name: "TEST 3",
            danger_level: 1,
            sprite: -1
        },
        {
            name: "TEST 4",
            danger_level: 1,
            sprite: -1
        },
        {
            name: "TEST 5",
            danger_level: 1,
            sprite: -1
        },
        {
            name: "TEST 6",
            danger_level: 1,
            sprite: -1
        },
        {
            name: "TEST 7",
            danger_level: 1,
            sprite: -1
        },
        {
            name: "TEST 8",
            danger_level: 1,
            sprite: -1,
            enemies: []
        },
        {
            name: "TEST 9",
            danger_level: 1,
            sprite: -1

        },
        {
            name: "TEST 10",
            danger_level: 1,
            sprite: -1
        },
        {
            name: "TEST 11",
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
