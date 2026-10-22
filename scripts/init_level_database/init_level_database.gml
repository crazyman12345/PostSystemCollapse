function init_level_database()
{
    var _store_light = make_color_rgb(215, 175, 115);
    var _sewer_teal = make_color_rgb(117, 166, 149);
    level_db = [
        {
            name: "ABANDONED STORE",
            danger_level: 1,
            sprite: -1,
            floor_tiles: [tile4, tile3, tile4_1, tile4_2, tile4_3, tile4_4],
            arena_wall_sprites: [spr_shelf1, spr_shelf2, spr_shelf3, spr_shelf4, spr_shelf5],
            arena_door_sprite: spr_door1,
            light_color: _store_light,
            enemy_spawns: [
                {type: RaidEnemyType.KNIFE_STALKER, weight: 30},
                {type: RaidEnemyType.BURST_SHOOTER, weight: 25},
                {type: RaidEnemyType.SPINNER, weight: 20},
                {type: RaidEnemyType.KNIFE_DASHER, weight: 15},
                {type: RaidEnemyType.WALL_RUSHER, weight: 10}
            ],
            beginning_enemy_count: 3,
            ending_enemy_count: 5
        },
        {
            name: "SEWER TUNNELS",
            danger_level: 2,
            sprite: -1,
            floor_tiles: [sewertile1, sewertile2, sewertile3, sewertile4, sewertile5, sewertile6],
            arena_wall_sprites: [spr_swall1_1, spr_swall1_2, spr_swall1_3, spr_swall1_4],
            arena_door_sprite: spr_sewerdoor,
            light_color: _sewer_teal,
            enemy_spawns: [
                {type: RaidEnemyType.GRENADE_THROWER, weight: 30},
                {type: RaidEnemyType.BURST_DODGER, weight: 30},
                {type: RaidEnemyType.SHOTGUN_BURSTER, weight: 25},
                {type: RaidEnemyType.BOMBER, weight: 15}
            ],
            beginning_enemy_count: 3,
            ending_enemy_count: 8
        },
        {
            name: "coming soon",
            danger_level: 3,
            sprite: -1
        },
        {
            name: "coming soon",
            danger_level: 4,
            sprite: -1
        },
        {
            name: "coming soon",
            danger_level: 5,
            sprite: -1
        },
        {
            name: "coming soon",
            danger_level: 6,
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

function raid_area_is_available(_area_index)
{
    if (!is_real(_area_index) || _area_index != floor(_area_index)
    || _area_index < 0 || _area_index >= array_length(level_db)) return false;

    var _area = level_db[_area_index];
    if (!is_struct(_area)
    || !variable_struct_exists(_area, "name")
    || !variable_struct_exists(_area, "danger_level")
    || !variable_struct_exists(_area, "floor_tiles")
    || !variable_struct_exists(_area, "arena_wall_sprites")
    || !variable_struct_exists(_area, "arena_door_sprite")
    || !variable_struct_exists(_area, "light_color")
    || !variable_struct_exists(_area, "enemy_spawns")
    || !variable_struct_exists(_area, "beginning_enemy_count")
    || !variable_struct_exists(_area, "ending_enemy_count")) return false;

    if (!is_array(_area.floor_tiles) || array_length(_area.floor_tiles) <= 0
    || !is_array(_area.arena_wall_sprites) || array_length(_area.arena_wall_sprites) <= 0
    || !is_array(_area.enemy_spawns) || array_length(_area.enemy_spawns) <= 0) return false;

    return global.progress.danger_level >= _area.danger_level;
}

function raid_return_to_area_selection()
{
    raid.selected_area_index = -1;
    raid.selected_area = undefined;
    combat_area_index = raid_area_is_available(0) ? 0 : -1;
    loadout_confirm_start = false;
    loadout_confirm_index = 0;
    overlay_mode = OverlayMode.NONE;
    state = GameState.HIDEOUT;
    hideout_page = HideoutPage.RAIDS;
    hideout_focus = HideoutFocus.CONTENT;
}
