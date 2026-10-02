function step_raid_timed_action()
{
    var delta_seconds =
        delta_time / 1000000;


    raid.action_timer +=
        delta_seconds;


    if (
        raid.action_timer
        >= raid.action_duration
    )
    {
        raid.action_timer =
            raid.action_duration;

        raid.action_active =
            false;

        raid_resolve_action(
            raid.pending_action
        );
    }
}