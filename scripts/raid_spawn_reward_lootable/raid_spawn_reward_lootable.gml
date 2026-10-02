function raid_spawn_reward_lootable(_reward_type)
{
    var _cx =
        (raid_room_x1 + raid_room_x2) * 0.5;

    var _cy =
        (raid_room_y1 + raid_room_y2) * 0.5;


    // Put it slightly above room center
    _cy -= 55;


    var _lootable = {
        lootable_x: _cx,
        lootable_y: _cy,

        reward_type: _reward_type,

        opened: false,

        width: 34,
        height: 22
    };


    array_push(
        raid_lootables,
        _lootable
    );
}