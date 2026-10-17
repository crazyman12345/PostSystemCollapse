function progress_set_flag(
    _flag_key,
    _value
)
{
    variable_struct_set(
        global.progress.flags,
        _flag_key,
        _value
    );
    save_mark_dirty();
}
