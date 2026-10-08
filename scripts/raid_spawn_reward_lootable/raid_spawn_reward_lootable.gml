function raid_spawn_reward_lootable(_reward_type)
{
	audio_play_sound(smoke_sound,0,false);
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

        storage: {
            grid_width: 6,
            grid_height: 6,
            items: []
        },

        width: 34,
        height: 22
    };

    switch (_reward_type)
    {
        case RaidRewardType.FILING_CABINETS:
        case RaidRewardType.CASH_REGISTER:
            _lootable.storage.grid_width = 5;
            _lootable.storage.grid_height = 4;
            break;

        case RaidRewardType.TOOLBOX:
            _lootable.storage.grid_width = 4;
            _lootable.storage.grid_height = 4;
            break;

        case RaidRewardType.MEDICAL_CRATE:
            _lootable.storage.grid_width = 5;
            _lootable.storage.grid_height = 5;
            break;

        case RaidRewardType.BACKROOM_STASH:
            _lootable.storage.grid_width = 7;
            _lootable.storage.grid_height = 5;
            break;
    }


    array_push(
        raid_lootables,
        _lootable
    );

    smoke_create(
        _cx - _lootable.width * 0.5 - 5,
        _cy - _lootable.height * 0.5 - 5,
        _cx + _lootable.width * 0.5 +5,
        _cy + _lootable.height * 0.5 + 5,
        30
    );
}
