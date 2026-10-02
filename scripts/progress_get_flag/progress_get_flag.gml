function progress_get_flag(
    _flag_key
)
{
    if (!variable_struct_exists(
        global.progress.flags,
        _flag_key
    ))
    {
        return false;
    }


    return variable_struct_get(
        global.progress.flags,
        _flag_key
    );
}