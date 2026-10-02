function raid_move(
    _target,
    _label,
	_duration,
	_noise,
	_action_repeatable,
	_requirements = []
)
{
    return {
        action_key: "move_" + _target,
        label: _label,
        action_type: RaidActionType.MOVE,
        target: _target,
		duration: _duration,
		noise: _noise,
		repeatable: _action_repeatable,
		requirements: _requirements
    };
}