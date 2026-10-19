function raid_create_next_doors(_activate = true)
{
    raid_doors = [];

    var _reward1 = raid_get_random_reward();
    var _reward2 = raid_get_random_reward();

    // avoid duplicate choices
    while (_reward2 == _reward1)
    {
        _reward2 = raid_get_random_reward();
    }

    var _door_y = raid_room_y1+16;
    var _north_segment_count = max(1, floor(raid_environment.wall_segments.north));
    var _north_segment_width = (raid_room_x2 - raid_room_x1) / _north_segment_count;
    var _left_door_x = raid_room_x1 + _north_segment_width * 1.5;
    var _right_door_x = raid_room_x2 - _north_segment_width * 1.5;

    array_push(
        raid_doors,
        {
            door_x: _left_door_x,
            door_y: _door_y,
            door_w: 50,
            door_h: 24,
            reward_type: _reward1,
            loot_halo_enabled: loot_halo_enabled,
            loot_halo_radius: loot_halo_radius,
            loot_halo_intensity: loot_door_halo_intensity,
            loot_halo_color: loot_halo_color,
            loot_halo_offset_x: loot_halo_offset_x,
            loot_halo_offset_y: loot_door_halo_offset_y
        }
    );

    array_push(
        raid_doors,
        {
            door_x: _right_door_x,
            door_y: _door_y,
            door_w: 50,
            door_h: 24,
            reward_type: _reward2,
            loot_halo_enabled: loot_halo_enabled,
            loot_halo_radius: loot_halo_radius,
            loot_halo_intensity: loot_door_halo_intensity,
            loot_halo_color: loot_halo_color,
            loot_halo_offset_x: loot_halo_offset_x,
            loot_halo_offset_y: loot_door_halo_offset_y
        }
    );

    if (_activate && raid.current_room_type != RaidRoomType.START)
    {
        for (var i = 0; i < array_length(raid_doors); i++)
        {
            var _door = raid_doors[i];
            smoke_create(
                _door.door_x - _door.door_w * 0.5,
                _door.door_y - 76,
                _door.door_x + _door.door_w * 0.5,
                _door.door_y - 16,
                20
            );
        }
    }

    raid.doors_active = _activate;
    raid_environment_build();
}
