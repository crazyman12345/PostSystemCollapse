function workshop_can_upgrade(_bench_key)
{
    if (!workshop_bench_is_available(_bench_key)) return false;
    var reqs = workshop_get_upgrade_requirements(_bench_key);

    for (var i = 0; i < array_length(reqs); i++)
    {
        var req = reqs[i];
        if (!stash_has(req.item_key, req.quantity)) return false;
    }

    return true;
}

function workshop_bench_is_available(_bench_key)
{
    if (!variable_struct_exists(workshop_progress, _bench_key)) return false;
    if (variable_struct_get(workshop_progress, _bench_key) > 0) return true;
    if (_bench_key != "salvage_bench") return false;

    var progress = quest_get_progress("test_field_supplies");
    return !is_undefined(progress)
        && (progress.state == QuestState.ACTIVE || progress.state == QuestState.READY_TO_TURN_IN);
}
