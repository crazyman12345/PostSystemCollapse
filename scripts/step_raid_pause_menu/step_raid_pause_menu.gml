function step_raid_pause_menu()
{
    var _fps_options = [60, 120, 144, 165, 240];
    var _graphics_keys = [
        "dynamic_lighting", "muzzle_flash_lighting", "ambient_darkness", "colored_lighting", "light_falloff",
        "environment_shadows", "character_shadows", "contact_shadows",
        "smoke_effects", "blood_effects", "death_gibs", "projectile_glow", "projectile_lighting", "bloom"
    ];
    var _gui_width = display_get_gui_width();
    var _gui_height = display_get_gui_height();
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);
    var _mouse_clicked = mouse_check_button_pressed(mb_left);

    if (keyboard_check_pressed(vk_escape))
    {
        audio_play_sound(snd_interact, 0, false);
        raid_set_state(RaidState.COMBAT);
        return;
    }

    var _tab_change = keyboard_check_pressed(ord("E")) - keyboard_check_pressed(ord("Q"));
    if (_mouse_clicked && point_in_rectangle(_mouse_x, _mouse_y, _gui_width * 0.34, _gui_height * 0.22, _gui_width * 0.49, _gui_height * 0.29))
        _tab_change = raid.pause_menu_tab == 0 ? 0 : -1;
    else if (_mouse_clicked && point_in_rectangle(_mouse_x, _mouse_y, _gui_width * 0.51, _gui_height * 0.22, _gui_width * 0.66, _gui_height * 0.29))
        _tab_change = raid.pause_menu_tab == 1 ? 0 : 1;

    if (_tab_change != 0)
    {
        raid.pause_menu_tab = 1 - raid.pause_menu_tab;
        scroll_sound();
        return;
    }

    if (raid.pause_menu_tab == 1)
    {
        var _option_count = 29;
        var _visible_rows = 12;
        var _hover_index = -1;
        var _first_y = _gui_height * 0.32;
        var _row_step = _gui_height * 0.043;
        if (_mouse_x >= _gui_width * 0.28 && _mouse_x <= _gui_width * 0.72)
        {
            for (var _hover_row = 0; _hover_row < _visible_rows; _hover_row++)
            {
                var _graphics_index = raid.pause_graphics_scroll + _hover_row;
                if (_graphics_index >= _option_count) break;
                var _row_y = _first_y + _hover_row * _row_step;
                if (_mouse_y >= _row_y - 5 && _mouse_y < _row_y + _row_step - 5) _hover_index = _graphics_index;
            }
        }

        if (_hover_index != -1 && raid.pause_graphics_index != _hover_index)
        {
            raid.pause_graphics_index = _hover_index;
            scroll_sound();
        }

        var _menu_move = keyboard_check_pressed(ord("S")) - keyboard_check_pressed(ord("W"));
        if (_mouse_x >= _gui_width * 0.25 && _mouse_x <= _gui_width * 0.75)
            _menu_move += mouse_wheel_down() - mouse_wheel_up();
        if (_menu_move != 0)
        {
            raid.pause_graphics_index = (raid.pause_graphics_index + sign(_menu_move) + _option_count) mod _option_count;
            scroll_sound();
        }

        if (raid.pause_graphics_index < raid.pause_graphics_scroll)
            raid.pause_graphics_scroll = raid.pause_graphics_index;
        else if (raid.pause_graphics_index >= raid.pause_graphics_scroll + _visible_rows)
            raid.pause_graphics_scroll = raid.pause_graphics_index - _visible_rows + 1;
        raid.pause_graphics_scroll = clamp(raid.pause_graphics_scroll, 0, _option_count - _visible_rows);

        var _option_change = (keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right))
            - (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left));
        var _confirm = keyboard_check_pressed(vk_enter) || (_mouse_clicked && _hover_index != -1);
        var _index = raid.pause_graphics_index;

        if (_index == 0 && (_option_change != 0 || _confirm))
        {
            var _fps_change = _option_change != 0 ? _option_change : 1;
            raid.pause_fps_index = (raid.pause_fps_index + _fps_change + array_length(_fps_options)) mod array_length(_fps_options);
            game_set_speed(_fps_options[raid.pause_fps_index], gamespeed_fps);
            scroll_sound();
        }
        else if (_index >= 1 && _index <= 14 && (_option_change != 0 || _confirm))
        {
            graphics_settings_toggle(_graphics_keys[_index - 1]);
            scroll_sound();
        }
        else if (_index >= 15 && _index <= 17 && (_option_change != 0 || _confirm))
        {
            var _brightness_key = _index == 15 ? "player_minimum_brightness"
                : (_index == 16 ? "enemy_minimum_brightness" : "attack_ring_minimum_brightness");
            var _brightness_value = variable_struct_get(global.graphics_settings, _brightness_key);
            var _brightness_slider_left = _gui_width * 0.5 + 150;
            var _brightness_slider_width = 90;

            if (_mouse_clicked && _hover_index == _index
            && _mouse_x >= _brightness_slider_left - 5 && _mouse_x <= _brightness_slider_left + _brightness_slider_width + 5)
            {
                var _brightness_progress = clamp((_mouse_x - _brightness_slider_left) / _brightness_slider_width, 0, 1);
                _brightness_value = round(_brightness_progress * 20) / 20;
            }
            else
            {
                var _brightness_change = _option_change != 0 ? _option_change : 1;
                _brightness_value = clamp(round((_brightness_value + _brightness_change * 0.05) * 20) / 20, 0, 1);
            }

            graphics_settings_set(_brightness_key, _brightness_value);
            scroll_sound();
        }
        else if (_index == 18 && (_option_change != 0 || _confirm))
        {
            if (_confirm && _option_change == 0)
                raid_bloom_intensity = raid_bloom_intensity >= 3 ? 0 : round((raid_bloom_intensity + 0.1) * 10) / 10;
            else raid_bloom_intensity = clamp(round((raid_bloom_intensity + _option_change * 0.1) * 10) / 10, 0, 3);
            scroll_sound();
        }
        else if (_index == 19 && (_option_change != 0 || _confirm))
        {
            raid_bloom_blur_radius = _confirm && _option_change == 0
                ? (raid_bloom_blur_radius >= 16 ? 0 : raid_bloom_blur_radius + 1)
                : clamp(raid_bloom_blur_radius + _option_change, 0, 16);
            scroll_sound();
        }
        else if (_index == 20 && (_option_change != 0 || _confirm))
        {
            if (_confirm && _option_change == 0)
                raid_bloom_projectile_intensity = raid_bloom_projectile_intensity >= 3 ? 0 : round((raid_bloom_projectile_intensity + 0.1) * 10) / 10;
            else raid_bloom_projectile_intensity = clamp(round((raid_bloom_projectile_intensity + _option_change * 0.1) * 10) / 10, 0, 3);
            scroll_sound();
        }
        else if (_index == 21 && (_option_change != 0 || _confirm))
        {
            raid_bloom_projectile_blur_radius = _confirm && _option_change == 0
                ? (raid_bloom_projectile_blur_radius >= 16 ? 0 : raid_bloom_projectile_blur_radius + 1)
                : clamp(raid_bloom_projectile_blur_radius + _option_change, 0, 16);
            scroll_sound();
        }
        else if (_index == 22 && (_option_change != 0 || _confirm))
        {
            raid_bloom_blur_passes = _confirm && _option_change == 0
                ? (raid_bloom_blur_passes >= 4 ? 1 : raid_bloom_blur_passes + 1)
                : clamp(raid_bloom_blur_passes + _option_change, 1, 4);
            scroll_sound();
        }
        else if (_index >= 23 && _index <= 25 && (_option_change != 0 || _confirm))
        {
            var _slider_min = _index == 23 ? 0 : 0.5;
            var _slider_max = _index == 23 ? 2 : 1.5;
            var _slider_value = _index == 23
                ? raid_color_grade_saturation
                : (_index == 24 ? raid_color_grade_contrast : raid_color_grade_brightness);
            var _slider_left = _gui_width * 0.5 + 150;
            var _slider_width = 90;

            if (_mouse_clicked && _hover_index == _index
            && _mouse_x >= _slider_left - 5 && _mouse_x <= _slider_left + _slider_width + 5)
            {
                var _slider_progress = clamp((_mouse_x - _slider_left) / _slider_width, 0, 1);
                _slider_value = round(lerp(_slider_min, _slider_max, _slider_progress) * 20) / 20;
            }
            else
            {
                var _slider_change = _option_change != 0 ? _option_change : 1;
                _slider_value = clamp(round((_slider_value + _slider_change * 0.05) * 20) / 20, _slider_min, _slider_max);
            }

            if (_index == 23) raid_color_grade_saturation = _slider_value;
            else if (_index == 24) raid_color_grade_contrast = _slider_value;
            else raid_color_grade_brightness = _slider_value;
            scroll_sound();
        }
        else if (_index == 26 && (_option_change != 0 || _confirm))
        {
            var _blood_brightness = global.graphics_settings.blood_minimum_brightness;
            var _slider_left = _gui_width * 0.5 + 150;
            var _slider_width = 90;

            if (_mouse_clicked && _hover_index == _index
            && _mouse_x >= _slider_left - 5 && _mouse_x <= _slider_left + _slider_width + 5)
            {
                var _slider_progress = clamp((_mouse_x - _slider_left) / _slider_width, 0, 1);
                _blood_brightness = round(_slider_progress * 20) / 20;
            }
            else
            {
                var _slider_change = _option_change != 0 ? _option_change : 1;
                _blood_brightness = clamp(round((_blood_brightness + _slider_change * 0.05) * 20) / 20, 0, 1);
            }

            graphics_settings_set("blood_minimum_brightness", _blood_brightness);
            scroll_sound();
        }
        else if (_confirm && _index == 27)
        {
            graphics_settings_restore_defaults();
            raid.pause_fps_index = 1;
            game_set_speed(_fps_options[raid.pause_fps_index], gamespeed_fps);
            raid_bloom_intensity = 0.6;
            raid_bloom_blur_radius = 3;
            raid_bloom_blur_passes = 2;
            raid_bloom_projectile_intensity = 0.8;
            raid_bloom_projectile_blur_radius = 3;
            raid_color_grade_saturation = 1.30;
            raid_color_grade_contrast = 1.15;
            raid_color_grade_brightness = 1.0;
            audio_play_sound(snd_interact, 0, false);
        }
        else if (_confirm && _index == 28)
        {
            audio_play_sound(snd_interact, 0, false);
            raid_set_state(RaidState.COMBAT);
        }
        return;
    }

    var _hover_index = -1;
    if (_mouse_x >= _gui_width * 0.25 && _mouse_x <= _gui_width * 0.75)
    {
        if (_mouse_y >= _gui_height * 0.34 && _mouse_y < _gui_height * 0.41) _hover_index = 0;
        else if (_mouse_y >= _gui_height * 0.46 && _mouse_y < _gui_height * 0.53) _hover_index = 1;
        else if (_mouse_y >= _gui_height * 0.58 && _mouse_y < _gui_height * 0.65) _hover_index = 2;
    }

    if (_hover_index != -1 && raid.pause_menu_index != _hover_index)
    {
        raid.pause_menu_index = _hover_index;
        scroll_sound();
    }

    var _menu_move = keyboard_check_pressed(ord("S")) - keyboard_check_pressed(ord("W"));
    if (_menu_move != 0)
    {
        raid.pause_menu_index = (raid.pause_menu_index + _menu_move + 3) mod 3;
        scroll_sound();
    }

    var _option_change = (keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right))
        - (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left));
    if (_mouse_clicked && raid.pause_menu_index == 1)
    {
        var _music_y = _gui_height * 0.49;
        if (point_in_rectangle(_mouse_x, _mouse_y, _gui_width * 0.5 - 57, _music_y - 8, _gui_width * 0.5 - 13, _music_y + 32)) _option_change = -1;
        if (point_in_rectangle(_mouse_x, _mouse_y, _gui_width * 0.5 + 13, _music_y - 8, _gui_width * 0.5 + 57, _music_y + 32)) _option_change = 1;
    }

    if (raid.pause_menu_index == 1 && _option_change != 0)
    {
        music_volume = clamp(music_volume + _option_change * 10, 0, 100);
        audio_sound_gain(music_instance, music_volume / 100, 0);
        scroll_sound();
    }

    var _keyboard_confirm = keyboard_check_pressed(vk_enter);
    var _mouse_confirm = _mouse_clicked && (_hover_index == 0 || _hover_index == 2);
    if (!_keyboard_confirm && !_mouse_confirm) return;
    audio_play_sound(snd_interact, 0, false);

    if (raid.pause_menu_index == 0) raid_combat_loss();
    else if (raid.pause_menu_index == 1 && _keyboard_confirm)
    {
        music_volume -= 10;
        if (music_volume < 0) music_volume = 100;
        audio_sound_gain(music_instance, music_volume / 100, 0);
    }
    else raid_set_state(RaidState.COMBAT);
}
