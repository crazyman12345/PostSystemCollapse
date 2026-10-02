function raid_search(_key, _label, _loot_table, _duration, _noise, _repeatable)
{
    return {
        action_key: _key,
        label: _label,
        action_type: RaidActionType.SEARCH,
        loot_table_key: _loot_table,
		duration: _duration,
		noise: _noise,
		repeatable: _repeatable,
    };
}