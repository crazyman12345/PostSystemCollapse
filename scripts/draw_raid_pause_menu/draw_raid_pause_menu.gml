function draw_raid_pause_menu()
{
    var _gui_width = display_get_gui_width();
    var _gui_height = display_get_gui_height();
    var _panel_left = _gui_width * 0.25;
    var _panel_top = _gui_height * 0.14;
    var _panel_right = _gui_width * 0.75;
    var _panel_bottom = _gui_height * 0.94;

    draw_set_color(c_black);
    draw_set_alpha(0.75);
    draw_rectangle(0, 0, _gui_width, _gui_height, false);
    draw_set_alpha(1);

    draw_set_color(c_black);
    draw_rectangle(_panel_left, _panel_top, _panel_right, _panel_bottom, false);
    draw_set_color(c_lime);
    draw_rectangle(_panel_left, _panel_top, _panel_right, _panel_bottom, true);
    draw_set_halign(fa_center);
    draw_text(_gui_width * 0.5, _gui_height * 0.19, "PAUSED");

    var _general_tab = raid.pause_menu_tab == 0 ? "> GENERAL <" : "GENERAL";
    var _graphics_tab = raid.pause_menu_tab == 1 ? "> GRAPHICS <" : "GRAPHICS";
    draw_text(_gui_width * 0.42, _gui_height * 0.25, _general_tab);
    draw_text(_gui_width * 0.58, _gui_height * 0.25, _graphics_tab);
    draw_line(_gui_width * 0.31, _gui_height * 0.29, _gui_width * 0.69, _gui_height * 0.29);

    if (raid.pause_menu_tab == 0)
    {
        var _leave_text = raid.pause_menu_index == 0
            ? "> LEAVE RAID (LOSE ALL GEAR) <"
            : "LEAVE RAID (LOSE ALL GEAR)";
        var _continue_text = raid.pause_menu_index == 2 ? "> CONTINUE <" : "CONTINUE";
        draw_text(_gui_width * 0.5, _gui_height * 0.37, _leave_text);

        var _music_y = _gui_height * 0.49;
        if (raid.pause_menu_index == 1)
        {
            draw_text(_gui_width * 0.5 - 190, _music_y, ">");
            draw_text(_gui_width * 0.5 + 190, _music_y, "<");
        }
        draw_text(_gui_width * 0.5 - 145, _music_y, "MUSIC:");
        draw_text(_gui_width * 0.5 - 35, _music_y, "<");
        draw_text(_gui_width * 0.5, _music_y, string(music_volume) + "%");
        draw_text(_gui_width * 0.5 + 35, _music_y, ">");
        draw_text(_gui_width * 0.5, _gui_height * 0.61, _continue_text);
    }
    else
    {
        var _settings = global.graphics_settings;
        var _fps_options = [60, 120, 144, 165, 240];
        var _labels = [
            "FPS", "DYNAMIC LIGHTING", "MUZZLE FLASH LIGHTING", "AMBIENT DARKNESS", "COLORED LIGHTING", "LIGHT FALLOFF",
            "ENVIRONMENTAL SHADOWS", "CHARACTER SHADOWS", "CONTACT SHADOWS", "SMOKE EFFECTS",
            "BLOOD EFFECTS", "DEATH GIBS", "PROJECTILE GLOW", "PROJECTILE LIGHTING", "BLOOM",
            "PLAYER MINIMUM BRIGHTNESS", "ENEMY MINIMUM BRIGHTNESS", "ATTACK RING MINIMUM BRIGHTNESS", "BLOOM INTENSITY",
            "BLUR RADIUS", "PROJECTILE BLOOM INTENSITY", "PROJECTILE BLUR RADIUS", "BLUR PASSES", "SATURATION", "CONTRAST", "BRIGHTNESS",
            "RESTORE DEFAULTS", "CONTINUE"
        ];
        var _values = [
            string(_fps_options[raid.pause_fps_index]),
            _settings.dynamic_lighting ? "ON" : "OFF",
            _settings.muzzle_flash_lighting ? "ON" : "OFF",
            _settings.ambient_darkness ? "ON" : "OFF",
            _settings.colored_lighting ? "ON" : "OFF",
            _settings.light_falloff ? "ON" : "OFF",
            _settings.environment_shadows ? "ON" : "OFF",
            _settings.character_shadows ? "ON" : "OFF",
            _settings.contact_shadows ? "ON" : "OFF",
            _settings.smoke_effects ? "ON" : "OFF",
            _settings.blood_effects ? "ON" : "OFF",
            _settings.death_gibs ? "ON" : "OFF",
            _settings.projectile_glow ? "ON" : "OFF",
            _settings.projectile_lighting ? "ON" : "OFF",
            _settings.bloom ? "ON" : "OFF",
            string(round(_settings.player_minimum_brightness * 100)) + "%",
            string(round(_settings.enemy_minimum_brightness * 100)) + "%",
            string(round(_settings.attack_ring_minimum_brightness * 100)) + "%",
            string_format(raid_bloom_intensity, 1, 1),
            string(raid_bloom_blur_radius),
            string_format(raid_bloom_projectile_intensity, 1, 1),
            string(raid_bloom_projectile_blur_radius),
            string(raid_bloom_blur_passes),
            string_format(raid_color_grade_saturation, 1, 2),
            string_format(raid_color_grade_contrast, 1, 2),
            string_format(raid_color_grade_brightness, 1, 2),
            "", ""
        ];
        var _visible_rows = 12;
        var _label_x = _gui_width * 0.5 - 210;
        var _value_x = _gui_width * 0.5 + 150;
        var _row_step = _gui_height * 0.043;
        var _first_y = _gui_height * 0.32;
        var _last_index = min(array_length(_labels), raid.pause_graphics_scroll + _visible_rows);

        draw_set_halign(fa_left);
        for (var _graphics_index = raid.pause_graphics_scroll; _graphics_index < _last_index; _graphics_index++)
        {
            var _visible_index = _graphics_index - raid.pause_graphics_scroll;
            var _row_y = _first_y + _visible_index * _row_step;
            var _prefix = raid.pause_graphics_index == _graphics_index ? "> " : "  ";
            draw_text(_label_x, _row_y, _prefix + _labels[_graphics_index]);
            if ((_graphics_index >= 15 && _graphics_index <= 17)
            || (_graphics_index >= 23 && _graphics_index <= 25))
            {
                var _character_brightness_slider = _graphics_index <= 17;
                var _slider_value = _character_brightness_slider
                    ? (_graphics_index == 15 ? _settings.player_minimum_brightness
                        : (_graphics_index == 16 ? _settings.enemy_minimum_brightness : _settings.attack_ring_minimum_brightness))
                    : (_graphics_index == 23 ? raid_color_grade_saturation
                        : (_graphics_index == 24 ? raid_color_grade_contrast : raid_color_grade_brightness));
                var _slider_min = _character_brightness_slider || _graphics_index == 23 ? 0 : 0.5;
                var _slider_max = _character_brightness_slider ? 1 : (_graphics_index == 23 ? 2 : 1.5);
                var _slider_progress = clamp((_slider_value - _slider_min) / (_slider_max - _slider_min), 0, 1);
                var _slider_width = 90;
                var _slider_y = _row_y + 10;
                var _slider_knob_x = _value_x + _slider_width * _slider_progress;
                draw_line(_value_x, _slider_y, _value_x + _slider_width, _slider_y);
                draw_rectangle(_slider_knob_x - 2, _slider_y - 5, _slider_knob_x + 2, _slider_y + 5, false);
                draw_text(_value_x + _slider_width + 12, _row_y, _values[_graphics_index]);
            }
            else if (_graphics_index < 26) draw_text(_value_x, _row_y, _values[_graphics_index]);
        }

        draw_set_halign(fa_center);
        if (raid.pause_graphics_scroll > 0) draw_text(_gui_width * 0.70, _first_y, "^");
        if (_last_index < array_length(_labels)) draw_text(_gui_width * 0.70, _first_y + (_visible_rows - 1) * _row_step, "v");
        draw_text(_gui_width * 0.5, _gui_height * 0.85, "[" + string(raid.pause_graphics_index + 1) + "/" + string(array_length(_labels)) + "]");
    }
    draw_set_halign(fa_left);
}
