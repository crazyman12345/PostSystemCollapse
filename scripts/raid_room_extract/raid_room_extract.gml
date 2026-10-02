function raid_room_extract(_key, _label, _requirements = []){
	    return {
        action_key: _key,
        label: _label,
		duration: 3,
        action_type: RaidActionType.EXTRACT,
        requirements: _requirements,
		repeatable: true
    };
}