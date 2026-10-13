function step_raid_combat_input()
{
    var _allow_combat_input = overlay_mode == OverlayMode.NONE;

    step_handle_shortcuts();
    if (raid.state != RaidState.COMBAT) return false;

    if (keyboard_check_pressed(vk_tab)) overlay_toggle(OverlayMode.LOADOUT);
    _allow_combat_input = _allow_combat_input && overlay_mode == OverlayMode.NONE;

    if (overlay_mode != OverlayMode.NONE)
    {
        step_overlay();
        if (raid.state != RaidState.COMBAT) return false;
    }

    step_raid_hotbar(_allow_combat_input);

    if (_allow_combat_input && keyboard_check_pressed(vk_escape))
    {
        audio_play_sound(snd_interact, 0, false);
        raid_set_state(RaidState.PAUSED);
        return false;
    }

    if (raid_gun_tuning_active && _allow_combat_input)
    {
        step_raid_gun_tuning();
        return false;
    }

    return _allow_combat_input;
}
