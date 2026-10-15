function raid_spawn_reward_lootable(_reward_type)
{
	audio_play_sound(smoke_sound,0,false);
    var _cx =
        (raid_room_x1 + raid_room_x2) * 0.5;

    var _cy =
        (raid_room_y1 + raid_room_y2) * 0.5;


    // Put it slightly above room center
    _cy -= 95;

    var _visual = raid_lootable_visuals[_reward_type];

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
        height: 22,

        sprite_index: _visual.sprite,
        image_index: 0,
        image_xscale: _visual.scale,
        image_yscale: _visual.scale,
        image_angle: 0,
        shadow_offset_x: variable_struct_exists(_visual, "shadow_offset_x") ? _visual.shadow_offset_x : 0,
        shadow_offset_y: variable_struct_exists(_visual, "shadow_offset_y") ? _visual.shadow_offset_y : 0,

        loot_halo_enabled: loot_halo_enabled,
        loot_halo_radius: loot_halo_radius,
        loot_halo_intensity: loot_halo_intensity,
        loot_halo_color: loot_halo_color,
        loot_halo_offset_x: loot_halo_offset_x,
        loot_halo_offset_y: loot_halo_offset_y
    };

    // Place the configured art's visible bottom-center on the lootable's floor.
    var _sprite = _lootable.sprite_index;
    var _sprite_scale = _lootable.image_xscale;
    var _visible_center_x = (sprite_get_bbox_left(_sprite) + sprite_get_bbox_right(_sprite)) * 0.5;
    var _ground_y = _cy + _lootable.height * 0.5;
    _lootable.sprite_x = _cx - (_visible_center_x - sprite_get_xoffset(_sprite)) * _sprite_scale;
    _lootable.sprite_y = _ground_y - (sprite_get_bbox_bottom(_sprite) - sprite_get_yoffset(_sprite)) * _lootable.image_yscale;

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
        12
    );
}
