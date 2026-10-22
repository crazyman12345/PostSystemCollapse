function progress_complete_bones()
{
    var _changed = false;
    if (!global.progress.flags.prototype_boss_dead)
    {
        global.progress.flags.prototype_boss_dead = true;
        _changed = true;
    }
    if (!global.progress.flags.prototype_raid_complete)
    {
        global.progress.flags.prototype_raid_complete = true;
        _changed = true;
    }
    if (!global.progress.flags.danger_0_complete)
    {
        global.progress.flags.danger_0_complete = true;
        _changed = true;
    }
    if (global.progress.danger_level < 2)
    {
        global.progress.danger_level = 2;
        _changed = true;
    }

    if (!_changed) return false;

    save_mark_dirty();
    if (!save_game()) debug_log_add("Bones progression could not be saved immediately.");
    return true;
}
