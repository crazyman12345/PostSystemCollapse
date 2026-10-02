function log_add(_message)
{
    array_push(event_log, _message);

    if (array_length(event_log) > event_log_max)
    {
        array_delete(event_log, 0, 1);
    }
}