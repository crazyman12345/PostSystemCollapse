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
            var remaining = _loot[i].quantity;
            var max_stack = item_get_max_stack(_loot[i].item_key);
            while (remaining > 0)
            {
                var _item = stash_place_item(_loot[i].item_key, -1, -1, 0, l.storage);
                if (is_undefined(_item)) _item = stash_place_item(_loot[i].item_key, -1, -1, 90, l.storage);
                if (is_undefined(_item)) break;
                _item.quantity = min(remaining, max_stack);
                remaining -= _item.quantity;
            }
        }

        l.opened = true;
        raid_lootables[_index] = l;
        player_skill_add_xp("scavenging", skill_xp_awards.scavenging_container);
    }

    raid.active_loot_container = raid_lootables[_index];
    overlay_mode = OverlayMode.LOADOUT;
}
