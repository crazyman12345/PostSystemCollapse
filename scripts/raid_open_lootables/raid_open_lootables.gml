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


    if (!l.opened)
    {
        var _loot = raid_generate_reward_loot(l.reward_type);

        for (var i = 0; i < array_length(_loot); i++)
        {
            var _item = stash_place_item(_loot[i].item_key, -1, -1, 0, l.storage);
            if (is_undefined(_item))
                _item = stash_place_item(_loot[i].item_key, -1, -1, 90, l.storage);

            if (!is_undefined(_item)) _item.quantity = _loot[i].quantity;
        }

        l.opened = true;
        raid_lootables[_index] = l;
    }

    raid.active_loot_container = raid_lootables[_index];
    overlay_mode = OverlayMode.LOADOUT;
}
