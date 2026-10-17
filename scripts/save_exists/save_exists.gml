function save_exists()
{
    return save_file_is_valid(save_filename) || save_file_is_valid(save_backup_filename);
}

function save_file_is_valid(_filename)
{
    if (!file_exists(_filename)) return false;
    var data = save_read_data(_filename);
    if (is_undefined(data)) return false;
    data = save_migrate_data(data);
    return !is_undefined(data) && save_validate_data(data);
}

function save_read_data(_filename)
{
    var file = file_text_open_read(_filename);
    if (file < 0) return undefined;

    var json = "";
    while (!file_text_eof(file))
    {
        json += file_text_read_string(file);
        file_text_readln(file);
    }
    file_text_close(file);

    try
    {
        return json_parse(json);
    }
    catch (exception)
    {
        return undefined;
    }
}
