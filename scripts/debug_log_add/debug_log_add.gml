function debug_log_add(_message)
{
    array_push(debug_log, _message);

    if (array_length(debug_log) > debug_log_max)
    {
        array_delete(debug_log, 0, 1);
    }
}