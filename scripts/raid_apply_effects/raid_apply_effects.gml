function raid_apply_effects(_effects)
{
    for (
        var i = 0;
        i < array_length(_effects);
        i++
    )
    {
        raid_apply_effect(
            _effects[i]
        );
    }
}