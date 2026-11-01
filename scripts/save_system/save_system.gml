function save_system_init()
{
    save_format_version = 7;
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
    save_new_game_setup = false;
    save_new_game_name = "";
    save_new_game_skip_intro = false;
    save_new_game_keyboard_restore = "";
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

function save_begin_new_game(_player_name = "ROOK", _skip_intro = false)
{
    save_ready = false;
    save_reset_to_defaults();
    var member = crew[0];
    member.name = _player_name;
    crew[0] = member;
    save_character_active = true;
    save_unfinished_raid = false;
    save_loaded_from_backup = false;

    if (_skip_intro) save_skip_intro_progress();
    save_ready = true;

    if (!save_game(true)) return false;

    save_continue_available = true;
    state = GameState.HIDEOUT;
    return true;
}

function save_skip_intro_progress()
{
    var supply_crate = undefined;
    for (var i = 0; i < array_length(stash.items); i++)
    {
        if (stash.items[i].item_key == "supply_crate")
        {
            supply_crate = stash.items[i];
            break;
        }
    }
    if (!is_undefined(supply_crate)) onboarding_open_supply_crate(supply_crate, stash);

    progress_set_flag("story_intro_complete", true);
    progress_set_flag("starting_crate_claimed", true);
    progress_set_flag("onboarding_loadout_complete", true);
    progress_set_flag("salvage_bench_repaired", true);
    progress_set_flag("quest_safe_return_complete", true);
    progress_set_flag("quest_field_supplies_complete", true);
    variable_struct_set(workshop_progress, "salvage_bench", 1);

    var completed_quests = ["test_safe_return", "test_field_supplies"];
    for (var quest_index = 0; quest_index < array_length(completed_quests); quest_index++)
    {
        var quest_key = completed_quests[quest_index];
        var definition = quest_get_definition(quest_key);
        var progress = quest_get_progress(quest_key);
        progress.state = QuestState.COMPLETED;
        progress.reward_claimed = true;
        for (var objective_index = 0; objective_index < array_length(definition.objectives); objective_index++)
            progress.objectives[objective_index] = definition.objectives[objective_index].amount;
    }
    tracked_quest_key = "";
    quest_refresh_states();
    dialogue_set_flag("met_ghost", true);
    dialogue_set_flag("conversation_ghost_complete", true);

    stash_add("cash", 300);
    stash_add("ammo_9mm", 30);
    stash_add("bandage", 1);
    hideout_page = HideoutPage.TRADERS;
    hideout_menu_index = 0;
    hideout_focus = HideoutFocus.SIDEBAR;
    trader_mode = TraderMode.SELECT;
}

function save_debug_info()
{
    debug_log_add("Save version: " + string(save_format_version));
    debug_log_add("Save path: " + working_directory + save_filename);
}
