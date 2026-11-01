function onboarding_phase2_init()
{
    onboarding_prologue_index = 0;
    onboarding_prologue_cards = [
        "In the year 2070, nuclear warfare broke out across the world, most of modern society was destroyed. All the worlds nations fell and what remained were small settlements that struggled to get by. [PLAYER] was a member of a small hardworking settlement, that did well for themselves. All that changed one day when the raiders rolled in.",
        "They ransacked the city. Just as [PLAYER] was sitting down to eat with his wife and son, a flashbang was thrown into the living room. In a daze, he lay on the ground stunned and barely able to see. When he opened his eyes, he saw 3 men armed with rifles.",
		"He felt the butt of one of the rifles nearly knock him unconscious. He saw the men gun down his wife and son in cold blood. He saw the patches on their vests: 'SUPERCORP'. They turned the rifles on him and put a bullet in his head and the world went black.",
        "Unknown scavengers found him barely alive in a ditch 100 miles away, and carried him to the nearby 'Junk City'. He awoke in a bed in a ramschackle hut, with a small desk and a terminal."
    ];
}

function onboarding_first_quest_progress()
{
    return quest_get_progress("test_safe_return");
}

function onboarding_first_quest_active()
{
    var _progress = onboarding_first_quest_progress();
    return !is_undefined(_progress) && _progress.state == QuestState.ACTIVE;
}

function onboarding_is_active()
{
    if (!progress_get_flag("story_intro_complete")) return true;
    var _progress = onboarding_first_quest_progress();
    return !is_undefined(_progress) && _progress.state <= QuestState.ACTIVE;
}

function onboarding_can_start_raid()
{
    if (!progress_get_flag("starting_crate_claimed")) return false;
    if (!progress_get_flag("onboarding_loadout_complete")) return false;
    var _progress = onboarding_first_quest_progress();
    return !is_undefined(_progress) && _progress.state >= QuestState.ACTIVE;
}

function onboarding_mara_node_id()
{
    var _progress = onboarding_first_quest_progress();
    if (is_undefined(_progress) || _progress.state <= QuestState.AVAILABLE) return "mara_onboarding";
    if (progress_get_flag("onboarding_replacement_pending")) return "mara_onboarding_replacement";
    if (!progress_get_flag("starting_crate_claimed")) return "mara_onboarding_accepted";
    return "mara_onboarding_reminder";
}

function onboarding_open_mara_node(_node_id)
{
    current_trader_key = "mara";
    trader_mode = TraderMode.CONVERSATION;
    dialogue_history = [];
    dialogue_set_flag("met_mara", true);
    dialogue_set_node(_node_id);
    hideout_menu_index = 1;
    hideout_page = HideoutPage.MESSAGES;
    hideout_focus = HideoutFocus.CONTENT;
}

function onboarding_open_initial_mara_message()
{
    onboarding_open_mara_node("mara_onboarding");
}

function onboarding_open_mara_message()
{
    onboarding_open_mara_node(onboarding_mara_node_id());
}

function onboarding_get_menu_entries()
{
    var _entries = [
        { name: "MESSAGES", key: "messages", page: HideoutPage.MESSAGES, menu_index: 1 }
    ];
    var _progress = onboarding_first_quest_progress();
    if (!is_undefined(_progress) && _progress.state >= QuestState.ACTIVE)
        array_push(_entries, { name: "STASH", key: "stash", page: HideoutPage.STASH, menu_index: 2 });
    if (progress_get_flag("onboarding_loadout_complete"))
        array_push(_entries, { name: "START RAID!", key: "raids", page: HideoutPage.RAIDS, menu_index: 10 });
    return _entries;
}

function onboarding_sync_menu_selection(_entries)
{
    for (var _i = 0; _i < array_length(_entries); _i++)
    {
        if (_entries[_i].page == hideout_page)
        {
            hideout_menu_index = _entries[_i].menu_index;
            return _i;
        }
    }
    hideout_menu_index = _entries[0].menu_index;
    hideout_page = _entries[0].page;
    return 0;
}

function onboarding_step_sidebar()
{
    var _entries = onboarding_get_menu_entries();
    var _selected = onboarding_sync_menu_selection(_entries);
    var _hovered = onboarding_get_hovered_menu_entry(_entries);
    if (_hovered != -1 && _hovered != _selected && mouse_check_button_pressed(mb_left))
    {
        hideout_menu_index = _entries[_hovered].menu_index;
        hideout_page = _entries[_hovered].page;
        hideout_focus = HideoutFocus.CONTENT;
        trader_mode = TraderMode.SELECT;
        menu_index = 0;
        scroll_sound();
        return;
    }
    if (keyboard_check_pressed(vk_escape))
    {
        state = GameState.MAIN_MENU;
        menu_index = 0;
        audio_play_sound(snd_interact, 0, false);
    }
}

function onboarding_step_hideout()
{
    if (!progress_get_flag("story_intro_complete"))
    {
        if (keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left))
        {
            onboarding_prologue_index++;
            if (onboarding_prologue_index >= array_length(onboarding_prologue_cards))
            {
                progress_set_flag("story_intro_complete", true);
                onboarding_open_initial_mara_message();
            }
        }
        return true;
    }

    if (!onboarding_is_active()) return false;
    onboarding_update_loadout_progress();
    if (progress_get_flag("onboarding_replacement_pending") && onboarding_deliver_replacement_kit())
    {
        progress_set_flag("onboarding_replacement_pending", false);
        onboarding_open_mara_node("mara_onboarding_replacement");
        save_game();
    }
    if (trader_mode == TraderMode.CONVERSATION)
    {
        step_trader_conversation();
        return true;
    }
    var _inventory_popup_open = hideout_page == HideoutPage.STASH
        && (inventory_context_active || !is_undefined(inventory_inspect_item));
    if (!_inventory_popup_open && mouse_check_button_pressed(mb_left))
    {
        var _entries = onboarding_get_menu_entries();
        var _selected = onboarding_sync_menu_selection(_entries);
        var _clicked = onboarding_get_hovered_menu_entry(_entries);
        if (_clicked != -1)
        {
            if (_clicked != _selected)
            {
                if (trader_mode == TraderMode.CONVERSATION) dialogue_close();
                else trader_mode = TraderMode.SELECT;
                hideout_menu_index = _entries[_clicked].menu_index;
                hideout_page = _entries[_clicked].page;
                menu_index = 0;
                scroll_sound();
            }
            return true;
        }
    }
    switch (hideout_page)
    {
        case HideoutPage.MESSAGES: step_messages_all(); break;
        case HideoutPage.STASH: step_hideout_stash(); break;
        case HideoutPage.RAIDS: step_hideout_raid(); break;
        default:
            hideout_page = HideoutPage.MESSAGES;
            hideout_menu_index = 1;
            break;
    }
    return true;
}

function onboarding_draw_hideout()
{
    if (!progress_get_flag("story_intro_complete"))
    {
        draw_set_color(c_black);
        draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
        draw_set_font(fnt_terminal_medium);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(global.ui_text_color);
        var _card = onboarding_prologue_cards[clamp(onboarding_prologue_index, 0, array_length(onboarding_prologue_cards) - 1)];
        _card = string_replace_all(_card, "[PLAYER]", crew[0].name);
        draw_text_ext(display_get_gui_width() * 0.5, display_get_gui_height() * 0.5, _card, 38, 960);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        return true;
    }

    if (!onboarding_is_active()) return false;
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_color(global.hideout_panel_color);
    draw_set_alpha(0.78);
    draw_rectangle(320, 1, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
    onboarding_draw_staging_sidebar();
    if (trader_mode == TraderMode.CONVERSATION)
    {
        draw_trader_conversation();
        heading_box(320, 1, display_get_gui_width() - 320, display_get_gui_height() - 1,
            hideout_menu_items[hideout_menu_index].name, 60);
        return true;
    }

    switch (hideout_page)
    {
        case HideoutPage.MESSAGES: draw_messages_all(); break;
        case HideoutPage.STASH:
            draw_hideout_stash();
            break;
        case HideoutPage.RAIDS: draw_hideout_raid_select(); break;
    }
    if (hideout_page != HideoutPage.MESSAGES)
        heading_box(320, 1, display_get_gui_width() - 320, display_get_gui_height() - 1,
            hideout_menu_items[hideout_menu_index].name, 60);
    return true;
}

function onboarding_draw_staging_sidebar()
{
    var _sidebar_width = 320;
    var _entries = onboarding_get_menu_entries();

    draw_set_font(fnt_terminal_tiny);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(global.hideout_background_color);
    draw_set_alpha(0.88);
    draw_rectangle(1, 1, _sidebar_width, display_get_gui_height(), false);
    draw_set_alpha(1);
    draw_set_color(global.ui_text_color);
    draw_hideout_sidebar_frame(_sidebar_width, display_get_gui_height());

    for (var _i = 0; _i < array_length(hideout_menu_items); _i++)
    {
        var _entry = hideout_menu_items[_i];
        var _unlocked = false;
        for (var _entry_index = 0; _entry_index < array_length(_entries); _entry_index++)
        {
            if (_entries[_entry_index].menu_index == _i)
            {
                _unlocked = true;
                break;
            }
        }

        var _selected = _unlocked && _entry.page == hideout_page;
        draw_hideout_sidebar_item(_entry, hideout_sidebar_item_top(_i), _selected, _unlocked);
    }

    var _last_sidebar_item_top = hideout_sidebar_item_top(array_length(hideout_menu_items) - 1);
    var _sidebar_shape_top = max(_last_sidebar_item_top + 70, display_get_gui_height() - 350);
    draw_ascii_sidebar_shape(32, _sidebar_shape_top, hideout_menu_items[hideout_menu_index].key);
}

function onboarding_get_hovered_menu_entry(_entries)
{
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    if (_mouse_x < 18 || _mouse_x > 302) return -1;

    for (var _menu_index = 0; _menu_index < array_length(hideout_menu_items); _menu_index++)
    {
        var _y = hideout_sidebar_item_top(_menu_index);

        if (_mouse_y >= _y && _mouse_y < _y + 42)
        {
            for (var _entry_index = 0; _entry_index < array_length(_entries); _entry_index++)
                if (_entries[_entry_index].menu_index == _menu_index) return _entry_index;
            return -1;
        }
    }
    return -1;
}

function onboarding_carried_has_item(_item_key)
{
    var _containers = [stash.pockets, stash.backpack];
    for (var _container_index = 0; _container_index < array_length(_containers); _container_index++)
    {
        var _items = _containers[_container_index].items;
        for (var _i = 0; _i < array_length(_items); _i++)
            if (_items[_i].item_key == _item_key && _items[_i].quantity > 0) return true;
    }
    return false;
}

function onboarding_has_equipped_gun()
{
    return crew[0].weapon != "" || crew[0].weapon_2 != "";
}

function onboarding_has_equipped_bag()
{
    return crew[0].bag != "";
}

function onboarding_has_carried_ammo()
{
    var _weapon_keys = [crew[0].weapon, crew[0].weapon_2];
    for (var _i = 0; _i < array_length(_weapon_keys); _i++)
    {
        var _weapon = item_get(_weapon_keys[_i]);
        if (!is_undefined(_weapon) && variable_struct_exists(_weapon, "ammo_key")
        && onboarding_carried_has_item(_weapon.ammo_key)) return true;
    }
    return false;
}

function onboarding_has_carried_medicine()
{
    var _containers = [stash.pockets, stash.backpack];
    for (var _container_index = 0; _container_index < array_length(_containers); _container_index++)
    {
        var _items = _containers[_container_index].items;
        for (var _i = 0; _i < array_length(_items); _i++)
        {
            var _definition = item_get(_items[_i].item_key);
            if (!is_undefined(_definition) && _definition.category == ItemCategory.MEDICAL
            && _items[_i].quantity > 0) return true;
        }
    }
    return false;
}

function onboarding_get_loadout_step()
{
    if (!onboarding_has_equipped_gun()) return 0;
    if (!onboarding_has_equipped_bag()) return 1;
    if (!onboarding_has_carried_ammo()) return 2;
    if (!onboarding_has_carried_medicine()) return 3;
    return 4;
}

function onboarding_update_loadout_progress()
{
    if (!progress_get_flag("starting_crate_claimed"))
    {
        onboarding_update_starting_crate_tip();
        return;
    }
    if (progress_get_flag("onboarding_loadout_complete"))
    {
        onboarding_update_start_raid_tip();
        return;
    }
    if (onboarding_get_loadout_step() < 4)
    {
        onboarding_update_loadout_tip();
        return;
    }
    tutorial_callout_hide();
    progress_set_flag("onboarding_loadout_complete", true);
    save_game();
}

function onboarding_update_start_raid_tip()
{
    if (hideout_page == HideoutPage.RAIDS)
    {
        tutorial_callout_hide();
        return;
    }
    tutorial_callout_show("Click here to start raid.", 25, onboarding_sidebar_callout_y(10), 350, 650, 620, 140);
}

function onboarding_sidebar_callout_y(_menu_index)
{
    return hideout_sidebar_item_top(_menu_index) + 21;
}

function onboarding_update_raid_door_tip()
{
    if (!onboarding_first_quest_active() || raid.state != RaidState.COMBAT
    || raid.current_room_type != RaidRoomType.START || !raid.doors_active
    || array_length(raid_doors) != 2 || overlay_mode != OverlayMode.NONE)
    {
        tutorial_callout_hide();
        return;
    }

    var _door_mid_x = (raid_doors[0].door_x + raid_doors[1].door_x) * 0.5;
    var _door_mid_y = (raid_doors[0].door_y + raid_doors[1].door_y) * 0.5;
    var _target_x = (_door_mid_x - camera_get_view_x(raid_camera))
        * display_get_gui_width() / camera_get_view_width(raid_camera);
    var _target_y = (_door_mid_y - camera_get_view_y(raid_camera))
        * display_get_gui_height() / camera_get_view_height(raid_camera);
    if (_target_x < 0 || _target_x > display_get_gui_width()
    || _target_y < 0 || _target_y > display_get_gui_height())
    {
        tutorial_callout_hide();
        return;
    }

    tutorial_callout_show("The door you choose is the next room's reward", _target_x, _target_y, 100, 420, 650, 140);
}

function onboarding_update_field_supplies_tip()
{
    var _progress = quest_get_progress("test_field_supplies");
    if (is_undefined(_progress) || !dialogue_get_flag("field_supplies_tutorial_started")) return;
    if (_progress.state != QuestState.ACTIVE)
    {
        tutorial_callout_hide();
        return;
    }
    if (variable_struct_get(workshop_progress, "salvage_bench") > 0)
    {
        if (hideout_page != HideoutPage.SALVAGE)
        {
            tutorial_callout_show("Open the salvage menu", 25, onboarding_sidebar_callout_y(4), 430, 225, 650, 140);
            return;
        }
        if (salvage_active)
        {
            tutorial_callout_hide();
            return;
        }

        var _salvageable_items = workshop_get_salvageable_items();
        var _radio_index = -1;
        for (var _item_index = 0; _item_index < array_length(_salvageable_items); _item_index++)
        {
            if (_salvageable_items[_item_index] == "broken_radio")
            {
                _radio_index = _item_index;
                break;
            }
        }
        if (_radio_index < inventory_scroll || _radio_index >= inventory_scroll + inventory_visible_rows)
        {
            tutorial_callout_hide();
            return;
        }
        var _radio_row = _radio_index - inventory_scroll;
        tutorial_callout_show("Click on the item to salvage it", 500, 187 + (_radio_row * 34), 980, 680, 650, 140);
        return;
    }
    if (!workshop_can_upgrade("salvage_bench"))
    {
        if (hideout_page == HideoutPage.STASH)
            tutorial_callout_show("Go to your stash and bank your extracted loot", 1595, 570, 500, 330, 650, 140);
        else
            tutorial_callout_show("Go to your stash and bank your extracted loot", 25, onboarding_sidebar_callout_y(2), 530, 305, 650, 140);
        return;
    }
    if (hideout_page != HideoutPage.WORKSHOP)
    {
        tutorial_callout_show("Go to the workshop tab and build the salvage table", 25, onboarding_sidebar_callout_y(9), 430, 290, 650, 140);
        return;
    }

    tutorial_callout_show("Click on the build button to construct the table", 1430, 524, 500, 620, 650, 140);
}

function onboarding_update_starting_crate_tip()
{
    if (!onboarding_first_quest_active() || trader_mode == TraderMode.CONVERSATION)
    {
        tutorial_callout_hide();
        return;
    }
    if (hideout_page != HideoutPage.STASH)
    {
        tutorial_callout_show("Click to open stash.", 25, onboarding_sidebar_callout_y(2), 50, 505, 620, 140);
        return;
    }
    if (inventory_context_active)
    {
        tutorial_callout_hide();
        return;
    }

    var _crates = stash_find_items("supply_crate");
    if (array_length(_crates) == 0)
    {
        tutorial_callout_hide();
        return;
    }

    var _crate = _crates[0];
    var _definition = item_get(_crate.item_key);
    var _crate_width = _crate.rotation == 90 ? _definition.grid_height : _definition.grid_width;
    var _crate_height = _crate.rotation == 90 ? _definition.grid_width : _definition.grid_height;
    var _grid_left = 1920 - 25 - (stash.grid_width * 60);
    var _target_x = _grid_left + ((_crate.x + _crate_width * 0.5) * 60);
    var _target_y = 150 + ((_crate.y + _crate_height * 0.5) * 60);
    tutorial_callout_show("Right click to open crate.", _target_x, _target_y, 500, 330, 650, 140);
}

function onboarding_update_loadout_tip()
{
    if (hideout_page != HideoutPage.STASH || trader_mode == TraderMode.CONVERSATION)
    {
        tutorial_callout_hide();
        return;
    }

    var _step = onboarding_get_loadout_step();
    var _callouts = [
        { message: "Equip a gun in a weapon slot", target_x: 575, target_y: 550, box_x: 1030, box_y: 425 },
        { message: "Equip a bag in the backpack slot", target_x: 890, target_y: 260, box_x: 1120, box_y: 185 },
        { message: "Move ammunition into your pockets or backpack", target_x: 845, target_y: 510, box_x: 1120, box_y: 435 },
        { message: "Move medical gear into your pockets or backpack", target_x: 845, target_y: 510, box_x: 1120, box_y: 590 }
    ];
    if (_step < 0 || _step >= array_length(_callouts)) return;

    var _callout = _callouts[_step];
    tutorial_callout_show(
        _callout.message,
        _callout.target_x,
        _callout.target_y,
        _callout.box_x,
        _callout.box_y,
        650,
        140
    );
}

function onboarding_get_total_item_quantity(_item_key)
{
    var _total = 0;
    var _containers = [stash, stash.pockets, stash.backpack, stash.secure_container];
    for (var _container_index = 0; _container_index < array_length(_containers); _container_index++)
    {
        var _items = _containers[_container_index].items;
        for (var _i = 0; _i < array_length(_items); _i++)
            if (_items[_i].item_key == _item_key) _total += _items[_i].quantity;
    }

    var _equipped = [stash.equipped_weapon_item, stash.equipped_weapon_2_item, stash.equipped_bag_item];
    for (var _i = 0; _i < array_length(_equipped); _i++)
        if (!is_undefined(_equipped[_i]) && _equipped[_i].item_key == _item_key) _total += _equipped[_i].quantity;
    return _total;
}

function onboarding_ensure_item_quantity(_item_key, _quantity)
{
    var _missing = max(0, _quantity - onboarding_get_total_item_quantity(_item_key));
    return _missing <= 0 || stash_add(_item_key, _missing);
}

function onboarding_deliver_replacement_kit()
{
    var _package = [
        { item_key: "pipe_pistol", quantity: 1 },
        { item_key: "ammo_9mm", quantity: 60 },
        { item_key: "sling_bag", quantity: 1 },
        { item_key: "bandage", quantity: 2 },
        { item_key: "tourniquet", quantity: 1 },
        { item_key: "medkit", quantity: 1 }
    ];
    for (var _i = 0; _i < array_length(_package); _i++)
    {
        var _item = _package[_i];
        if (!onboarding_ensure_item_quantity(_item.item_key, _item.quantity)) return false;
    }
    return true;
}

function onboarding_handle_raid_failure()
{
    if (!onboarding_first_quest_active()) return false;
    raid_result_heal_all();
    var _member = crew[0];
    _member.status = CrewStatus.READY;
    _member.injury_end_time = 0;
    crew[0] = _member;
    progress_set_flag("onboarding_replacement_pending", true);
    return true;
}

function onboarding_copy_stored_item(_item)
{
    var _copy = {
        item_key: _item.item_key,
        quantity: _item.quantity,
        x: _item.x,
        y: _item.y,
        rotation: _item.rotation
    };
    if (variable_struct_exists(_item, "durability")) _copy.durability = _item.durability;
    if (variable_struct_exists(_item, "servings")) _copy.servings = _item.servings;
    return _copy;
}

function onboarding_storage_add(_storage, _item_key, _quantity)
{
    var _definition = item_get(_item_key);
    if (is_undefined(_definition) || _quantity <= 0) return false;
    var _remaining = _quantity;
    var _max_stack = item_get_max_stack(_item_key);

    if (_definition.stackable)
    {
        var _existing = stash_find_items(_item_key, _storage);
        for (var _i = 0; _i < array_length(_existing) && _remaining > 0; _i++)
        {
            var _added = min(_remaining, max(0, _max_stack - _existing[_i].quantity));
            _existing[_i].quantity += _added;
            _remaining -= _added;
        }
    }

    while (_remaining > 0)
    {
        var _placed = stash_place_item(_item_key, -1, -1, 0, _storage);
        if (is_undefined(_placed)) _placed = stash_place_item(_item_key, -1, -1, 90, _storage);
        if (is_undefined(_placed)) return false;
        _placed.quantity = min(_remaining, _max_stack);
        _remaining -= _placed.quantity;
    }
    return true;
}

function onboarding_open_supply_crate(_crate, _container)
{
    if (progress_get_flag("starting_crate_claimed") || _container != stash || is_undefined(_crate)
    || _crate.item_key != "supply_crate") return false;

    var _result = { grid_width: stash.grid_width, grid_height: stash.grid_height, items: [] };
    for (var _i = 0; _i < array_length(stash.items); _i++)
        if (stash.items[_i] != _crate) array_push(_result.items, onboarding_copy_stored_item(stash.items[_i]));

    var _package = [
        { item_key: "pipe_pistol", quantity: 1 },
        { item_key: "ammo_9mm", quantity: 100 },
        { item_key: "sling_bag", quantity: 1 },
        { item_key: "bandage", quantity: 2 },
        { item_key: "tourniquet", quantity: 1 },
        { item_key: "medkit", quantity: 1 }
    ];

    for (var _reward_index = 0; _reward_index < array_length(_package); _reward_index++)
    {
        var _reward = _package[_reward_index];
        if (!onboarding_storage_add(_result, _reward.item_key, _reward.quantity)) return false;
    }

    stash.items = _result.items;
    inventory_context_menu_close();
    progress_set_flag("starting_crate_claimed", true);
    save_game();
    return true;
}
