function step_raid_result()
{
    var _layout = raid_result_get_layout();
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var _heal_hovered = point_in_rectangle(
        _mouse_x,
        _mouse_y,
        _layout.heal_left,
        _layout.button_top,
        _layout.heal_right,
        _layout.button_bottom
    );
    var _continue_hovered = point_in_rectangle(
        _mouse_x,
        _mouse_y,
        _layout.continue_left,
        _layout.button_top,
        _layout.continue_right,
        _layout.button_bottom
    );
    var _heal_enabled = trader_is_unlocked("sawbones");
    var _hover_key = _heal_hovered && _heal_enabled ? "heal" : (_continue_hovered ? "continue" : "");
    ui_hover_sound("raid_result_buttons", _hover_key);
    if (!mouse_check_button_pressed(mb_left)) return;

    if (_heal_hovered)
    {
        if (!_heal_enabled) return;
        var _quote = raid_result_get_treatment_quote();
        if (_quote.total > 0 && spend_cash(_quote.total))
        {
            raid_result_heal_all();
            save_game();
        }
        return;
    }

    if (_continue_hovered)
    {
        audio_play_sound(snd_interact, 0, false);
        raid_result_continue();
    }
}

function raid_result_get_layout()
{
    var _gui_width = display_get_gui_width();
    var _gui_height = display_get_gui_height();
    var _content_left = max(40, (_gui_width - 1700) * 0.5);
    var _panel_left = _content_left + 560;
    var _panel_right = _gui_width - _content_left;
    var _button_top = min(_gui_height - 100, 890);
    var _button_width = 220;
    var _button_gap = 20;

    return {
        content_left: _content_left,
        health_top: 175,
        panel_left: _panel_left,
        panel_right: _panel_right,
        button_top: _button_top,
        button_bottom: _button_top + 54,
        heal_left: _panel_right - ((_button_width * 2) + _button_gap),
        heal_right: _panel_right - (_button_width + _button_gap),
        continue_left: _panel_right - _button_width,
        continue_right: _panel_right
    };
}

function raid_result_get_treatment_quote()
{
    var _missing_health = max(0, raid_player_max_hp - raid_player_hp);
    var _heavy_bleeds = 0;
    var _light_bleeds = 0;
    var _fractures = 0;
    var _blacked_limbs = 0;

    for (var i = 0; i < array_length(health_limbs); i++)
    {
        var _limb = health_limbs[i];
        _missing_health += max(0, _limb.max_hp - _limb.hp);
        _heavy_bleeds += player_health_limb_bleed_count(_limb, LimbBleedState.HEAVY);
        _light_bleeds += player_health_limb_bleed_count(_limb, LimbBleedState.LIGHT);
        if (_limb.fractured) _fractures++;
        if (_limb.injury == LimbInjuryState.BLACKED_OUT) _blacked_limbs++;
    }

    var _cost_multiplier = 0.15;
    var _health_cost = ceil(_missing_health * 1.2 * _cost_multiplier);
    var _heavy_cost = ceil(_heavy_bleeds * 90 * _cost_multiplier);
    var _light_cost = ceil(_light_bleeds * 45 * _cost_multiplier);
    var _fracture_cost = ceil(_fractures * 150 * _cost_multiplier);
    var _blacked_cost = ceil(_blacked_limbs * 240 * _cost_multiplier);

    return {
        missing_health: _missing_health,
        health_cost: _health_cost,
        heavy_bleeds: _heavy_bleeds,
        heavy_cost: _heavy_cost,
        light_bleeds: _light_bleeds,
        light_cost: _light_cost,
        fractures: _fractures,
        fracture_cost: _fracture_cost,
        blacked_limbs: _blacked_limbs,
        blacked_cost: _blacked_cost,
        total: _health_cost + _heavy_cost + _light_cost + _fracture_cost + _blacked_cost
    };
}

function raid_result_heal_all()
{
    raid_player_hp = raid_player_max_hp;
    for (var i = 0; i < array_length(health_limbs); i++)
    {
        var _limb = health_limbs[i];
        _limb.hp = _limb.max_hp;
        _limb.fractured = false;
        _limb.bleeds = [];
        _limb.bleed = LimbBleedState.NONE;
        player_health_update_limb_state(_limb);
        health_limbs[i] = _limb;
    }
    player_health_sync_crew();
    save_mark_dirty();
}

function raid_result_continue()
{
    player_health_recover_blacked_limbs();
    player_health_sync_crew();
    var _first_quest = quest_get_progress("test_safe_return");
    var _first_quest_ready = !is_undefined(_first_quest) && _first_quest.state == QuestState.READY_TO_TURN_IN;
    hideout_menu_index = 2;
    hideout_page = HideoutPage.STASH;
    hideout_focus = HideoutFocus.CONTENT;
    raid_set_state(RaidState.INACTIVE);
    state = GameState.HIDEOUT;
    if (_first_quest_ready) onboarding_open_mara_node("ghost_first_quest_return");
    save_game();
}
