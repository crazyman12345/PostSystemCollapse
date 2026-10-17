function save_game(_allow_corrupt_overwrite = false)
{
    if (!save_can_write_now()) return false;

    if (file_exists(save_filename) && !save_file_is_valid(save_filename) && !_allow_corrupt_overwrite && !save_loaded_from_backup)
    {
        save_last_error = "Refusing to overwrite an invalid save.";
        return false;
    }

    var data = save_collect_data();
    var json = json_stringify(data);
    var file = file_text_open_write(save_temp_filename);
    if (file < 0)
    {
        save_last_error = "Could not open temporary save file.";
        return false;
    }

    file_text_write_string(file, json);
    file_text_close(file);

    if (!save_file_is_valid(save_temp_filename))
    {
        file_delete(save_temp_filename);
        save_last_error = "Temporary save validation failed.";
        return false;
    }

    if (file_exists(save_filename))
    {
        if (save_file_is_valid(save_filename))
        {
            if (file_exists(save_backup_filename)) file_delete(save_backup_filename);
            file_copy(save_filename, save_backup_filename);
        }
        else
        {
            if (file_exists(save_corrupt_filename)) file_delete(save_corrupt_filename);
            file_copy(save_filename, save_corrupt_filename);
        }
        file_delete(save_filename);
    }

    file_rename(save_temp_filename, save_filename);
    if (!file_exists(save_filename))
    {
        save_last_error = "Could not replace the save file.";
        return false;
    }

    save_dirty = false;
    save_dirty_delay = 0;
    save_loaded_from_backup = false;
    save_last_error = "";
    save_continue_available = true;
    return true;
}
