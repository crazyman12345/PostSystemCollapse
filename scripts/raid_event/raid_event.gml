function raid_event(_action_key, _label, _event_text, _duration, _noise, _repeatable, _requirements = [], _effects = [])
{
    return {
        label: _label,
        action_type: RaidActionType.EVENT,
        action_key: _action_key,
		event_text: _event_text,
		duration: _duration,
		noise: _noise,
		repeatable: _repeatable,
		requirements: _requirements,
		effects: _effects
    };
}

