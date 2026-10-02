function raid_create_next_doors()
{
    raid_doors = [];

    var _reward1 = raid_get_random_reward();
    var _reward2 = raid_get_random_reward();

    // avoid duplicate choices
    while (_reward2 == _reward1)
    {
        _reward2 = raid_get_random_reward();
    }

    var _door_y = raid_room_y1 + 20;

    array_push(
        raid_doors,
        {
            door_x: raid_room_x1 + 140,
            door_y: _door_y,
            door_w: 70,
            door_h: 24,
            reward_type: _reward1
        }
    );

    array_push(
        raid_doors,
        {
            door_x: raid_room_x2 - 140,
            door_y: _door_y,
            door_w: 70,
            door_h: 24,
            reward_type: _reward2
        }
    );

    raid.doors_active = true;
}