function step_raid_pause_menu()
{
    var _fps_options = [60, 120, 144, 165, 240];
    var _gui_width = display_get_gui_width();
    var _gui_height = display_get_gui_height();
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var _hover_index = -1;

    if (_mouse_x >= _gui_width * 0.25 && _mouse_x <= _gui_width * 0.75)
    {
        if (_mouse_y >= _gui_height * 0.30 && _mouse_y < _gui_height * 0.36) _hover_index = 0;
        else if (_mouse_y >= _gui_height * 0.37 && _mouse_y < _gui_height * 0.43) _hover_index = 1;
        else if (_mouse_y >= _gui_height * 0.43 && _mouse_y < _gui_height * 0.49) _hover_index = 2;
        else if (_mouse_y >= _gui_height * 0.49 && _mouse_y < _gui_height * 0.55) _hover_index = 3;
        else if (_mouse_y >= _gui_height * 0.55 && _mouse_y < _gui_height * 0.61) _hover_index = 4;
        else if (_mouse_y >= _gui_height * 0.61 && _mouse_y < _gui_height * 0.67) _hover_index = 5;
        else if (_mouse_y >= _gui_height * 0.67 && _mouse_y < _gui_height * 0.73) _hover_index = 6;
        else if (_mouse_y >= _gui_height * 0.74 && _mouse_y < _gui_height * 0.80) _hover_index = 7;
    }

    if (_hover_index != -1 && raid.pause_menu_index != _hover_index)
    {
        raid.pause_menu_index = _hover_index;
        scroll_sound();
    }

    if (keyboard_check_pressed(vk_escape))
    {
        audio_play_sound(snd_interact, 0, false);
        raid_set_state(RaidState.COMBAT);
        return;
    }

    var _menu_move = keyboard_check_pressed(ord("S")) - keyboard_check_pressed(ord("W"));
    if (_menu_move != 0)
    {
        raid.pause_menu_index += _menu_move;
        if (raid.pause_menu_index < 0) raid.pause_menu_index = 7;
        if (raid.pause_menu_index > 7) raid.pause_menu_index = 0;
        scroll_sound();
    }

    var _option_change = (keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right))
        - (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left));
    var _mouse_clicked = mouse_check_button_pressed(mb_left);

    if (_mouse_clicked && raid.pause_menu_index >= 1 && raid.pause_menu_index <= 6)
    {
        var _option_y = _gui_height * (0.34 + raid.pause_menu_index * 0.06);
        if (point_in_rectangle(_mouse_x, _mouse_y, _gui_width * 0.5 - 57, _option_y - 8, _gui_width * 0.5 - 13, _option_y + 32)) _option_change = -1;
        if (point_in_rectangle(_mouse_x, _mouse_y, _gui_width * 0.5 + 13, _option_y - 8, _gui_width * 0.5 + 57, _option_y + 32)) _option_change = 1;
    }

    if (raid.pause_menu_index == 1 && _option_change != 0)
    {
        raid.pause_fps_index += _option_change;
        if (raid.pause_fps_index < 0) raid.pause_fps_index = array_length(_fps_options) - 1;
        if (raid.pause_fps_index >= array_length(_fps_options)) raid.pause_fps_index = 0;
        game_set_speed(_fps_options[raid.pause_fps_index], gamespeed_fps);
        scroll_sound();
    }

    if (raid.pause_menu_index == 2 && _option_change != 0)
    {
        music_volume = clamp(music_volume + _option_change * 10, 0, 100);
        audio_sound_gain(music_instance, music_volume / 100, 0);
        scroll_sound();
    }

    if (raid.pause_menu_index == 3 && _option_change != 0)
    {
        raid_bloom_enabled = !raid_bloom_enabled;
        scroll_sound();
    }

    if (raid.pause_menu_index == 4 && _option_change != 0)
    {
        raid_bloom_intensity = clamp(round((raid_bloom_intensity + _option_change * 0.1) * 10) / 10, 0, 3);
        scroll_sound();
    }

    if (raid.pause_menu_index == 5 && _option_change != 0)
    {
        raid_bloom_blur_radius = clamp(raid_bloom_blur_radius + _option_change, 0, 16);
        scroll_sound();
    }

    if (raid.pause_menu_index == 6 && _option_change != 0)
    {
        raid_bloom_blur_passes = clamp(raid_bloom_blur_passes + _option_change, 1, 4);
        scroll_sound();
    }

    var _keyboard_confirm = keyboard_check_pressed(vk_enter);
    var _mouse_confirm = _mouse_clicked && (_hover_index == 0 || _hover_index == 7);
    if (!_keyboard_confirm && !_mouse_confirm) return;

    audio_play_sound(snd_interact, 0, false);

    if (raid.pause_menu_index == 0)
    {
        raid_combat_loss();
    }
    else if (raid.pause_menu_index == 1 && _keyboard_confirm)
    {
        raid.pause_fps_index = (raid.pause_fps_index + 1) mod array_length(_fps_options);
        game_set_speed(_fps_options[raid.pause_fps_index], gamespeed_fps);
    }
    else if (raid.pause_menu_index == 2 && _keyboard_confirm)
    {
        music_volume -= 10;
        if (music_volume < 0) music_volume = 100;
        audio_sound_gain(music_instance, music_volume / 100, 0);
    }
    else if (raid.pause_menu_index == 3 && _keyboard_confirm)
    {
        raid_bloom_enabled = !raid_bloom_enabled;
    }
    else if (raid.pause_menu_index == 4 && _keyboard_confirm)
    {
        raid_bloom_intensity = raid_bloom_intensity >= 3 ? 0 : round((raid_bloom_intensity + 0.1) * 10) / 10;
    }
    else if (raid.pause_menu_index == 5 && _keyboard_confirm)
    {
        raid_bloom_blur_radius = raid_bloom_blur_radius >= 16 ? 0 : raid_bloom_blur_radius + 1;
    }
    else if (raid.pause_menu_index == 6 && _keyboard_confirm)
    {
        raid_bloom_blur_passes = raid_bloom_blur_passes >= 4 ? 1 : raid_bloom_blur_passes + 1;
    }
    else
    {
        raid_set_state(RaidState.COMBAT);
    }
}
