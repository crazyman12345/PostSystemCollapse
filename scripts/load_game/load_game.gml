function load_game()
{
    if (state == GameState.RAID) return false;

    var data = undefined;
    var loaded_backup = false;
    if (save_file_is_valid(save_filename)) data = save_read_data(save_filename);
    else if (save_file_is_valid(save_backup_filename))
    {
        data = save_read_data(save_backup_filename);
        loaded_backup = true;
    }

    if (is_undefined(data))
    {
        save_last_error = "No valid player save was found.";
        return false;
    }

    var needs_resave = variable_struct_exists(data, "version") && data.version != save_format_version;
    data = save_migrate_data(data);
    if (is_undefined(data) || !save_validate_data(data))
    {
        save_last_error = "The player save is invalid.";
        return false;
    }

    save_apply_data(data);
    save_character_active = true;
    save_loaded_from_backup = loaded_backup;
    save_dirty = false;
    save_dirty_delay = 0;

    var interrupted = save_unfinished_raid;
    save_resolve_unfinished_raid();
    if (interrupted)
    {
        if (!save_game())
        {
            save_last_error = "Raid loss was applied but could not be saved.";
            return false;
        }
    }
    else if (needs_resave) save_game();

    raid_set_state(RaidState.INACTIVE);
    overlay_mode = OverlayMode.NONE;
    state = GameState.HIDEOUT;
    hideout_page = HideoutPage.STASH;
    for (var i = 0; i < array_length(hideout_menu_items); i++)
    {
        if (hideout_menu_items[i].page == hideout_page) hideout_menu_index = i;
    }
    hideout_focus = HideoutFocus.CONTENT;
    trader_mode = TraderMode.SELECT;
    save_continue_available = true;
    if (loaded_backup) debug_log_add("Recovered player save from backup.");
    return true;
}
