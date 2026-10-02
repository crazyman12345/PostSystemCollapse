function workshop_get_upgrade_requirements(_bench_key)
{
    var bench = variable_struct_get(workshop_db, _bench_key);
    var level = variable_struct_get(workshop_progress, _bench_key);

    if (level >= bench.max_level) return [];

    return bench.upgrade_requirements[level];
}