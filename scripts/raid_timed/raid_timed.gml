function raid_timed(
    _key,
    _label,
    _duration
)
{
    return {
        action_key: _key,

        label: _label,

       // type: RaidActionType.,

        duration: _duration
    };
}