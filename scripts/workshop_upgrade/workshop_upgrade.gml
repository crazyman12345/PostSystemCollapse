function workshop_upgrade(_bench_key)
{
    var bench = variable_struct_get(workshop_db, _bench_key);
    var level = variable_struct_get(workshop_progress, _bench_key);

    if (level >= bench.max_level) return false;
    if (!workshop_can_upgrade(_bench_key)) return false;

    var reqs = workshop_get_upgrade_requirements(_bench_key);

    for (var i = 0; i < array_length(reqs); i++)
    {
        var req = reqs[i];
        stash_remove(req.item_key, req.quantity);
    }

    variable_struct_set(workshop_progress, _bench_key, level + 1);
    return true;
}
