function raid_combat(_key, _label, _enemy_key, _blocks_movement = true)
{
    return {
        action_key: _key,
        label: _label,
        action_type: RaidActionType.START_COMBAT,
        enemy_key: _enemy_key,
		duration: 0.25,
		repeatable: false,
		blocks_movement: _blocks_movement
    };
}