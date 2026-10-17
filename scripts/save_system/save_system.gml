function save_system_init()
{
    save_format_version = 2;
    save_filename = "player_save.json";
    save_backup_filename = "player_save.backup.json";
    save_temp_filename = "player_save.tmp.json";
    save_corrupt_filename = "player_save.corrupt.json";
    save_dirty = false;
    save_dirty_delay = 0;
    save_ready = true;
    save_character_active = false;
    save_unfinished_raid = false;
    save_loaded_from_backup = false;
    save_last_error = "";
    save_new_game_confirm = false;
    save_new_game_confirm_index = 1;
    save_continue_available = save_exists();
}

function save_mark_dirty()
{
    if (!variable_instance_exists(id, "save_ready") || !save_ready || !save_character_active) return;
    save_dirty = true;
    save_dirty_delay = 60;
}

function save_can_write_now()
{
    if (!save_ready || !save_character_active || !is_undefined(stash.held_item)) return false;
    if (variable_struct_exists(raid, "inventory_item") && !is_undefined(raid.inventory_item)) return false;
    return true;
}

function save_update()
{
    if (!save_dirty) return;
    save_dirty_delay -= frame_scale;
    if (save_dirty_delay <= 0 && save_can_write_now()) save_game();
}

function save_begin_new_game()
{
    save_ready = false;
    save_reset_to_defaults();
    save_ready = true;
    save_character_active = true;
    save_unfinished_raid = false;
    save_loaded_from_backup = false;

    if (!save_game(true)) return false;

    save_continue_available = true;
    state = GameState.HIDEOUT;
    return true;
}

function save_debug_info()
{
    debug_log_add("Save version: " + string(save_format_version));
    debug_log_add("Save path: " + working_directory + save_filename);
}
