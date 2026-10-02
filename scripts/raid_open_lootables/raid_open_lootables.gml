function raid_open_lootable(_index)
{
    if (
        _index < 0
        || _index >= array_length(raid_lootables)
    )
    {
        return;
    }


    var l =
        raid_lootables[_index];


    var _loot =
        raid_generate_reward_loot(
            l.reward_type
        );


    for (
        var i = 0;
        i < array_length(_loot);
        i++
    )
    {
        var _angle =
            irandom(359);

        var _distance =
            irandom_range(18, 45);


        var _drop_x =
            l.lootable_x
            + lengthdir_x(
                _distance,
                _angle
            );


        var _drop_y =
            l.lootable_y
            + lengthdir_y(
                _distance,
                _angle
            );


        raid_spawn_ground_item(
            _loot[i].item_key,
            _loot[i].quantity,
            _drop_x,
            _drop_y
        );
    }


    // Remove container once opened
    array_delete(
        raid_lootables,
        _index,
        1
    );
}